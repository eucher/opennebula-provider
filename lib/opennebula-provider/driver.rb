require 'opennebula-provider/helpers/fog'

module VagrantPlugins
  module OpenNebulaProvider
    class Driver
      include Vagrant::Util::Retryable

      def initialize
        @fog_driver ||= VagrantPlugins::OpenNebulaProvider::Helpers::FogApi.new
      end

      def config=(config)
        @fog_driver.config = config
      end

      def provider_config=(provider_config)
        @fog_driver.provider_config = provider_config
      end

      def connect
        @fog_driver.connect
      end

      def state(cid)
        @fog_driver.machine_state(cid)
      end

      def create
        @fog_driver.compute
      end

      def delete(cid)
        @fog_driver.delete(cid)
      end

      def start(cid)
        @fog_driver.start(cid)
      end

      def stop(cid)
        @fog_driver.stop(cid)
      end

      def suspend(cid)
        @fog_driver.suspend(cid)
      end

      def resume(cid)
        @fog_driver.resume(cid)
      end

      def ssh_info(cid)
        @fog_driver.ssh_info(cid)
      end

      def wait_for_state(env, state)
        timeout = env[:machine].provider_config.timeout
        max_tries = timeout / 2
        retryable(tries: max_tries, sleep: 2) do
          next if env[:interrupted]
          env[:machine_state] = @fog_driver.machine_state(env[:machine].id)

          yield env[:machine_state] if block_given?

          if env[:machine_state] != state
            fail Errors::ComputeError,
              error: "Can not wait when instance will be in '#{state}' status, " \
                     "last status is '#{env[:machine_state]}'"
          end
        end
      end
    end
  end
end
