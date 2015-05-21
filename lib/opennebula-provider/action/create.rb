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
          driver = env[:machine].provider.driver
          env[:machine].id = driver.create
          @app.call(env)
        end
      end
    end
  end
end
