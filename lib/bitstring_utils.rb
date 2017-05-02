module BitstringUtils
  def self.to_int(bitstring)
    memo = 0
    Array(bitstring.try(:chars)).each_with_index do |bit, i|
      bit = bit.to_i
      memo |= 1 << i unless bit.zero?
    end
    memo
  end

  def self.to_string(bits, count)
    Array.new(count) { |i| (bits & (1 << i)).zero? ? "0" : "1" }.join("")
  end
end
