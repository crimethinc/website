class SubscriptionMailer < ApplicationMailer
  def edit
    @email = params[:email]
    @support_session = params[:support_session]
    @host = params[:host]

    mail to: @email, subject: 'Request to update your CrimethInc. Support'
  end
end
