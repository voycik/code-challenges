class Serializer
  class << self
    def attribute(name, &format)
      @attributes ||= Hash.new
      @attributes[name] = format
    end

    def attributes
      @attributes
    end

    def object
      @object
    end

    def to_object(given_object)
      @object = given_object
    end
  end

  def initialize(given_object)
    @given_object = given_object
    self.class.to_object(given_object)
  end

  def serialize
    Hash[attributes_names.zip(serialized_values)]
  end

  private

  def attributes
    self.class.attributes
  end

  def attributes_names
    attributes.keys
  end

  def serialized_values
    attributes.map do |attribute, format| 
      format ? format.call : @given_object[attribute]
    end
  end
end
