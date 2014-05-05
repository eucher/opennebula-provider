module VagrantPlugins
  module OpenNebulaProvider
    module Errors
      class OpenNebulaProviderError < Vagrant::Errors::VagrantError
        error_namespace('opennebula_provider.errors')
      end

      class AllocateError < OpenNebulaProviderError
        error_key(:allocate)
      end

      class AuthError < OpenNebulaProviderError
        error_key(:auth)
      end

      class ComputeError < OpenNebulaProviderError
        error_key(:compute)
      end

      class ConnectError < OpenNebulaProviderError
        error_key(:connect)
      end

      class ResourceError < OpenNebulaProviderError
        error_key(:resource)
      end

      class QuotaError < OpenNebulaProviderError
        error_key(:quota)
      end
    end
  end
end
