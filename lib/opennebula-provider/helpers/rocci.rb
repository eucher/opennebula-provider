require 'occi-api'

module VagrantPlugins
  module OpenNebulaProvider
    module Helpers
      module Rocci
        def rocci(provider_config)
          @rocci ||= RocciApi.new(@machine, provider_config)
        end
      end

      class RocciApi
        include Vagrant::Util::Retryable

        def initialize(machine, provider_config)
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::helpers::rocciapi')
          @config = provider_config
          options = {
            endpoint: @config.endpoint,
            auth: {
              type: @config.auth,
              username: @config.username,
              password: @config.password
            }
#              :log => {
#              :out   => STDERR,
#              :level => Occi::Api::Log::DEBUG
#            }
          }
          begin
            @rocci = Occi::Api::Client::ClientHttp.new(options)
          rescue Errno::ECONNREFUSED => e
            raise Errors::ConnectError, error: e
          rescue Occi::Api::Client::Errors::AuthnError => e
            raise Errors::AuthError, error: e
          end
        end

        def compute
          @logger.info 'compute!'
          cmpt = @rocci.get_resource 'compute'
          os = @rocci.get_mixin @config.os_tpl, 'os_tpl'
          size = @rocci.get_mixin @config.resource_tpl, 'resource_tpl'
          cmpt.mixins << os << size
          cmpt.title = @config.title if @config.title
          cmpt_loc = @rocci.create cmpt
          @logger.info "Location of new compute resource: #{cmpt_loc}"
          cmpt_loc
        rescue RuntimeError => e
          case e.message
          when /(?<ms>\[VirtualMachineAllocate\])/
            message_scope = $LAST_MATCH_INFO[:ms]
            case e.message
            when /quota/
              raise Errors::QuotaError, error: e.message.split(message_scope)[1].to_s
            else
              raise Errors::AllocateError, error: e
            end
          end
          raise Errors::ComputeError, error: e
        end

        def delete(id)
          @logger.info 'delete!'
          @rocci.delete id
        end

        def describe_resource(resource)
          @rocci.describe resource
        end

        def machine_state(id)
          if id
            begin
              desc = @rocci.describe id
            rescue ArgumentError => e
              raise Errors::ResourceError, error: e
            end
            return :not_created if desc.empty?
            return desc.first.attributes.occi.compute.state
          else
            return :not_created
          end
        end

        def ssh_info(id)
          desc = describe_resource(id)
          networkinterface = desc.first.links.map do |link|
            if link.attributes.occi.key?(:networkinterface)
              link.attributes.occi.networkinterface
            else
              nil
            end
          end.reject! { |n| n.nil? }.first
          networkinterface[:address]
        end

        def wait_for_event(env, id)
          retryable(tries: 120, sleep: 10) do
            # stop waiting if interrupted
            next if env[:interrupted]

            # check event status
            result = machine_state(id)

            yield result if block_given?
            fail 'not ready' if result != 'active'
          end
        end
      end
    end
  end
end
