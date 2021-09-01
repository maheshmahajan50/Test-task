require "./validation.rb"

class User
  attr_accessor :name
end

class Employee
  attr_accessor :name
end

employee = Employee.new
employee.name = "John"

class Person
  include Validation
  attr_accessor :age, :name, :owner

  Validation.validate :name, presence: true
  Validation.validate :age, presence: true
  Validation.validate :name, format: /Cats(.*)/
  Validation.validate :owner, type: User
end

person = Person.new
person.name = "Mike"
person.age = 26
person.owner = employee
p person.valid?                #  false (because name is invalid as per regex)

person.validate!              # `validate!': name is invalid., For owner type User doesn't match (Validation::ValidateError)

