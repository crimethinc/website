# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview
  def edit
    SubscriptionMailer.with(
      subscription: SubscriptionSession.first,
      email: 'test@gmail.com'
    ).edit
  end
end
