module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class Stop
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::stop')
        end

        def call(env)
          @logger.info I18n.t('opennebula_provider.info.stop', machine: env[:machine].id)
          env[:rocci].stop(env[:machine].id)
          @app.call(env)
        end
      end
    end
  end
end
