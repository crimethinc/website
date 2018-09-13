class SubscriptionMailer < ApplicationMailer
  def edit
    @email = params[:email]
    @subscription = params[:subscription]
    @host = params[:host]

    mail to: @email, subject: 'Request to update your CrimethInc Support'
  end
end
