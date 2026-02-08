namespace :stripe do
  desc 'Create a Stripe Product and recurring Prices for all support page amounts'
  task create_prices: :environment do
    amounts = [
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
      11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
      21, 22, 23, 24, 25, 30, 35, 40, 45, 50,
      55, 60, 65, 70, 75, 80, 85, 90, 95, 100,
      105, 110, 115, 120, 125, 130, 135, 140, 145, 150,
      200, 250, 300, 350, 400, 450, 500, 550, 600, 650,
      700, 750, 800, 850, 900, 950, 1000, 1500, 2000, 2500,
      3000, 3500, 4000, 4500, 5000, 5500, 6000, 6500, 7000, 7500,
      8000, 8500, 9000, 9500, 10_000
    ]

    puts '==> Creating Stripe Product for monthly support...'
    product = Stripe::Product.create(
      name:     'Monthly CrimethInc. Support',
      metadata: { managed_by: 'crimethinc_rake' }
    )
    puts "    Product created: #{product.id}"

    puts "==> Creating #{amounts.size} recurring Prices..."
    amounts.each do |amount|
      lookup_key = "crimethinc_monthly_#{amount}"

      Stripe::Price.create(
        product:     product.id,
        currency:    'usd',
        unit_amount: amount * 100,
        recurring:   { interval: 'month' },
        lookup_key:  lookup_key,
        metadata:    { managed_by: 'crimethinc_rake' }
      )

      puts "    $#{amount}/mo => #{lookup_key}"
    end

    puts "==> Done! Set STRIPE_MONTHLY_PRODUCT_ID=#{product.id} in your environment."
  end

  desc 'Migrate existing $1 x quantity subscriptions to individual price objects'
  task :migrate_subscriptions, [:mode] => :environment do |_t, args|
    execute = args[:mode] == 'execute'

    puts execute ? '==> EXECUTE MODE: Will modify subscriptions!' : '==> DRY RUN: No changes will be made.'
    puts ''

    subscriptions = fetch_all_subscriptions
    puts "==> Found #{subscriptions.size} active subscription(s)."
    puts ''

    migrated = 0
    skipped  = 0
    errored  = 0

    subscriptions.each do |subscription|
      item     = subscription.items.data.first
      price    = Stripe::Price.retrieve(item.price.id)
      quantity = item.quantity

      if quantity == 1 && price.unit_amount > 100
        puts "  SKIP #{subscription.id}: already using individual price ($#{price.unit_amount / 100}/mo)"
        skipped += 1
        next
      end

      amount     = price.unit_amount / 100 * quantity
      lookup_key = "crimethinc_monthly_#{amount}"

      new_prices = Stripe::Price.list(lookup_keys: [lookup_key], limit: 1)
      new_price  = new_prices.data.first

      if new_price.nil?
        puts "  ERROR #{subscription.id}: no price found for #{lookup_key} ($#{amount}/mo)"
        errored += 1
        next
      end

      puts "  #{execute ? 'MIGRATE' : 'WOULD MIGRATE'} #{subscription.id}: " \
           "$#{price.unit_amount / 100} x #{quantity} => $#{amount}/mo (#{new_price.id})"

      if execute
        Stripe::Subscription.update(
          subscription.id,
          items:              [
            { id: item.id, price: new_price.id, quantity: 1 }
          ],
          proration_behavior: 'none'
        )
      end

      migrated += 1
    end

    puts ''
    puts "==> Summary: #{migrated} migrated, #{skipped} skipped, #{errored} errored"
    puts '==> (Dry run — no changes made. Run with [execute] to apply.)' unless execute
  end
end

def fetch_all_subscriptions
  all    = []
  params = { status: 'active', limit: 100 }

  loop do
    batch = Stripe::Subscription.list(params)
    all.concat(batch.data)
    break unless batch.has_more

    params[:starting_after] = batch.data.last.id
  end

  all
end
