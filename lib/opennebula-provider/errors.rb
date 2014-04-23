module VagrantPlugins
  module OpenNebulaProvider
    module Errors
      class OpenNebulaProviderError < Vagrant::Errors::VagrantError
        error_namespace('opennebula_provider.errors')
      end

      class QuotaError < OpenNebulaProviderError
        error_key(:quota)
      end

      class AllocateError < OpenNebulaProviderError
        error_key(:allocate)
      end

      class ComputeError < OpenNebulaProviderError
        error_key(:compute)
      end
    end
  end
end
