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
end
