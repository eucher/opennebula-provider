module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class WaitForSSH
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::wait_for_ssh')
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.waiting_for_sshd')
          unless env[:interrupted]
            env[:machine].communicate.ready?
          end
          @app.call(env)
        end
      end
    end
  end
end
