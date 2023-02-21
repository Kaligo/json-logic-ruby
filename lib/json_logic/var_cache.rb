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
