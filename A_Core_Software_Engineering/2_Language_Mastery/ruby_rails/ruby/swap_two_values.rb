a = 69
b = 420

puts "a: #{a}"
puts "b: #{b}"

# First approach
# x = a
# y = b
# a = y
# b = x
#
# puts "a: #{a}"
# puts "b: #{b}"

# Second approach
# x = a
# a = b
# b = x
# puts "a: #{a}"
# puts "b: #{b}"

# Third approach
a = a^b # a = 69^420
b = a^b # b = 69^420^420 
a = a^b # a = 69^420^69
puts "a: #{a}"
puts "b: #{b}"
