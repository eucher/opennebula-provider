require 'opennebula-provider/errors'
require 'opennebula-provider/plugin'

module VagrantPlugins
  module OpenNebulaProvider
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end

    I18n.load_path << File.expand_path('locales/en.yml', source_root)
    I18n.reload!
  end
end
