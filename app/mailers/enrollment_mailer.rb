class EnrollmentMailer < ApplicationMailer
  def confirmation
    @enrollment = Enrollment.includes(:student, :course).find(params[:enrollment_id])

    mail(
      to: @enrollment.student.email,
      subject: "Enrollment Confirmation"
    )
  end
end
