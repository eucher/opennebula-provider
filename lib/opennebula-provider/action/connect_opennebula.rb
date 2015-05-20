
module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class ConnectOpenNebula

        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::connect_opennebula')
        end

        def call(env)
          @logger.info('Connecting to OpenNebula')
          if env[:rocci].nil?
            @logger.info('Initializing new rocci')
            rocci = rocci(env[:machine].provider_config)
            env[:rocci] = rocci
          end

          @app.call(env)
        end
      end
    end
  end
end
