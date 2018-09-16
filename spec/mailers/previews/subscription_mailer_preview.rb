# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview
  def edit
    SubscriptionMailer.with(
      email: 'test@example.com',
      subscription: SupportSession.first,
      host: 'localhost:3333'
    ).edit
  end
end
