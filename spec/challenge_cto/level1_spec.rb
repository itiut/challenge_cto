require 'spec_helper'

module ChallengeCTO
  describe Level1 do
    describe '#run' do
      let(:runner) { Level1.new }

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
        answer  = [0, 4, 1]

        expect(runner.run(price, coupons)).to eq(answer)
      end

      it 'should pass test case 4' do
        price = 1230
        coupons = [2, 5, 6]
        answer  = [2, 2, 0]

        expect(runner.run(price, coupons)).to eq(answer)
      end
    end
  end
end
