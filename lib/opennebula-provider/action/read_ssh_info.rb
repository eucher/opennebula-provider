module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class ReadSSHInfo
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::read_ssh_info')
        end

        def call(env)
          env[:machine_ssh_info] = read_ssh_info(env[:machine])
          @app.call(env)
        end

        def read_ssh_info(machine)
          return nil if machine.id.nil?
          driver = machine.provider.driver

          host = driver.ssh_info(machine.id)
          { host: host, port: 22 } unless host.nil?
        end
      end
    end
  end
end
