module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class Stop
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::stop')
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.halt', machine: env[:machine].id)
          driver = env[:machine].provider.driver
          driver.stop(env[:machine].id)
          @app.call(env)
        end
      end
    end
  end
end
