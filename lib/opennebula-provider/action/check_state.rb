require 'opennebula-provider/helpers/rocci'

module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class CheckState
        include Helpers::Rocci

        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::check_state')
        end

        def call(env)
          env[:machine_state] = check_state(env[:rocci], env[:machine])
          @logger.info I18n.t('opennebula_provider.info.state', state: env[:machine_state])
          @app.call(env)
        end

        def check_state(rocci, machine)
          return :not_created if machine.id.nil?
          state = rocci.machine_state(machine.id)
          state.to_sym
        end
      end
    end
  end
end
