module HostParams
  extend ActiveSupport::Concern

  included do
    include ParameterValidators
    attr_reader :cached_host_params

    def params
      host_params.update(lookup_keys_params)
    end

    def clear_host_parameters_cache!
      @cached_host_params = nil
    end

    def host_params
      return cached_host_params unless cached_host_params.blank?
      host_parameters_hash = Classification::NonPuppetParam.new(:host=>self).values_hash
      hp = {}
      host_parameters_hash.each  do |param|
        param_hash = param.last
        key = param_hash.keys[0]
        value = param_hash[key][:value]
        hp.update Hash[key => value]
      end

      @cached_host_params = hp
    end
  end
end
