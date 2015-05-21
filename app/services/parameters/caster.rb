module Parameters
  class Caster
    TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE', 'on', 'ON', 'yes', 'YES', 'y', 'Y'].to_set
    FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE', 'off', 'OFF', 'no', 'NO', 'n', 'N'].to_set

    def initialize(item, options = {})
      defaults = {
        :attribute_name => :value,
        :to => :string
      }
      options.reverse_merge!(defaults)
      @item, @options = item, options
    end

    def cast!
      @item.send("#{@options[:attribute_name]}=", casted_value)
    end

    private

    def casted_value
      case @options[:to]
      when :string
        cast_string
      when :integer
        cast_integer
      when :real
        cast_real
      when :boolean
        cast_boolean
      when :array
        cast_array
      when :hash
        cast_hash
      when :json
        cast_json
      when :yaml
        cast_yaml
      else
        #cowardly refusing to cast
        value
      end
    end

    def cast_string
      value.to_s
    end

    def cast_boolean
      return true if TRUE_VALUES.include? value
      return false if FALSE_VALUES.include? value
      raise TypeError
    end

    def cast_integer
      return value.to_i if value.is_a?(Numeric)

      if value.is_a?(String)
        if value =~ /^0x[0-9a-f]+$/i
          value.to_i(16)
        elsif value =~ /^0[0-7]+$/ #this is stupid, "14" will be translated to 12 :(
          value.to_i(8)
        elsif value =~ /^-?\d+$/
          value.to_i
        else
          raise TypeError
        end
      end
    end

    def cast_real
      return value if value.is_a? Numeric
      if value.is_a?(String)
        if value =~ /\A[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?\Z/
          value.to_f
        else
          cast_value_integer value
        end
      end
    end

    def cast_array
      return value if value.is_a? Array
      return value.to_a if not value.is_a? String and value.is_a? Enumerable
      val = load_yaml_or_json
      raise TypeError unless val.is_a? Array
      val
    end

    def cast_hash
      return value if value.is_a? Hash
      val = load_yaml_or_json
      raise TypeError unless val.is_a? Hash
      val
    end

    def cast_json
      JSON.load value
    end

    def cast_yaml
      YAML.load value
    end

    def load_yaml_or_json
      return value unless value.is_a? String
      begin
        JSON.load value
      rescue
        YAML.load value
      end
    end

    def value
      @item.send(@options[:attribute_name])
    end
  end
end