x1 = 5
x2 = 7

range1 = x1..x2

y1 = 1
y2 = 6

range2 = y1..y2

puts range1
puts range2
range = range1.to_a || range2.to_a
puts range.min
puts range.max