require_relative 'version'

require 'vagrant'

module VagrantPlugins
  module OpenNebulaProvider
    class Plugin < Vagrant.plugin('2')
      name 'opennebula-provider'

      provider(:opennebula) do
        require_relative 'provider'
        Provider
      end

      config(:opennebula, :provider) do
        require_relative 'config'
        Config
      end
    end
  end
end
