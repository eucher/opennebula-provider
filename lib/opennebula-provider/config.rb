module VagrantPlugins
  module OpenNebulaProvider
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :endpoint
      attr_accessor :auth
      attr_accessor :username
      attr_accessor :password
      attr_accessor :os_tpl
      attr_accessor :resource_tpl
      attr_accessor :title

      def initialize
        @endpoint = UNSET_VALUE
        @auth = UNSET_VALUE
        @username = UNSET_VALUE
        @password = UNSET_VALUE
        @os_tpl = UNSET_VALUE
        @resource_tpl = UNSET_VALUE
        @title = UNSET_VALUE
      end

      def finalize!
        @endpoint = nil if @endpoint == UNSET_VALUE
        @auth = 'basic' if @auth == UNSET_VALUE
        @username = nil if @username == UNSET_VALUE
        @password = nil if @password == UNSET_VALUE
        @os_tpl = nil if @os_tpl == UNSET_VALUE
        @resource_tpl = 'small' if @resource_tpl == UNSET_VALUE
        @title = nil if @title == UNSET_VALUE
      end

      def validate(machine)
        errors = []
        errors << I18n.t('opennebula_provider.config.endpoint') unless @endpoint
        errors << I18n.t('opennebula_provider.config.username') unless @username
        errors << I18n.t('opennebula_provider.config.password') unless @password
        errors << I18n.t('opennebula_provider.config.os_tpl') unless @os_tpl

        { 'OpenNebula provider' => errors }
      end
    end
  end
end
