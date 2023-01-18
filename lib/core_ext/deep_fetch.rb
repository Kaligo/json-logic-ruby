require 'backport_dig' if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.3')

class Object
  def deep_fetch(keys, default = nil)
    case keys.length
    when 0
      self
    when 1
      self.send(keys.first) rescue default
    else
      deep_fetch(keys[1..-1], default)
    end
  end
end

class Hash
  def deep_fetch(keys, default = nil)
    value = keys.inject(self) do |memo, item|
      memo.key?(item) ? memo[item] : memo[item.to_sym]
    rescue
      default
    end
    value.nil? ? default : value  # value can be false (Boolean)
  end
end

class Array
  def deep_fetch(keys, default = nil)
    indices = keys.map(&:to_i)
    value = dig(*indices) rescue default
    value.nil? ? default : value  # value can be false (Boolean)
  end
end
