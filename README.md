# College Management System

A Ruby on Rails college management system built with PostgreSQL and REST APIs.

## Technology Stack

* Ruby 4.0.x
* Rails 8.1.3.1
* PostgreSQL
* Redis
* Sidekiq
* ActiveJob
* Action Mailer
* Minitest

## Main Features

* Student, Teacher, Course and Enrollment management
* REST API under `/api/v1`
* Student search and filtering
* Pagination
* Student statistics
* Token-based authentication
* Role-based authorization
* Enrollment duplicate protection
* Enrollment service object
* Database transactions
* Background enrollment confirmation emails
* Redis and Sidekiq job processing
* Job retry support
* Automated tests

## Models

### Student

* `name`
* `email`
* `age`
* `marks`
* `course_id`

Associations:

* belongs_to Course
* has_many Enrollments

Validations:

* Name required
* Email required and unique
* Age must be greater than 0
* Marks must be between 0 and 100

### Course

* `name`
* `description`
* `teacher_id`

Associations:

* belongs_to Teacher
* has_many Students
* has_many Enrollments

Course name is unique.

### Teacher

* `name`
* `email`

Associations:

* has_many Courses

Name and email are required. Email is unique.

### Enrollment

* `student_id`
* `course_id`
* `enrolled_at`
* `status`

Associations:

* belongs_to Student
* belongs_to Course

A student cannot enroll in the same course more than once.

## API Endpoints

### Authentication

```text
POST /api/v1/auth/register
POST /api/v1/auth/login
```

### Students

```text
GET    /api/v1/students
POST   /api/v1/students
GET    /api/v1/students/:id
PATCH  /api/v1/students/:id
DELETE /api/v1/students/:id
GET    /api/v1/students/statistics
```

Search:

```text
GET /api/v1/students?search=rahul
```

Filtering:

```text
GET /api/v1/students?course_id=1
GET /api/v1/students?min_marks=60
GET /api/v1/students?course_id=1&min_marks=60
```

Pagination:

```text
GET /api/v1/students?page=1&per_page=10
```

### Courses

```text
GET    /api/v1/courses
POST   /api/v1/courses
GET    /api/v1/courses/:id
PATCH  /api/v1/courses/:id
DELETE /api/v1/courses/:id
```

### Enrollments

```text
GET    /api/v1/enrollments
GET    /api/v1/enrollments/:id
POST   /api/v1/enrollments
DELETE /api/v1/enrollments/:id
```

Protected endpoints use:

```text
Authorization: Bearer YOUR_TOKEN
```

## Authorization

The API supports three roles:

### Admin

Full administrative access.

### Teacher

Can manage students and enrollments and access permitted course operations.

### Student

Can view and update their own permitted student information but cannot create or delete students or enrollments.

HTTP status codes:

* `201` — Created
* `200` — Success
* `400` — Bad Request
* `401` — Unauthorized
* `403` — Forbidden
* `404` — Not Found
* `422` — Validation Error

## Enrollment Service

Enrollment creation is handled by:

```text
app/services/enrollments/create.rb
```

The service uses an ActiveRecord transaction and database-level uniqueness protection.

## Background Jobs

After a successful enrollment, `EnrollmentConfirmationJob` sends a confirmation email.

Sidekiq processes the job using Redis.

The job also has retry behavior for temporary failures.

A failed email does not roll back a successful enrollment.

## Database

The application uses PostgreSQL.

Development database:

```text
rails_project_development
```

Test database:

```text
rails_project_test
```

Run migrations:

```bash
bin/rails db:migrate
```

## Redis

Redis runs on port `6380`.

Check Redis:

```bash
"$HOME/redis-stable/src/redis-cli" -p 6380 ping
```

Expected:

```text
PONG
```

## Start Sidekiq

```bash
bundle exec sidekiq
```

## Start Rails

```bash
bin/rails server
```

## Testing

Run all tests:

```bash
bin/rails test
```

Run API tests:

```bash
bin/rails test test/controllers/api/v1
```

Run model tests:

```bash
bin/rails test test/models
```

Run service tests:

```bash
bin/rails test test/services
```

Run job tests:

```bash
bin/rails test test/jobs
```

## Architecture

The application follows a standard Rails MVC structure.

* Controllers handle HTTP requests and JSON responses.
* ActiveRecord models handle database relationships and validations.
* Service objects contain business logic such as enrollment creation.
* ActiveJob/Sidekiq handles background email processing.
* PostgreSQL provides persistent data storage and database constraints.
* Redis provides the Sidekiq job backend.
* API versioning is provided through `/api/v1`.

Enrollment API queries use ActiveRecord eager loading with `includes` to reduce unnecessary database queries for associated students and courses.

## Assignment 3

Implemented Assignment 3 requirements include:

* Rails application with PostgreSQL
* Models and associations
* Database migrations and constraints
* Student CRUD API
* Course CRUD API
* Search and filtering
* Pagination
* Validation and JSON errors
* Student statistics
* Authentication
* Role-based authorization
* Enrollment API
* Duplicate enrollment protection
* Enrollment service object
* Database transaction
* Background confirmation job
* Redis and Sidekiq
* Job retry behavior
* Automated tests
* Eager loading

Optional enhancements such as caching, rate limiting, Swagger/OpenAPI, Docker, audit logging and CI can be added separately.
