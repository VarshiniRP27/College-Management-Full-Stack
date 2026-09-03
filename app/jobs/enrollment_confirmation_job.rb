class EnrollmentConfirmationJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: 5.seconds, attempts: 3

  def perform(enrollment_id)
    enrollment = Enrollment
                 .includes(:student, :course)
                 .find(enrollment_id)

    EnrollmentMailer
      .with(enrollment_id: enrollment.id)
      .confirmation
      .deliver_now

    Rails.logger.info(
      "Enrollment confirmation email sent for enrollment #{enrollment.id}"
    )
  end
end