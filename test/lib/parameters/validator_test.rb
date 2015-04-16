require 'test_helper'
require "parameters/caster"

class ValidatorTest < ActiveSupport::TestCase
  class ValidatedItem
    include ActiveModel::Validations
    attr_accessor :value
  end
  before do
    @item = ValidatedItem.new
  end

  it "adds errors on wrong regexp" do
    @item.value = "123"
    validator = Parameters::Validator.new(@item, :type => :regexp, :validate_with => "[a-z]", :getter => :value)
    validator.validate!
    assert @item.errors.present?
  end

  it "validates regexp" do
    @item.value = "abdfgfdger"
    validator = Parameters::Validator.new(@item, :type => :regexp, :validate_with => "[a-z]", :getter => :value)
    validator.validate!
    assert @item.errors.blank?
  end

  it "adds errors on wrong item" do
    validator_rule = "a,b,c"
    @item.value = "d"
    validator = Parameters::Validator.new(@item, :type => :list, :validate_with => validator_rule, :getter => :value)
    validator.validate!
    assert @item.errors.present?
  end

  it "validates inclusion in list" do
    validator_rule = "a,b,c"
    @item.value = "a"
    validator = Parameters::Validator.new(@item, :type => :list, :validate_with => validator_rule, :getter => :value)
    validator.validate!
    assert @item.errors.blank?
  end
end
