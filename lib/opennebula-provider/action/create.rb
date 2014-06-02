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
          env[:machine].id = result
          env[:rocci].wait_for_state(env, 'active')
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
