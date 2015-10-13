module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class Suspend
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::suspend')
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.suspend', machine: env[:machine].id)
          driver = env[:machine].provider.driver
          driver.suspend(env[:machine].id)
          @app.call(env)
        end
      end
    end
  end
end
