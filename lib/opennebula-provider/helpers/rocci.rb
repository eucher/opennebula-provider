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
              #:out   => STDERR,
              #:level => Occi::Api::Log::DEBUG
#            }
          }
          @rocci = Occi::Api::Client::ClientHttp.new(options)
        end

        def compute
          @logger.info 'compute!'
          cmpt = @rocci.get_resource 'compute'
          os = @rocci.get_mixin @config.os_tpl, 'os_tpl'
          size = @rocci.get_mixin @config.resource_tpl, 'resource_tpl'
          cmpt.mixins << os << size
          cmpt.title = 'testROCCIvagrant'
          cmpt_loc = @rocci.create cmpt
          @logger.info "Location of new compute resource: #{cmpt_loc}"
          cmpt_loc
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
            desc = @rocci.describe id
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
