require_relative 'action/check_state'
require_relative 'action/create'
require_relative 'action/destroy'
require_relative 'action/messages'
require_relative 'action/read_ssh_info'
require_relative 'action/sync_folders'
require_relative 'action/start'
require_relative 'action/stop'
require_relative 'action/wait_for_state'
require_relative 'action/wait_for_ssh'

module VagrantPlugins
  module OpenNebulaProvider
    module Action
      include Vagrant::Action::Builtin

      def self.destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, CheckState do |env, b1|
            case env[:machine_state]
            when :active, :error, :suspended, :inactive
              b1.use Call, DestroyConfirm do |env1, b2|
                if env1[:result]
                  b2.use Destroy
                  b2.use ProvisionerCleanup if defined?(ProvisionerCleanup)
                else
                  b2.use MessageWillNotDestroy
                end
              end
            when :not_created
              b1.use MessageNotCreated
              next
            end
          end
        end
      end

      def self.up
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, CheckState do |env, b1|
            case env[:machine_state]
            when :active
              b1.use MessageAlreadyCreated
            when :suspended
              b1.use Start
            when :not_created, :inactive
              b1.use Create
            end
            b1.use WaitForState, 'active'
          end
        end
      end

      def self.halt
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, CheckState do |env1, b1|
            case env1[:machine_state]
            when :active
              b1.use Stop
              b1.use WaitForState, 'suspended'
            when :suspended
              b1.use MessageAlreadyHalted
            when :not_created, :inactive
              b1.use MessageNotCreated
            end
          end
        end
      end

      def self.reload
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, CheckState do |env1, b1|
            case env1[:machine_state]
            when :not_created
              b1.use MessageNotCreated
              next
            end

            b1.use halt
            b1.use up
          end
        end
      end

      def self.check_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use CheckState
        end
      end

      def self.provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, CheckState do |env1, b1|
            case env1[:machine_state]
            when :not_created, :inactive
              b1.use MessageNotCreated
            when :suspended
              b1.use MessageHalted
            else
              b1.use Provision
              b1.use SyncFolders
            end
          end
        end
      end

      def self.read_ssh_info
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ReadSSHInfo
        end
      end

      def self.ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, CheckState do |env1, b1|
            case env1[:machine_state]
            when :not_created, :inactive
              b1.use MessageNotCreated
            when :suspended
              b1.use MessageHalted
            else
              b1.use SSHExec
            end
          end
        end
      end
    end
  end
end
