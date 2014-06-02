module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class Destroy
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::destroy')
        end

        def call(env)
          @logger.info I18n.t('opennebula_provider.info.destroying', machine: env[:machine].id)
          env[:rocci].delete(env[:machine].id)
          env[:machine].id = nil
          @app.call(env)
        end
      end
    end
  end
end
