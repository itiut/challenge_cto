module ChallengeCTO
  class Level1
    # Select optimal coupons.
    #   Optimal means that:
    #   1. total value of coupons is highest
    #   2. total value of coupons is not greater than price
    #   3. the number of coupons is smallest
    #
    # @param [Fixnum] price
    # @param [Array(Fixnum, Fixnum, Fixnum)] coupons the number of coupons that can be used
    #   values of each coupons are 500, 100 and 50 in order from the beginning of the Array.
    # @return [Array(Fixnum, Fixnum, Fixnum)] coupons that is optimal
    #   values of each coupons are same as @param coupons.
    def run(price, coupons)
      values = [500, 100, 50]
      optimals = [0, 0, 0]

      optimals.each_index do |i|
        optimals[i] = [price / values[i], coupons[i]].min
        price -= optimals[i] * values[i]
      end

      optimals
    end
  end
end
