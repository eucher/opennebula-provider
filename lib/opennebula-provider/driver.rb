require 'opennebula-provider/helpers/rocci'

module VagrantPlugins
  module OpenNebulaProvider
    class Driver

      def initialize(cid)
        @rocci ||= VagrantPlugins::OpenNebulaProvider::Helpers::RocciApi.new(cid)
      end

      def set_config(provider_config)
        @rocci.set_config(provider_config)
        @rocci.connect
      end

      def state(cid)
        case
        when active?(cid)
          :active
        end
      end

      def active?(cid)
        @rocci.machine_state(cid)
      end
    end
  end
end
