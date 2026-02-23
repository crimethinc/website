require 'rails_helper'
require 'rake'

RSpec.describe 'Stripe rake tasks' do
  before do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
  end

  describe 'stripe:create_prices' do
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

    let(:empty_search) { Struct.new(:data).new([]) }
    let(:empty_list)   { Struct.new(:data).new([]) }

    before do
      allow(Stripe::Product).to receive_messages(search: empty_search, create: product)
      allow(Stripe::Price).to receive_messages(list: empty_list, create: price)

      Rake::Task['stripe:create_prices'].reenable
      Rake::Task['stripe:create_prices'].invoke
    end

    it 'creates a product when none exists' do
      expect(Stripe::Product).to have_received(:create).once.with(
        name:     'Monthly CrimethInc. Support',
        metadata: { managed_by: 'crimethinc_rake' }
      )
    end

    it 'reuses an existing product' do
      allow(Stripe::Product).to receive(:search)
        .and_return(Struct.new(:data).new([product]))

      Rake::Task['stripe:create_prices'].reenable
      Rake::Task['stripe:create_prices'].invoke

      expect(Stripe::Product).to have_received(:create).once # only from the first invoke
    end

    it 'creates 85 recurring prices' do
      expect(Stripe::Price).to have_received(:create).exactly(85).times
    end

    it 'skips prices that already exist' do
      allow(Stripe::Price).to receive(:list)
        .and_return(Struct.new(:data).new([price]))

      Rake::Task['stripe:create_prices'].reenable
      Rake::Task['stripe:create_prices'].invoke

      # 85 from first invoke, 0 from second (all skipped)
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

  describe 'stripe:migrate_subscriptions' do
    let(:old_price) { Struct.new(:id, :unit_amount).new('price_old_1dollar', 100) }
    let(:new_price) { Struct.new(:id, :unit_amount).new('price_new_45', 4500) }
    let(:item)      { Struct.new(:id, :price, :quantity).new('si_item_1', old_price, 45) }

    let(:subscription) do
      Struct.new(:id, :items).new('sub_test_1', Struct.new(:data).new([item]))
    end

    before do
      allow(Stripe::Subscription).to receive(:list)
        .and_return(Struct.new(:data, :has_more).new([subscription], false))
      allow(Stripe::Price).to receive_messages(retrieve: old_price, list: Struct.new(:data).new([new_price]))
      allow(Stripe::Subscription).to receive(:update)
    end

    context 'without execute argument (dry run)' do
      before do
        Rake::Task['stripe:migrate_subscriptions'].reenable
        Rake::Task['stripe:migrate_subscriptions'].invoke
      end

      it 'does not update subscriptions' do
        expect(Stripe::Subscription).not_to have_received(:update)
      end

      it 'looks up the new price by lookup_key' do
        expect(Stripe::Price).to have_received(:list).with(
          lookup_keys: ['crimethinc_monthly_45'],
          limit:       1
        )
      end
    end

    context 'with execute argument' do
      before do
        Rake::Task['stripe:migrate_subscriptions'].reenable
        Rake::Task['stripe:migrate_subscriptions'].invoke('execute')
      end

      it 'updates the subscription with the new price' do
        expect(Stripe::Subscription).to have_received(:update).with(
          'sub_test_1',
          items:              [{ id: 'si_item_1', price: 'price_new_45', quantity: 1 }],
          proration_behavior: 'none'
        )
      end
    end

    context 'when subscription already uses an individual price' do
      let(:individual_price) { Struct.new(:id, :unit_amount).new('price_individual_50', 5000) }
      let(:item)             { Struct.new(:id, :price, :quantity).new('si_item_2', individual_price, 1) }

      before do
        allow(Stripe::Price).to receive(:retrieve).and_return(individual_price)
        Rake::Task['stripe:migrate_subscriptions'].reenable
        Rake::Task['stripe:migrate_subscriptions'].invoke('execute')
      end

      it 'skips the subscription' do
        expect(Stripe::Subscription).not_to have_received(:update)
      end
    end

    context 'when no matching new price exists' do
      before do
        allow(Stripe::Price).to receive(:list).and_return(Struct.new(:data).new([]))
        Rake::Task['stripe:migrate_subscriptions'].reenable
        Rake::Task['stripe:migrate_subscriptions'].invoke('execute')
      end

      it 'does not update the subscription' do
        expect(Stripe::Subscription).not_to have_received(:update)
      end
    end
  end
end
