require 'spec_helper'

module ChallengeCTO
  describe Level2 do
    let(:runner) { Level2.new }

    describe '#total_value' do
      it 'should calculate total value' do
        expect(runner.send(:total_value, [0, 0, 0])).to eq(0)
        expect(runner.send(:total_value, [2, 0, 0])).to eq(1000)
        expect(runner.send(:total_value, [0, 4, 0])).to eq(400)
        expect(runner.send(:total_value, [0, 0, 6])).to eq(300)
        expect(runner.send(:total_value, [1, 2, 3])).to eq(850)
        expect(runner.send(:total_value, [6, 5, 4])).to eq(3700)
      end
    end

    describe '#optimal_coupons' do
      it 'should pass test case 1 of level1' do
        price = 100
        coupons = [0, 0, 0]
        answer  = [0, 0, 0]

        expect(runner.send(:optimal_coupons, price, coupons)).to eq(answer)
      end

      it 'should pass test case 2 of level1' do
        price = 100
        coupons = [0, 1, 2]
        answer  = [0, 1, 0]

        expect(runner.send(:optimal_coupons, price, coupons)).to eq(answer)
      end

      it 'should pass test case 3 of level1' do
        price = 470
        coupons = [1, 5, 3]
        answer  = [0, 4, 1]

        expect(runner.send(:optimal_coupons, price, coupons)).to eq(answer)
      end

      it 'should pass test case 4 of level1' do
        price = 1230
        coupons = [2, 5, 6]
        answer  = [2, 2, 0]

        expect(runner.send(:optimal_coupons, price, coupons)).to eq(answer)
      end
    end

    describe '#compare' do
      it 'should compare coupons' do
        expect(runner.send(:compare, [0, 0, 0], [0, 0, 0])).to eq(0)
        expect(runner.send(:compare, [1, 2, 3], [1, 2, 3])).to eq(0)
        expect(runner.send(:compare, [4, 5, 6], [2, 3, 4])).to eq(1)
        expect(runner.send(:compare, [3, 4, 5], [4, 5, 6])).to eq(-1)
        expect(runner.send(:compare, [1, 0, 0], [0, 5, 0])).to eq(1)
        expect(runner.send(:compare, [1, 0, 0], [0, 0, 10])).to eq(1)
        expect(runner.send(:compare, [0, 1, 0], [0, 0, 2])).to eq(1)
        expect(runner.send(:compare, [1, 0, 4], [0, 7, 0])).to eq(1)
      end
    end

    describe '#run' do
      it 'should pass test case 1' do
        price = 100
        coupons = [0, 0, 0]
        answer  = [0, 0, 0]

        expect(runner.run(price, coupons)).to eq(answer)
      end

      it 'should pass test case 2' do
        price = 100
        coupons = [0, 1, 2]
        answer  = [0, 1, 0]

        expect(runner.run(price, coupons)).to eq(answer)
      end

      it 'should pass test case 3' do
        price = 470
        coupons = [1, 5, 3]
        answer  = [0, 3, 3]

        expect(runner.run(price, coupons)).to eq(answer)
      end

      it 'should pass test case 4' do
        price = 590
        coupons = [2, 4, 1]
        answer  = [1, 0, 0]

        expect(runner.run(price, coupons)).to eq(answer)
      end
      it 'should pass test case 5' do
        price = 1230
        coupons = [2, 5, 6]
        answer  = [0, 3, 6]

        expect(runner.run(price, coupons)).to eq(answer)
      end
    end
  end
end
