class GlobalLookupKey < LookupKey
  include Foreman::Controller::Parameters::LookupValueConnector
  validates :key, :uniqueness => true, :no_whitespace => true
  before_validation :strip_whitespaces

  alias_attribute :name, :key

  scoped_search :on => :key, :complete_value => :true
  scoped_search :on => :default_value, :complete_value => :true
  scoped_search :on => :should_be_global, :complete_value => {:true => true, :false => false}

  default_scope -> { order("lookup_keys.key") }

  def path
    "fqdn\nhostgroup\nos\nsubnet\ndomain\nlocation\norganization"
  end

  def key_type
    'string'
  end

  def strip_whitespaces
    self.key = self.key.strip unless key.blank? # when key string comes from a hash key, it's frozen and cannot be modified
    self.default_value.strip! unless default_value.blank?
  end
end
