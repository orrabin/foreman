require 'test_helper'
require "parameters/caster"

class CasterTest < ActiveSupport::TestCase
  context "Casting to different stuff (successfully)" do
    test "string" do
      item = OpenStruct.new(:foo => :bar)
      Parameters::Caster.new(item, :attribute_name => :foo).cast!
      assert_equal item.foo, "bar"
    end

    test "integer" do
      #this also tests that "132" isn't octal
      item = OpenStruct.new(:foo => "132")
      Parameters::Caster.new(item, :attribute_name => :foo, :to => :integer).cast!
      assert_equal item.foo, 132
    end

    test "hex int" do
      item = OpenStruct.new(:foo => "0xabba")
      Parameters::Caster.new(item, :attribute_name => :foo, :to => :integer).cast!
      assert_equal item.foo, 43962
    end

    test "octal int" do
      item = OpenStruct.new(:foo => "012")
      Parameters::Caster.new(item, :attribute_name => :foo, :to => :integer).cast!
      assert_equal item.foo, 10
    end

    test "the truth" do
      item = OpenStruct.new(:foo => "true")
      Parameters::Caster.new(item, :attribute_name => :foo, :to => :boolean).cast!
      assert_equal item.foo, true
    end

    test "the lies" do
      item = OpenStruct.new(:foo => "false")
      Parameters::Caster.new(item, :attribute_name => :foo, :to => :boolean).cast!
      assert_equal item.foo, false
    end

    test "array (json)" do
      item = OpenStruct.new(:foo => [1,2,3].to_json)
      Parameters::Caster.new(item, :attribute_name => :foo, :to => :array).cast!
      assert_equal item.foo, [1,2,3]
    end

    test "array (yml)" do
      item = OpenStruct.new(:foo => [1,2,3].to_yaml)
      Parameters::Caster.new(item, :attribute_name => :foo, :to => :array).cast!
      assert_equal item.foo, [1,2,3]
    end

    test "hash (json)" do
      item = OpenStruct.new(:foo => {:a => :b}.to_json)
      Parameters::Caster.new(item, :attribute_name => :foo, :to => :hash).cast!
      assert_equal item.foo, {"a" => "b"}
    end

    test "hash (yml)" do
      item = OpenStruct.new(:foo => {:a => :b}.to_yaml)
      Parameters::Caster.new(item, :attribute_name => :foo, :to => :hash).cast!
      assert_equal item.foo, {:a => :b}
    end
  end

  context "failues" do
    test "caster cowardly doesn't make any change in case it doesn't know how to cast" do
      item = OpenStruct.new(:foo => "blah")
      #assert_raises TypeError do
      Parameters::Caster.new(item, :attribute_name => :foo, :to => :zibi).cast!
      assert_equal item.foo, "blah"
      #end
    end
  end

end
