module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class MessageAlreadyCreated
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant::provider::opennebula::message')
        end

        def call(env)
          @logger.info I18n.t('opennebula_provider.info.already_created')
          @app.call(env)
        end
      end
    end
  end
end
