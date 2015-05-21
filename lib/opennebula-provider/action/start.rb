module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class Start
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::start')
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.start', machine: env[:machine].id)
          driver = env[:machine].provider.driver
          driver.start(env[:machine].id)
          @app.call(env)
        end
      end
    end
  end
end
