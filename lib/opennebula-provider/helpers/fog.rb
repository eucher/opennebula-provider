require 'fog'

module VagrantPlugins
  module OpenNebulaProvider
    module Helpers
      class FogApi
        def initialize
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::helpers::fog')
        end

        def fill_config(provider_config)
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::helpers::fog')
          @config = provider_config
          @options = {
            provider: 'OpenNebula',
            opennebula_endpoint: provider_config.endpoint,
            opennebula_username: provider_config.username,
            opennebula_password: provider_config.password
          }
        end

        def connect
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::helpers::fog')
          @logger.info 'Connect to OpenNebula RPC'
          @fog_client = Fog::Compute.new(@options)
          rc = @fog_client.client.get_version
          if rc.is_a?(OpenNebula::Error)
            case rc.errno
            when 256
                raise Errors::AuthError, error: rc.message
            when 4369
                raise Errors::ConnectError, error: rc.message
            end
          end
        end

        def compute
          @logger.info 'compute!'
          newvm = @fog_client.servers.new
          if @config.template_id
            newvm.flavor = @fog_client.flavors.get @config.template_id
          elsif @config.template_name
            newvm.flavor = @fog_client.flavors.get_by_filter({name: @config.template_name})
          end
          if newvm.flavor.nil?
            fail Errors::ComputeError, error: I18n.t('opennebula_provider.compute.template_missing', template: @config.template)
          end

          newvm.name = @config.title if @config.title
          #newvm.flavor.user_variables = {} if newvm.flavor.user_variables.nil? || newvm.flavor.user_variables.empty?
          #newvm.flavor.context = {} if newvm.flavor.context.nil? || newvm.flavor.context.empty?
          #newvm.flavor.memory = '500mb'
          vm = newvm.save
          vm.id
        rescue RuntimeError => e
          raise Errors::ComputeError, error: e
        end

        def stop(id)
          @logger.info 'stop!'
          @fog_client.servers.get(id).stop
        end

        def start(id)
          @logger.info 'start!'
          @fog_client.servers.get(id).start
        end

        def delete(id)
          @logger.info 'delete!'
          @fog_client.servers.get(id).destroy
        end

        def suspend(id)
          @logger.info 'suspend!'
          @fog_client.servers.get(id).suspend
        end

        def resume(id)
          @logger.info 'resume!'
          @fog_client.servers.get(id).resume
        end

        def machine_state(id)
          if id
            begin
              desc = @fog_client.servers.get(id)  #state LCM_INIT & RUNNING  status 7 && UNDEPLOYED
            rescue ArgumentError => e
              raise Errors::ResourceError, error: e
            end
            return :not_created if desc.nil?

            return get_pretty_status(desc.state, desc.status)
          else
            return :not_created
          end
        end

        def ssh_info(id)
          desc = @fog_client.servers.get(id)
          desc.ip
        end

        private
        def get_pretty_status(state, status)
#          puts state, status
          case state
          when 'LCM_INIT'
            case status
            when 1
              pretty = 'pending'
            when 4
              pretty = 'stopped'
            when 5
              pretty = 'suspended'
            when 7
              pretty = 'error'
            end
          when 'PROLOG'
            case status
            when 3
              pretty = 'prolog'
            end
          when 'BOOT'
            case status
            when 3
              pretty = 'boot'
            end
          when 'RUNNING'
            case status
            when 3
              pretty = 'active'
            end
          end
          pretty.to_sym
        end
      end
    end
  end
end
