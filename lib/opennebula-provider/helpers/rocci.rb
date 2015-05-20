require 'occi-api'

module VagrantPlugins
  module OpenNebulaProvider
    module Helpers
      class RocciApi
        include Vagrant::Util::Retryable

        attr_accessor :cmpt_loc
        attr_accessor :options

        def initialize(cmpt_loc)
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::helpers::rocciapi')
          @cmpt_loc = cmpt_loc
          @cmpt_loc
        end

        def set_config(provider_config)
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::helpers::rocciapi')
          @options = {
            endpoint: provider_config.endpoint,
            auth: {
              type: provider_config.auth,
              username: provider_config.username,
              password: provider_config.password
            }
#              :log => {
#              :out   => STDERR,
#              :level => Occi::Api::Log::DEBUG
#            }
          }
        end

        def connect
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::helpers::rocciapi')
          @logger.info 'Connect to RocciServer'
          begin
            @rocci = Occi::Api::Client::ClientHttp.new(@options)
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
          unless os
            mixins = @rocci.get_mixins 'os_tpl'
            mixins.each do |mixin|
              if mixin.title == @config.os_tpl
                os = @rocci.get_mixin mixin.term, 'os_tpl'
              end
            end
            fail Errors::ComputeError, error: I18n.t('opennebula_provider.compute.os_missing', template: @config.os_tpl) unless os
          end

          size = @rocci.get_mixin @config.resource_tpl, 'resource_tpl'
          unless size
            fail Errors::ComputeError, error: I18n.t('opennebula_provider.compute.resource_size_missing', template: @config.resource_tpl)
          end

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

        def stop(id)
          @logger.info 'stop!'
          @rocci.trigger id, action_instance(id, 'stop')
        end

        def start(id)
          @logger.info 'start!'
          @rocci.trigger id, action_instance(id, 'start')
        end

        def delete(id)
          @logger.info 'delete!'
          @rocci.delete id
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

        def wait_for_state(env, state)
          retryable(tries: 100, sleep: 6) do
            next if env[:interrupted]
            result = machine_state(env[:machine].id)

            yield result if block_given?
            fail Errors::ComputeError, error: 'Not ready' if result != state
          end
        end

        private

        def action_instance(id, action)
          desc = describe_resource(id)
          action_ = desc.first.actions.map do |ai|
            ai.term == action ? ai : nil
          end.compact.first
          Occi::Core::ActionInstance.new action_, nil
        end

        def describe_resource(resource)
          @rocci.describe resource
        end
      end
    end
  end
end
