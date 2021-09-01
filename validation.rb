module Validation
  @@details = []

  def self.validate(attribute, options={})
    @@details.push({ attribute => options })
  end

  def valid?
    validate_details
    !@valid.include?(false)
  end

  def validate!
    validate_details
    raise ValidateError.new(@valid_messages.join(', ')) unless @valid_messages.empty?
  end

  private

  def validate_details
    @valid = []
    @valid_messages = []
    @@details.each do |detail|
      validation_type = detail.values[0].keys[0]
      value = method(detail.keys[0]).call
      method(validation_type).call(detail, value)
    end
  end

  def presence(detail, value)
    conditon = !value.nil? && !value.to_s.empty?
    if validation_type_value(detail) && conditon
      @valid.push(conditon)
    else
      @valid_messages.push("#{detail.keys[0]} can't be blank.")
    end
  end

  def format(detail, value)
    return if value.nil?
    if value.class.eql?(String)
      conditon = validation_type_value(detail).match?(value)
      @valid.push(conditon)
      @valid_messages.push("#{detail.keys[0]} is invalid.") unless conditon
    else
      raise ValidateError.new("Format can be only used for string type of attribute.")
    end
  end

  def type(detail, value)
    return if value.nil?
    type = validation_type_value(detail)
    conditon = value.class.eql?(type)
    @valid.push(conditon)
    @valid_messages.push("For #{detail.keys[0]} type #{type} doesn't match") unless conditon
  end

  def validation_type_value(detail)
    detail.values[0].values[0]
  end

  class ValidateError < StandardError

    def initialize(message)
      super(message)
    end
  end
end
