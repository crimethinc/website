# Preview all emails at http://localhost:3000/rails/mailers/support_mailer
class SupportMailerPreview < ActionMailer::Preview
  def edit
    support_session = SupportSession.new(
      stripe_customer_id: 'stripe-customore-id-123',
      token:              SecureRandom.urlsafe_base64(nil, false),
      expires_at:         1.hour.from_now
    )

    SupportMailer.with(
      email:           'test@example.com',
      support_session: support_session,
      host:            'localhost:3333'
    ).edit_subscription
  end
end
