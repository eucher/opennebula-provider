require_relative 'action'

module VagrantPlugins
  module OpenNebulaProvider
    class Provider < Vagrant.plugin('2', :provider)
      def initialize(machine)
        @logger = Log4r::Logger.new('vagrant::provider::opennebula')
        @machine = machine
      end

      def action(name)
        return Action.send(name) if Action.respond_to?(name)
        nil
      end

      def driver
        return @driver if @driver
        puts "@driver #{@driver}"
        @driver = Driver.new(@machine.id)
        @driver.set_config(@machine.provider_config)

        @driver
      end

      def ssh_info
        env = @machine.action('read_ssh_info')
        env[:machine_ssh_info]
      end

      def state
        state = nil
        state = :not_created if !@machine.id
        state = driver.state(@machine.id)
#        env[:machine_state] = state

#        env = @machine.action('check_state')
#        state = env[:machine_state]
        short = I18n.t("opennebula_provider.states.short_#{state}")
        long = I18n.t("opennebula_provider.states.long_#{state}")
        Vagrant::MachineState.new(state, short, long)
      end
    end
  end
end
