module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class ReadSSHInfo
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::read_ssh_info')
        end

        def call(env)
          env[:machine_ssh_info] = read_ssh_info(env[:rocci], env[:machine])
          @app.call(env)
        end

        def read_ssh_info(rocci, machine)
          return nil if machine.id.nil?

          host = rocci.ssh_info(machine.id)
          { host: host, port: 22 }
        end
      end
    end
  end
end
