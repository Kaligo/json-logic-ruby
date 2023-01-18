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

    value = keys.inject(self) do |memo, item|
      case memo
      when Hash
        memo[item]
      when Array
        memo[item.to_i]
      else
        memo.send(item)
      end

      rescue
        return default
    end

    value.nil? ? default : value
  end
end
