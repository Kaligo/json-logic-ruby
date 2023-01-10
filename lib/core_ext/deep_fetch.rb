require 'backport_dig' if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.3')
require 'singleton'

class VarCache

  include Singleton

  def self.fetch_or_store(key)
    instance.fetch_or_store(key)
  end

  def initialize
    @storage = {}
  end

  def fetch(key)
    @storage[key]
  end

  def store(key)
    @storage[key] = attributes(key)
  end

  def fetch_or_store(key)
    fetch(key) || store(key)
  end

  private

    def attributes(key)
      key.to_s.split('.')
    end

end

class Object
  def deep_fetch(key, default = nil)
    keys = VarCache.fetch_or_store(key)
    keys.inject(self) { |memo, item| memo.send(item) rescue default }
  end
end

class Hash
  def deep_fetch(key, default = nil)
    keys = VarCache.fetch_or_store(key)
    value = dig(*keys) rescue default
    value.nil? ? default : value  # value can be false (Boolean)
  end
end

class Array
  def deep_fetch(index, default = nil)
    indexes = VarCache.fetch_or_store(index).map(&:to_i)
    value = dig(*indexes) rescue default
    value.nil? ? default : value  # value can be false (Boolean)
  end
end
