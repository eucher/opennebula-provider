require 'opennebula-provider/helpers/rocci'

module VagrantPlugins
  module OpenNebulaProvider
    class Driver
      include Vagrant::Util::Retryable

      def initialize
        @rocci_driver ||= VagrantPlugins::OpenNebulaProvider::Helpers::RocciApi.new
      end

      def config=(provider_config)
        @rocci_driver.fill_config(provider_config)
        @rocci_driver.connect
      end

      def state(cid)
        @rocci_driver.machine_state(cid)
      end

      def create
        @rocci_driver.compute
      end

      def delete(cid)
        @rocci_driver.delete(cid)
      end

      def start(cid)
        @rocci_driver.start(cid)
      end

      def stop(cid)
        @rocci_driver.stop(cid)
      end

      def ssh_info(cid)
        @rocci_driver.ssh_info(cid)
      end

      def wait_for_state(env, state)
        retryable(tries: 60, sleep: 2) do
          next if env[:interrupted]
          result = @rocci_driver.machine_state(env[:machine].id)

          yield result if block_given?
          if result != state
            fail Errors::ComputeError,
              error: "Can not wait when instance will be in '#{state}' status, " \
                     "last status is '#{result}'"
          end
        end
      end
    end
  end
end
