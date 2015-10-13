module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class WaitForState
        def initialize(app, env, state)
          @app = app
          @state = state
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::wait_for_state')
        end

        def call(env)
          driver = env[:machine].provider.driver
          driver.wait_for_state(env, @state) do |last_state|
#            env[:machine_state] = last_state.to_sym
            break if last_state == :error
          end
          @app.call(env)
        end
      end
    end
  end
end
