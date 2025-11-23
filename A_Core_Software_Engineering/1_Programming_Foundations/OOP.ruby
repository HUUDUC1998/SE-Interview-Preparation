class User
  attr_reader :age

  def initialize(first_name, last_name, age)
    @first_name = first_name
    @last_name = last_name
    @age = age
  end

  #  CLient không cần biết logic của full_name mà chỉ biết phương thức này trả về tên đầy đủ của user
  def full_name
    first_name + " " + last_name
  end

  private

  attr_reader :first_name, :last_name
end

user = User.new("Michael", "Jason", 30)

puts user.full_name # => "Michael Jason"
puts user.age # => 30
# pust user.first_name # => error. không thể tham chiếu vì đã private hoá 
                     # => private method `first_name' called for #<User:0x000000012502e6f0 @first_name="Michael", @last_name="Jason", @age=30> (NoMethodError)

class ProgramingLanguage 
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def what_language
    puts "Using #{name}"
  end
end

class RubyProgramingLanguage < ProgramingLanguage

end

ruby = RubyProgramingLanguage.new("ruby")

puts ruby.name # => "ruby"
ruby.what_language

class Animal
  def speak 
  end;
end

class Dog < Animal
  def speak
    "woo woo"
  end
end


class Cat < Animal
  def speak
    "meow meow"
  end
end

puts Dog.new.speak()
puts Cat.new.speak()