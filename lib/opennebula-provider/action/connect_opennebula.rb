require 'opennebula-provider/helpers/rocci'

module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class ConnectOpenNebula
        include Helpers::Rocci

        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::connect_opennebula')
        end

        def call(env)
          @logger.info('Connecting to OpenNebula')
          rocci = rocci(env[:machine].provider_config)
          env[:rocci] = rocci

          @app.call(env)
        end
      end
    end
  end
end
