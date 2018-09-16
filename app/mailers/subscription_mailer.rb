class SubscriptionMailer < ApplicationMailer
  def edit
    @email = params[:email]
    @subscription_session = params[:subscription_session]
    @host = params[:host]

    mail to: @email, subject: 'Request to update your CrimethInc. Support'
  end
end
