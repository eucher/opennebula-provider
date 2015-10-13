module VagrantPlugins
  module OpenNebulaProvider
    module Action
      class MessageAlreadyCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.already_created')
          @app.call(env)
        end
      end

      class MessageAlreadyDestroyed
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.already_destroyed')
          @app.call(env)
        end
      end

      class MessageAlreadyHalted
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.already_halted')
          @app.call(env)
        end
      end

      class MessageAlreadySuspended
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.already_suspended')
          @app.call(env)
        end
      end

      class MessageNotCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.not_created')
          @app.call(env)
        end
      end

      class MessageWillNotDestroy
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.will_not_destroy')
          @app.call(env)
        end
      end

      class MessageSuspended
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.suspended')
          @app.call(env)
        end
      end

      class MessageHalted
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.halted')
          @app.call(env)
        end
      end

      class MessageInErrorState
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t('opennebula_provider.info.error')
          @app.call(env)
        end
      end
    end
  end
end
