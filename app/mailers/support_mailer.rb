class SupportMailer < ApplicationMailer
  def edit_subscription
    @email = params[:email]
    @support_session = params[:support_session]
    @host = params[:host]

    mail to: @email, subject: 'Request to update your CrimethInc. Support'
  end
end
