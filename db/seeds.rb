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

puts
puts "Creating Indian demo data..."

demo_data = [
  {
    teacher_name: "Arjun Sharma",
    teacher_email: "arjun.sharma@example.com",
    course_name: "Computer Science",
    course_description: "Fundamentals of computer science and programming",
    student_name: "Rahul Kumar",
    student_email: "rahul.kumar@example.com",
    age: 20,
    marks: 85
  },
  {
    teacher_name: "Priya Nair",
    teacher_email: "priya.nair@example.com",
    course_name: "Data Science",
    course_description: "Introduction to data analysis and machine learning",
    student_name: "Ananya Reddy",
    student_email: "ananya.reddy@example.com",
    age: 21,
    marks: 92
  },
  {
    teacher_name: "Vikram Singh",
    teacher_email: "vikram.singh@example.com",
    course_name: "Cyber Security",
    course_description: "Fundamentals of cybersecurity and network security",
    student_name: "Aditya Singh",
    student_email: "aditya.singh@example.com",
    age: 19,
    marks: 78
  },
  {
    teacher_name: "Kavya Iyer",
    teacher_email: "kavya.iyer@example.com",
    course_name: "Artificial Intelligence",
    course_description: "Introduction to artificial intelligence concepts",
    student_name: "Sneha Iyer",
    student_email: "sneha.iyer@example.com",
    age: 22,
    marks: 88
  },
  {
    teacher_name: "Ramesh Patel",
    teacher_email: "ramesh.patel@example.com",
    course_name: "Web Development",
    course_description: "Modern web development using frontend and backend technologies",
    student_name: "Karthik Patel",
    student_email: "karthik.patel@example.com",
    age: 20,
    marks: 74
  }
]

demo_data.each do |data|
  teacher = Teacher.find_or_create_by!(email: data[:teacher_email]) do |user|
    user.name = data[:teacher_name]
    user.password = "teacher123"
    user.password_confirmation = "teacher123"
  end

  course = Course.find_or_create_by!(name: data[:course_name]) do |item|
    item.description = data[:course_description]
    item.teacher = teacher
  end

  Student.find_or_create_by!(email: data[:student_email]) do |student|
    student.name = data[:student_name]
    student.age = data[:age]
    student.marks = data[:marks]
    student.course = course
    student.password = "student123"
    student.password_confirmation = "student123"
  end
end

puts "5 Indian teachers, 5 courses, and 5 students created successfully!"
