require 'backport_dig' if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.3')

class Object
  def deep_fetch(keys, default = nil)
    case keys.length
    when 0
      self
    when 1
      self.send(keys.first)
    else
      self.send(keys.first).deep_fetch(keys[1..-1], default)
    end

    rescue
      default
  end
end

class Hash
  def deep_fetch(keys, default = nil)
    value = dig(*keys) rescue default
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
