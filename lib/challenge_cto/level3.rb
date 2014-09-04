require 'date'

module ChallengeCTO
  class Level3
    class Coupon
      def initialize(value, available_from = nil, available_to = nil)
        @value = value
        @available_between = if available_from && available_to
                               [available_from, available_to]
                             else
                               nil
                             end
      end

      attr_reader :value

      # Return whether this is available at @param date.
      #
      # @param [Date] date
      # @return [Boolean]
      def available_at?(date)
        return true unless @available_between
        date.between?(*@available_between)
      end
    end

    # Select optimal coupons within the limitations.
    #   Optimal means that:
    #   1. total value of coupons is highest
    #   2. total value of coupons is not greater than price
    #   3. the number of coupons is smallest
    #
    # @param [Fixnum] price
    # @param [Array(Fixnum, Fixnum, Fixnum, Fixnum)] coupons the number of coupons that can be used
    #   Values of each coupons are 10% of price, 1000, 700 and 500 in order from the beginning of the Array.
    #   The number of coupons that can be use at the same time is limited as follows:
    #     1. 10% off coupon:
    #       * If this coupon is used, other kind of coupons cannot be used.
    #       * At most one 10% off coupon can be used at the same time.
    #     2. 1000-yen off coupon (limited-time):
    #       * This coupon can be used from 2014-08-25 to 2014-08-27.
    #       * If this coupon is used, other kind of limited-time coupons also can be used.
    #       * If this coupon is used, other king of not limited-time coupons cannot be used.
    #       * At most one 1000-yen off coupons can be used at the same time.
    #     3. 700-yen off coupon (limited-time):
    #       * This coupon can be used from 2014-08-01 to 2014-08-31.
    #       * If this coupon is used, other kind of limited-time coupons also can be used.
    #       * If this coupon is used, other king of not limited-time coupons cannot be used.
    #       * At most one 700-yen off coupons can be used at the same time.
    #     4. 500-yen off coupon:
    #       * If this coupon is used, other kind of coupons cannot be used.
    #       * At most one 500-yen off coupon can be used at the same time.
    # @param [Date] date
    #
    # @return [Array(Fixnum, Fixnum, Fixnum, Fixnum)] coupons that is optimal
    #   Values of each coupons are same as @param coupons.
    def run(price, coupons, date)
      coupon_types = [
        Coupon.new(price / 10),
        Coupon.new(1000, Date.new(2014, 8, 25), Date.new(2014, 8, 27)),
        Coupon.new(700,  Date.new(2014, 8,  1), Date.new(2014, 8, 31)),
        Coupon.new(500)
      ]
      candidates = [
        [1, 0, 0, 0],           # use one 10% off coupon
        [0, 0, 0, 1],           # use one 500-yen off coupon
        [0, 1, 1, 0],           # use one 1000-yen off coupon and one 700-yen off coupon
        [0, 1, 0, 0],           # use one 1000-yen off coupon
        [0, 0, 1, 0],           # use one 700-yen off coupon
        [0, 0, 0, 0]            # do not use coupons
      ]

      valid_candidates = validate(candidates, coupon_types, price, coupons, date)

      optimal_candidate(valid_candidates, coupon_types)
    end

    private

    # Select only valid candidates from @param candidates.
    #
    # @param [Array<Array<Fixnum>>] candidates
    # @param [Array<Coupon>] coupon_types
    # @param [Fixnum] price
    # @param [Array<Fixnum>] max_coupons
    # @param [Date] date
    # @return valid candidates
    def validate(candidates, coupon_types, price, max_coupons, date)
      candidates.select do |candidate|
        # quantity
        next unless valid_quantity?(candidate, max_coupons)

        # total value
        next unless valid_total_value?(candidate, coupon_types, price)

        # availabitily
        next unless valid_availability?(candidate, coupon_types, date)

        true
      end
    end

    # Return whether the number of @param coupons are not graeter than @param max_coupons.
    #
    # @param [Array<Fixnum>] coupons
    # @param [Array<Fixnum>] max_coupons coupons that can be used at most
    # @return [Boolean]
    def valid_quantity?(coupons, max_coupons)
      coupons.each_index do |i|
        return false if coupons[i] > max_coupons[i]
      end
      true
    end

    # Return whether total value of @param coupons are not greater than @param price.
    #
    # @param [Array<Fixnum>] coupons
    # @param [Array<Coupon>] coupon_tyeps
    # @param [Fixnum] price
    # @return [Boolean]
    def valid_total_value?(coupons, coupon_types, price)
      total_value(coupons, coupon_types) <= price
    end

    # Calculate total value of the coupons.
    #
    # @param [Array<Fixnum>] coupons
    # @return Fixnum total value of the coupons
    def total_value(coupons, coupon_types)
      total = 0
      coupons.each_index do |i|
        total += coupons[i] * coupon_types[i].value
      end
      total
    end

    # Return whether @param coupons are available at @param date.
    #
    # @param [Array<Fixnum>] coupons
    # @param [Array<Coupon>] coupon_tyeps
    # @param [Date] date
    # @return [Boolean]
    def valid_availability?(coupons, coupon_types, date)
      coupons.each_index do |i|
        next if coupons[i] == 0
        return false unless coupon_types[i].available_at?(date)
      end
      true
    end

    # Select optimal coupons from candidates.
    #
    # @param [Array<Array<Fixnum>>] candidates arrays of candidate coupons
    # @return [Array<Fixnum>] optimal coupons
    def optimal_candidate(candidates, coupon_types)
      candidates.max do |coupons_0, coupons_1|
        total_values = [
          total_value(coupons_0, coupon_types),
          total_value(coupons_1, coupon_types)
        ]

        if total_values[0] != total_values[1]
          # If total values of the coupons are different, the coupons of higher value are better.
          total_values[0] <=> total_values[1]

        else
          # Otherwise, the coupons of smaller number are better.
          n_of_coupons(coupons_1) <=> n_of_coupons(coupons_0)
        end
      end
    end

    # Calculate the number of @param coupons.
    #
    # @param [Array<Fixnum>] coupons
    # @return [Fixnum] the number of coupons.
    def n_of_coupons(coupons)
      coupons.reduce(0, :+)
    end
  end
end
