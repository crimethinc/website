# Replace SupportSession with Stripe Customer Portal Link

Branch: `update_stripe_strategy`

## Goal

Remove the homegrown passwordless-auth `SupportSession` flow and replace it
with Stripe's static Customer Portal login link. Also remove the unused
webhook endpoint. Stripe handles customer email verification itself.

## Stripe-side setup (manual)

- [ ] In Stripe Dashboard → Settings → Billing → Customer Portal, ensure the
      portal is configured (cancel, update payment method, etc.)
- [ ] Enable the **portal login link** (shareable URL) so customers can
      self-serve without us generating sessions server-side
- [ ] Note the portal login URL for use in the view

## Code to remove

- [ ] `app/models/support_session.rb`
- [ ] `app/mailers/support_mailer.rb`
- [ ] `app/views/support_mailer/edit_subscription.html.erb`
- [ ] `app/views/support_mailer/edit_subscription.text.erb`
- [ ] `spec/mailers/previews/support_mailer_preview.rb`
- [ ] `destroy_expired_support_sessions` task from `lib/tasks/scheduler.rake`
      (and from Heroku Scheduler config)
- [ ] Controller actions: `edit`, `create_session`,
      `stripe_subscription_payment_succeeded_webhook`, and private helper
      `customer_with_subscription` from `app/controllers/support_controller.rb`
- [ ] Routes: `support/create_session`, `support/edit/:token`, and webhook
      route from `config/routes.rb`
- [ ] I18n keys from `config/locales/en.yml`: `views.support.create_session`,
      `views.support.edit`, `views.support.new.support_request`,
      `views.support.mailers`
- [ ] Session-related tests from `spec/requests/support_spec.rb`
- [ ] Write a migration to drop the `support_sessions` table

## Code to change

- [ ] `app/views/2017/support/new.html.erb`: Replace the "manage subscription"
      email form (`.support-request` div) with a direct link to the Stripe
      Customer Portal login URL
- [ ] `app/controllers/support_controller.rb`: Remove `protect_from_forgery`
      exception (was only needed for the webhook)

## Order of operations

1. Configure Stripe portal login link in Dashboard (manual)
2. Update the view to link to the portal URL
3. Remove controller actions, routes, webhook, mailer, model
4. Write + run migration to drop `support_sessions` table
5. Remove scheduled task from rake + Heroku Scheduler
6. Clean up i18n keys and specs
7. Test end-to-end: new donations, subscription management via portal link
