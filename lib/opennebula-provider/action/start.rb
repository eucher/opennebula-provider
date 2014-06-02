module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class Start
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::start')
        end

        def call(env)
          @logger.info I18n.t('opennebula_provider.info.start', machine: env[:machine].id)
          env[:rocci].start(env[:machine].id)
          env[:ui].info I18n.t('opennebula_provider.info.waiting_for_sshd')
          if !env[:interrupted]
            while true
              break if env[:interrupted]
              break if env[:machine].communicate.ready?
              sleep 2
            end
          end
          @app.call(env)
        end
      end
    end
  end
end
