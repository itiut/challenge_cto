module ChallengeCTO
  class Level2
    # values of each coupons
    VALUES = [500, 100, 50]

    # Select optimal coupons within the limitations.
    #   Optimal means that:
    #   1. total value of coupons is highest
    #   2. total value of coupons is not greater than price
    #   3. the number of coupons is smallest
    #
    # @param [Fixnum] price
    # @param [Array(Fixnum, Fixnum, Fixnum)] coupons the number of coupons that can be used
    #   Values of each coupons are 500, 100 and 50 in order from the beginning of the Array.
    #   The number of coupons that can be use at the same time is limited as follows:
    #     1. 500-yen coupon:
    #       * If this coupon is used, other kind of coupons cannot be used.
    #       * At most one 500-yen coupon can be used at the same time.
    #     2. 100-yen coupon:
    #       * If this coupon is used, other kind of coupons also can be used.
    #       * At most three 100-yen coupons can be used at the same time.
    #     3. 50-yen coupon:
    #       * If this coupon is used, other kind of coupons also can be used.
    #       * Any number of 50-yen coupons can be used at the same time.
    #
    # @return [Array(Fixnum, Fixnum, Fixnum)] coupons that is optimal
    #   Values of each coupons are same as @param coupons.
    def run(price, coupons)
      candidates = []

      # use one 500-yen coupon
      candidates << [1, 0, 0] if price >= 500 && coupons[0] > 0

      # use other coupons
      other_coupons = [
        0,                      # do not use 500-yen coupons
        [coupons[1], 3].min,    # use at most three 100-yen coupons
        coupons[2]
      ]
      candidates << optimal_coupons(price, other_coupons)

      optimal_candidate(candidates)
    end

    private

    # Select optimal coupons.
    #   Optimal means that:
    #   1. total value of coupons is highest
    #   2. total value of coupons is not greater than price
    #   3. the number of coupons is smallest
    # This method is same as Level1#run.
    #
    # @param [Fixnum] price
    # @param [Array(Fixnum, Fixnum, Fixnum)] coupons the number of coupons that can be used
    #   Values of each coupons are 500, 100 and 50 in order from the beginning of the Array.
    # @return [Array(Fixnum, Fixnum, Fixnum)] coupons that is optimal
    #   Values of each coupons are same as @param coupons.
    def optimal_coupons(price, coupons)
      optimals = [0, 0, 0]
      optimals.each_index do |i|
        optimals[i] = [price / VALUES[i], coupons[i]].min
        price -= optimals[i] * VALUES[i]
      end
      optimals
    end

    # Select optimal coupons from candidates.
    #
    # @param [Array<Array(Fixnum, Fixnum, Fixnum)>] candidates arrays of candidate coupons
    # @return [Array(Fixnum, Fixnum, Fixnum)] optimal coupons
    def optimal_candidate(candidates)
      candidates.max(&method(:compare))
    end

    # Compare which coupons are better.
    #
    # @param [Array(Fixnum, Fixnum, Fixnum)] coupons0 coupons to be compared with
    # @param [Array(Fixnum, Fixnum, Fixnum)] coupons1 coupons to be compared with
    # @return [Fixnum] compared result
    def compare(coupons0, coupons1)
      total_values = [coupons0, coupons1].map(&method(:total_value))

      # If total values of the coupons are same, the coupons of smaller number are better.
      if total_values[0] == total_values[1]
        n_of_coupons = [coupons0, coupons1].map { |coupons| coupons.reduce(0, :+) }
        return n_of_coupons[1] <=> n_of_coupons[0]
      end

      # Othersize, the coupons of higher value are better.
      total_values[0] <=> total_values[1]
    end

    # Calculate total value of the coupons
    #
    # @param [Array(Fixnum, Fixnum, Fixnum)] coupons
    # @return Fixnum total value of the coupons
    def total_value(coupons)
      total = 0
      VALUES.each_index do |i|
        total += VALUES[i] * coupons[i]
      end
      total
    end
  end
end
