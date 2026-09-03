# Development/demo seed data.
# Safe to run repeatedly because records are found by unique email/username/name.

admin = Admin.find_or_create_by!(username: "admin") do |user|
  user.password = "admin123"
end

teacher = Teacher.find_or_create_by!(email: "teacher@example.com") do |user|
  user.name = "Demo Teacher"
  user.password = "teacher123"
  user.password_confirmation = "teacher123"
end

course = Course.find_or_create_by!(name: "Computer Science") do |item|
  item.description = "Introduction to Computer Science"
  item.teacher = teacher
end

student = Student.find_or_create_by!(email: "student@example.com") do |user|
  user.name = "Demo Student"
  user.age = 20
  user.marks = 85
  user.course = course
  user.password = "student123"
  user.password_confirmation = "student123"
end

puts
puts "Seed data ready!"
puts
puts "Admin"
puts "  Username: admin"
puts "  Password: admin123"
puts
puts "Teacher"
puts "  Email: teacher@example.com"
puts "  Password: teacher123"
puts
puts "Student"
puts "  Email: student@example.com"
puts "  Password: student123"
puts
puts "Course"
puts "  Name: Computer Science"
puts
