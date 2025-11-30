module RichLib
  class << self
    def hashids(name)
      Hashids.new "Default ID Obfuscation Salt for #{name}", 6, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    end

    def encode(id, name)
      hashids(name).encode(id)
    end

    def decode(id, name)
      hashids(name).decode(id)
    end
  end
end
