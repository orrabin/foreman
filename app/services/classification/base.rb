module Classification
  class Base
    delegate :hostgroup, :environment_id, :puppetclass_ids, :classes,
             :to => :host

    def initialize(args = { })
      @host = args[:host]
      @safe_render = SafeRender.new(:variables => { :host => host } )
    end

    #override to return the relevant enc data and format
    def enc
      raise NotImplementedError
    end

    def inherited_values
      values_hash :skip_fqdn => true
    end

    protected

    attr_reader :host

    #override this method to return the relevant parameters for a given set of classes
    def class_parameters
      raise NotImplementedError
    end

    def possible_value_orders
      class_parameters.select do |key|
        # take only keys with actual values
        key.lookup_values_count > 0 # we use counter cache, so its safe to make that query
      end.map(&:path_elements).flatten(1).uniq
    end

    def values_hash(options = {})
      values = {}
      values_for_deep_merge = {}
      path2matches.each do |match|
        LookupValue.where(:match => match).where(:lookup_key_id => class_parameters.map(&:id)).each do |value|
          key_id = value.lookup_key_id
          values[key_id] ||= {}
          key = class_parameters.detect{|k| k.id == value.lookup_key_id }
          name = key.to_s
          element = match.split(LookupKey::EQ_DELM).first
          element_name = match.split(LookupKey::EQ_DELM).last
          next if (options[:skip_fqdn] && element=="fqdn") || key.path.index(element).nil?
          if values[key_id][name].nil?
            values[key_id][name] = {:value => value.value, :element => element, :element_name => element_name}
          else
            if (key.merge_overrides)
              if (!values[key_id][name][:element].is_a?(Array))
                values[key_id][name][:element] = Array.wrap(values[key_id][name][:element])
                values[key_id][name][:element_name] = Array.wrap(values[key_id][name][:element_name])
              end
              case key.key_type
                when "array"
                  if key.avoid_duplicates
                    values[key_id][name][:value] |= value.value
                  else
                    values[key_id][name][:value] += value.value
                  end
                  values[key_id][name][:element] << element
                  values[key_id][name][:element_name] << element_name
                when "hash"
                  values_for_deep_merge[key_id] ||= {}
                  values_for_deep_merge[key_id][name] ||= [{:value => values[key_id][name][:value],
                                                            :index => key.path.index(values[key_id][name][:element].first),
                                                            :element => values[key_id][name][:element].first,
                                                            :element_name => values[key_id][name][:element_name].first}]
                  values_for_deep_merge[key_id][name] += [{:value => value.value, :index => key.path.index(element),
                                                           :element => element, :element_name => element_name}]
              end
            else
              if key.path.index(element) < key.path.index(values[key_id][name][:element])
                values[key_id][name] = {:value => value.value, :element => element, :element_name => element_name}
              end
            end
          end
        end
      end
      unless values_for_deep_merge.empty?
        values.merge!(hash_deep_merge(values_for_deep_merge))
      end
      values
    end

    def hash_deep_merge(hash)
      values = {}
      hash.each do |key|
        key_id = key[0]
        name = key[1].keys[0]
        values[key_id] = {}
        sorted_values = key[1].values[0].sort_by {|value| -1 * value[:index]}
        sorted_values.each do |value|
          if values[key_id][name].nil?
            values[key_id][name] = {:value => value[:value], :element => [value[:element]], :element_name => [value[:element_name]]}
          else
            values[key_id][name][:value].deep_merge!(value[:value])
            values[key_id][name][:element] << value[:element]
            values[key_id][name][:element_name] << value[:element_name]
          end
        end
      end
      values
    end

    def value_of_key(key, values)
      value = if values[key.id] and values[key.id][key.to_s]
                values[key.id][key.to_s][:value]
              else
                key.default_value
              end
      @safe_render.parse(value)
    end

    def hostgroup_matches
      @hostgroup_matches ||= matches_for_hostgroup
    end

    def matches_for_hostgroup
      matches = []
      if hostgroup
        path = hostgroup.to_label
        while path.include?("/")
          path = path[0..path.rindex("/")-1]
          matches << "hostgroup#{LookupKey::EQ_DELM}#{path}"
        end
      end
      matches
    end

    # Generate possible lookup values type matches to a given host
    def path2matches
      matches = []
      possible_value_orders.each do |rule|
        match = Array.wrap(rule).map do |element|
          "#{element}#{LookupKey::EQ_DELM}#{attr_to_value(element)}"
        end
        matches << match.join(LookupKey::KEY_DELM)

        hostgroup_matches.each do |hostgroup_match|
          match[match.index{|m|m =~ /hostgroup\s*=/}]=hostgroup_match
          matches << match.join(LookupKey::KEY_DELM)
        end if Array.wrap(rule).include?("hostgroup") && Setting["host_group_matchers_inheritance"]
      end
      matches
    end

    # translates an element such as domain to its real value per host
    # tries to find the host attribute first, parameters and then fallback to a puppet fact.
    def attr_to_value(element)
      # direct host attribute
      return host.send(element) if host.respond_to?(element)
      # host parameter
      return host.host_params[element] if host.host_params.include?(element)
      # fact attribute
      if (fn = host.fact_names.first(:conditions => { :name => element }))
        return FactValue.where(:host_id => host.id, :fact_name_id => fn.id).first.value
      end
    end

    def path_elements(path = nil)
      path.split.map do |paths|
        paths.split(LookupKey::KEY_DELM).map do |element|
          element
        end
      end
    end
  end
end

