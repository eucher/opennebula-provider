module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class CheckState
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::check_state')
        end

        def call(env)
          env[:machine_state] = check_state(env[:machine])
          @logger.info I18n.t('opennebula_provider.info.state', state: env[:machine_state])
          @app.call(env)
        end

        def check_state(machine)
          return :not_created unless machine.id
          driver = machine.provider.driver
          driver.state(machine.id)
        end
      end
    end
  end
end
