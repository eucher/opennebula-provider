require_relative 'action/check_state'
require_relative 'action/connect_opennebula'
require_relative 'action/create'
require_relative 'action/destroy'
require_relative 'action/messages'
require_relative 'action/read_ssh_info'
require_relative 'action/sync_folders'
require_relative 'action/start'
require_relative 'action/stop'

module VagrantPlugins
  module OpenNebulaProvider
    module Action
      include Vagrant::Action::Builtin

      def self.destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use Call, DestroyConfirm do |env, b1|
            b1.use ConfigValidate
            b1.use ConnectOpenNebula
            b1.use Call, CheckState do |env2, b2|
              case env2[:machine_state]
              when :active, :error, :suspended, :inactive
                b2.use Destroy
                b2.use ProvisionerCleanup if defined?(ProvisionerCleanup)
              when :not_created
                b2.use MessageAlreadyDestroyed
              end
            end
          end
        end
      end

      def self.up
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectOpenNebula
          b.use Call, CheckState do |env, b1|
            case env[:machine_state]
            when :active
              b1.use MessageAlreadyCreated
            when :suspended
              b1.use Start
            when :not_created, :inactive
              b1.use Create
            end
          end
        end
      end

      def self.halt
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectOpenNebula
          b.use Call, CheckState do |env1, b1|
            case env1[:machine_state]
            when :active
              b1.use Stop
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
          b.use ConnectOpenNebula
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
          b.use ConnectOpenNebula
          b.use CheckState
        end
      end

      def self.provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Provision
          b.use SyncFolders
        end
      end

      def self.read_ssh_info
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectOpenNebula
          b.use ReadSSHInfo
        end
      end

      def self.ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use SSHExec
        end
      end
    end
  end
end
