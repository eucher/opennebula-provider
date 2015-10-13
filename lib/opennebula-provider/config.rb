module VagrantPlugins
  module OpenNebulaProvider
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :endpoint
      attr_accessor :auth
      attr_accessor :username
      attr_accessor :password
      attr_accessor :template
      attr_accessor :template_id
      attr_accessor :template_name
      attr_accessor :os_tpl
      attr_accessor :resource_tpl
      attr_accessor :title

      def initialize
        @endpoint = ENV['ONE_XMLRPC'] || ENV['ONE_ENDPOINT'] || UNSET_VALUE
        @auth = UNSET_VALUE
        @username = ENV['ONE_USER'] || UNSET_VALUE
        @password = ENV['ONE_PASSWORD'] || UNSET_VALUE
        @template_id = UNSET_VALUE
        @template_name = UNSET_VALUE
        @os_tpl = UNSET_VALUE
        @resource_tpl = UNSET_VALUE
        @title = UNSET_VALUE
      end

      def finalize!
        @endpoint = nil if @endpoint == UNSET_VALUE || @endpoint.empty?
        @auth = 'basic' if @auth == UNSET_VALUE
        @username = nil if @username == UNSET_VALUE
        @password = nil if @password == UNSET_VALUE
        @template_id = nil if @template_id == UNSET_VALUE
        @template_name = nil if @template_name == UNSET_VALUE
        if @template_id
          @template = @template_id
        elsif @template_name
          @template = @template_name
        elsif @template == UNSET_VALUE
          @template = nil
        end
        @resource_tpl = 'small' if @resource_tpl == UNSET_VALUE
        @title = nil if @title == UNSET_VALUE
      end

      def validate(machine)
        errors = []
        errors << I18n.t('opennebula_provider.config.endpoint') unless @endpoint
        errors << I18n.t('opennebula_provider.config.username') unless @username
        errors << I18n.t('opennebula_provider.config.password') unless @password
        errors << I18n.t('opennebula_provider.config.template') unless @template
        errors << I18n.t('opennebula_provider.config.title') unless @title

        { 'OpenNebula provider' => errors }
      end
    end
  end
end
