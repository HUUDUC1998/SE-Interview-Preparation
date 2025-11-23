# OOP

OOP(Object Oriented Programming) là phương pháp tập trung vào các lớp (Class) và đối tượng

OOP là nền tảng của Design pattern

## Đối tượng (Object)

Đối tượng trong OOP gồm 2 thành phần chính:

- Attribute(thuộc tính): là những thông tin đặc điểm đối tượng
- Method(phương thức): là những hành vi mà đối tượng có thể thực hiện

Ví dụ:
Đối tượng con mèo có

- Attribute(thuộc tính): lông đen, đuôi dài, ...
- Method(phương thức): chạy, ăn, leo trèo, ...

## Lớp(Class)
Lớp là sự trừu tượng của hoá của đối tượng. Những đối tượng có đặc tính tương tự nhau thường sẽ được tập hợp thành một lớp

Nói cách khác một lớp có thể xem là bản thiết kế chung để tạo ra các đối tượng riêng biệt

Lớp cũng sẽ bao gồm thuộc tính và phương thức

Ví dụ: Lớp mèo
- Attribute: màu lông, đuôi, ...
- Method: chạy, ăn, leo trèo, ...

## Ưu điểm của OOP
- Mô hình hoá những định nghĩa phức tạp thành cấu trúc đơn giản
- Có tính tái sử dụng cao, tiết kiệm tài nguyên
- Giúp debug dễ hơn
- Bảo mật cao thông qua tính đóng gói
- Dễ mở rộng code

## Các đặc tính của OOP

1. Encapsulation(Tính đóng gói)
- Cho phép choe giấu thông tin và những tính chất xử lý bên trong của đối tượng
- Các đói tượng khác đều không thể tác động trực tiếp đến dữ liệu bên trong hay trạng thái của đối tượng
- Để tham chiếu các dữ liệu hoặc trạng thái của đối tượng thì cần thông qua các phương thức mà các đối tượng cung cấp
Ví dụ
```ruby
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
pust user.age # => 30
pust user.first_name # => error. không thể tham chiếu vì đã private hoá 
                     # => private method `first_name' called for #<User:0x000000012502e6f0 @first_name="Michael", @last_name="Jason", @age=30> (NoMethodError)
```

2. Inhheritance(Tính kế thừa)
- Tính chất này cho phép định nghĩa một lớp mới(thường gọi là lớp Con) có thể kế thừa và tái sử dụng các thuộc tính, phương thức của lớp cũ đã được định nghĩa trước đó (thường gọi là lớp Cha)
- Các lớp Con có thể kế thừa toàn bộ thành phần của lớp Cha mà không cần phải định nghĩa lại
- Lớp có thể mở rộng các thành phần kế thừa hoặc bổ sung những phương thức hay thuộc tính mới

Ví dụ

```ruby
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
ruby.what_language # => Using ruby
```

3. Polymorphim(Tính đa hình)
- Tính đa hình cho phép các đối tượng cùng kiểu có thể có các hành vì khác nhau
- Nghĩa là ta có thể định nghĩa các phương thức cùng tên nhưng có các hành vi khác nhau có các lớp con khác nhau
Ví dụ
```ruby
class Animal
  def speak 
    raise NotImplementedError, "Subclasses must implement the 'area' method."
  end
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

puts Dog.new.speak() # => woo woo
puts Cat.new.speak() # => meow meow
```

4. Tính trừu tượng
- Tính trừu tượng cho phép ta xây dựng một interface. Nghĩa là ta có thể xây dựng một class trừu tượng với những phương thức không có logic ở bên trong
- Ta chỉ định nghĩa các phương thức thực sự hoạt động ở các lớp con
- Làm như vậy khi đọc code ta chỉ cần đọc lớp trừu tượng trước thì ta sẽ hiểu được interface của các đối tượng

- Với ví dụ bên dưới, ta có thể nói class Animal là một lớp trừu trượng. Có phương thức speak
(với ngôn ngữ ruby thì không có khái niệm abstract class). Các lớp con(Dog, Cat) kế thừa lớp cha(Animal) và cụ thể hoá các phương thức(speak)
```ruby
class Animal
  def speak 
    raise NotImplementedError, "Subclasses must implement the 'area' method."
  end
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

puts Dog.new.speak() # => woo woo
puts Cat.new.speak() # => meow meow
```

[back to Readme](README.md)

# Tóm tắt 99_bottles_of_oop
https://github.com/marina-ferreira/99_bottles_of_oop

## Chapter 1 - Rediscovering Simplicity

### Making the Code Clear (Viết code rõ ràng)

- Để viết code dễ hiểu trước hết cần phải làm rõ phạm vi của vấn đề. Nếu không làm rõ vấn đề trước mà viết code luôn thì code sẽ khó hiểu và khó bảo trì

- Không nên trừu tượng hoá code quá sớm khi mà mọi thứ vẫn chưa rõ ràng. Chỉ nên trừu tượng hoá code khi đã hiểu rõ code. Chúng ta nên chống lại việc trừu tượng hoá code cho đến khi cần thiết
