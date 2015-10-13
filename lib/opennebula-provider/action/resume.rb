module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class Resume
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::resume')
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.resume', machine: env[:machine].id)
          driver = env[:machine].provider.driver
          driver.resume(env[:machine].id)
          @app.call(env)
        end
      end
    end
  end
end
