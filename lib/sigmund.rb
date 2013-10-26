require "sigmund/base"

module Sigmund

    class SignatureBrokenError < RuntimeError; end

    @digester = Digest::SHA1
    @exclude = [:scheme, :host]
    @param = 'sig'

    def self.sign(string, key, digester: @digester, exclude: @exclude, param: @param)
      proc = Base.hmac_procedure(key, digester)
      Base.sign_uri(URI(string), proc, exclude, param)
    end

    def self.verify(string, key, digester: @digester, exclude: @exclude, param: @param)
      proc = Base.hmac_procedure(key, digester)
      Base.verify_uri(URI(string), proc, exclude, param)
    end

    def self.verify!(string, key, options = {})
      raise SignatureBrokenError.new unless verify(string, key, *options)
    end
end
