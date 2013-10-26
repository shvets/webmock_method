module MetaMethods
  extend self

  def define_attribute(object, key, value)
    object.singleton_class.send :attr_accessor, key.to_sym # creates accessor

    object.send "#{key}=".to_sym, value  # sets up value for attribute
  end

  def define_attributes(object, hash)
    hash.each_pair do |key, value|
      define_attribute(object, key, value)
    end
  end
end
