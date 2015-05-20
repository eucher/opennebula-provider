require_relative 'version'
require_relative 'driver'

require 'vagrant'

module VagrantPlugins
  module OpenNebulaProvider
    class Plugin < Vagrant.plugin('2')
      name 'opennebula-provider'

      config(:opennebula, :provider) do
        require_relative 'config'
        Config
      end

      provider(:opennebula) do
        require_relative 'provider'
        Provider
      end
    end
  end
end
