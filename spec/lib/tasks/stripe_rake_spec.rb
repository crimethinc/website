require 'rails_helper'
require 'rake'

RSpec.describe 'stripe:create_prices' do
  let(:product) { Struct.new(:id).new('prod_test_123') }
  let(:price)   { Struct.new(:id).new('price_test_456') }

  let(:expected_amounts) do
    [
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
  end

  before do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
    allow(Stripe::Product).to receive(:create).and_return(product)
    allow(Stripe::Price).to receive(:create).and_return(price)

    Rake::Task['stripe:create_prices'].reenable
    Rake::Task['stripe:create_prices'].invoke
  end

  it 'creates a product' do
    expect(Stripe::Product).to have_received(:create).once.with(
      name:     'Monthly CrimethInc. Support',
      metadata: { managed_by: 'crimethinc_rake' }
    )
  end

  it 'creates 85 recurring prices' do
    expect(Stripe::Price).to have_received(:create).exactly(85).times
  end

  it 'creates a price for each expected amount with correct params' do
    expected_amounts.each do |amount|
      expect(Stripe::Price).to have_received(:create).with(
        product:     'prod_test_123',
        currency:    'usd',
        unit_amount: amount * 100,
        recurring:   { interval: 'month' },
        lookup_key:  "crimethinc_monthly_#{amount}",
        metadata:    { managed_by: 'crimethinc_rake' }
      )
    end
  end
end
