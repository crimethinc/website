class SupportMailer < ApplicationMailer
  default from: 'CrimethInc. Support <contact@crimethinc.com>'

  def edit_subscription
    @email = params[:email]
    @support_session = params[:support_session]
    @host = params[:host]

    mail to: @email, subject: t('.edit_subscription.subject')
  end
end
