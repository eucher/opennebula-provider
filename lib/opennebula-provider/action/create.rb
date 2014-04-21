module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class Create
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::create')
        end

        def call(env)
          @logger.info I18n.t('opennebula_provider.info.creating')
          result = env[:rocci].compute
          env[:rocci].wait_for_event(env, result)
          env[:machine].id = result
          @app.call(env)
        end
      end
    end
  end
end
