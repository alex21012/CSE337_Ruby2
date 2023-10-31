#Alex Porokhin
#113423484
class Array
  alias_method :og_brackets, :[]
  def [](index)
      if index.is_a?(Range)
          index.map { |i| i.between?(-self.size, self.size-1) ? og_brackets(i) : '\0' }
      else
          index.between?(-self.size, self.size-1) ? og_brackets(index) : '\0'
      end
  end
  def map(range = nil, &block)
      return super(&block) if range.nil?

      mapped_range = range.map { |i| i < 0 ? self.size + i : i }
      valid_range = (mapped_range.first..[mapped_range.last, self.size - 1].min)
      valid_range.each_with_object([]) do |i, arr|arr << (i.between?(0, self.size-1) ? block.call(self[i]) : '\0')
      end
  end
end

# Sample test cases
a = [1, 2, 34, 5]
puts a[1]       # Output: 2
puts a[10]      # Output: '\0'
print a.map(2..4) { |i| i.to_f }, "\n"  # Output: [34.0, 5.0]
print a.map { |i| i.to_f }, "\n"        # Output: [1.0, 2.0, 34.0, 5.0]

b = ["cat", "bat", "mat", "sat"]
puts b[-1]      # Output: "sat"
puts b[5]       # Output: '\0'
print b.map(2..10) { |x| x[0].upcase + x[1, x.length] }, "\n"   # Output: ["Mat", "Sat"]
print b.map(2..4) { |x| x[0].upcase + x[1, x.length] }, "\n"    # Output: ["Mat", "Sat"]
print b.map(-3..-1) { |x| x[0].upcase + x[1, x.length] }, "\n"  # Output: ["Bat", "Mat", "Sat"]
print b.map { |x| x[0].upcase + x[1, x.length] }, "\n"          # Output: ["Cat", "Bat", "Mat", "Sat"]

