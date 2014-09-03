require 'spec_helper'
require 'date'

module ChallengeCTO
  class Level3
    describe Coupon do
      describe '#available_at?' do
        it 'should be true if available' do
          c0 = Coupon.new(0)
          expect(c0.available_at?(Date.new(2014, 7, 31))).to be_truthy
          expect(c0.available_at?(Date.new(2014, 8,  1))).to be_truthy
          expect(c0.available_at?(Date.new(2014, 8, 31))).to be_truthy
          expect(c0.available_at?(Date.new(2014, 9,  1))).to be_truthy

          c1 = Coupon.new(0, Date.new(2014, 8, 1), Date.new(2014, 8, 31))
          expect(c1.available_at?(Date.new(2014, 7, 31))).to be_falsey
          expect(c1.available_at?(Date.new(2014, 8,  1))).to be_truthy
          expect(c1.available_at?(Date.new(2014, 8, 31))).to be_truthy
          expect(c1.available_at?(Date.new(2014, 9,  1))).to be_falsey
        end
      end
    end
  end

  describe Level3 do
    let(:runner) { Level3.new }
    let(:coupon_types) { [
        Level3::Coupon.new(1200),
        Level3::Coupon.new(1000, Date.new(2014, 8, 25), Date.new(2014, 8, 27)),
        Level3::Coupon.new(700,  Date.new(2014, 8,  1), Date.new(2014, 8, 31)),
        Level3::Coupon.new(500)
      ]}

    describe '#valid_quantity?' do
      it 'should be true if valid quantity' do
        expect(runner.send(:valid_quantity?, [0, 0, 0, 0], [0, 0, 0, 0])).to be_truthy
        expect(runner.send(:valid_quantity?, [0, 0, 0, 0], [1, 2, 3, 4])).to be_truthy
        expect(runner.send(:valid_quantity?, [1, 2, 3, 4], [8, 7, 6, 5])).to be_truthy
        expect(runner.send(:valid_quantity?, [1, 2, 3, 4], [0, 0, 0, 0])).to be_falsey
        expect(runner.send(:valid_quantity?, [1, 2, 3, 4], [4, 3, 2, 1])).to be_falsey
        expect(runner.send(:valid_quantity?, [1, 2, 3, 4], [1, 3, 2, 4])).to be_falsey
      end
    end

    describe '#total_value' do
      it 'should calculate total value' do
        expect(runner.send(:total_value, [0, 0, 0, 0], coupon_types)).to eq 0
        expect(runner.send(:total_value, [2, 0, 0, 0], coupon_types)).to eq 2400
        expect(runner.send(:total_value, [0, 4, 0, 0], coupon_types)).to eq 4000
        expect(runner.send(:total_value, [0, 0, 6, 0], coupon_types)).to eq 4200
        expect(runner.send(:total_value, [0, 0, 0, 8], coupon_types)).to eq 4000
        expect(runner.send(:total_value, [1, 2, 3, 4], coupon_types)).to eq 7300
        expect(runner.send(:total_value, [8, 7, 6, 5], coupon_types)).to eq 23_300
      end
    end

    describe '#valid_total_value?' do
      it 'should be true if valid total value' do
        expect(runner.send(:valid_total_value?, [0, 0, 0, 0], coupon_types, 0)).to be_truthy
        expect(runner.send(:valid_total_value?, [0, 1, 0, 0], coupon_types, 1000)).to be_truthy
        expect(runner.send(:valid_total_value?, [0, 1, 0, 0], coupon_types, 999)).to be_falsey
      end
    end

    describe '#valid_availability?' do
      it 'should be true if valid availability' do
        expect(runner.send(:valid_availability?, [0, 0, 0, 0], coupon_types, Date.new(2014, 1, 1))).to be_truthy
        expect(runner.send(:valid_availability?, [1, 0, 0, 1], coupon_types, Date.new(2014, 1, 1))).to be_truthy
        expect(runner.send(:valid_availability?, [0, 1, 1, 0], coupon_types, Date.new(2014, 8, 24))).to be_falsey
        expect(runner.send(:valid_availability?, [0, 1, 1, 0], coupon_types, Date.new(2014, 8, 25))).to be_truthy
        expect(runner.send(:valid_availability?, [0, 1, 1, 0], coupon_types, Date.new(2014, 8, 27))).to be_truthy
        expect(runner.send(:valid_availability?, [0, 1, 1, 0], coupon_types, Date.new(2014, 8, 28))).to be_falsey
        expect(runner.send(:valid_availability?, [0, 0, 1, 0], coupon_types, Date.new(2014, 7, 31))).to be_falsey
        expect(runner.send(:valid_availability?, [0, 0, 1, 0], coupon_types, Date.new(2014, 8,  1))).to be_truthy
        expect(runner.send(:valid_availability?, [0, 0, 1, 0], coupon_types, Date.new(2014, 8, 31))).to be_truthy
        expect(runner.send(:valid_availability?, [0, 0, 1, 0], coupon_types, Date.new(2014, 9,  1))).to be_falsey
      end
    end

    describe '#run' do
      it 'should pass test case 1' do
        price = 2200
        coupons = [0, 1, 1, 2]
        answer  = [0, 0, 0, 1]
        date = Date.new(2014, 7, 31)

        expect(runner.run(price, coupons, date)).to eq answer
      end

      it 'should pass test case 2' do
        price = 2200
        coupons = [0, 1, 2, 2]
        answer  = [0, 0, 1, 0]
        date = Date.new(2014, 8, 1)

        expect(runner.run(price, coupons, date)).to eq answer
      end

      it 'should pass test case 3' do
        price = 2200
        coupons = [0, 2, 1, 2]
        answer  = [0, 1, 1, 0]
        date = Date.new(2014, 8, 25)

        expect(runner.run(price, coupons, date)).to eq answer
      end

      it 'should pass test case 4' do
        price = 2200
        coupons = [0, 1, 1, 2]
        answer  = [0, 0, 0, 1]
        date = Date.new(2014, 9, 1)

        expect(runner.run(price, coupons, date)).to eq answer
      end

      it 'should pass test case 5' do
        price = 12_000
        coupons = [1, 1, 0, 0]
        answer  = [1, 0, 0, 0]
        date = Date.new(2014, 8, 27)

        expect(runner.run(price, coupons, date)).to eq answer
      end
    end
  end
end
