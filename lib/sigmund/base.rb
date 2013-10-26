require 'digest/hmac'
require 'base64'

module Sigmund

  class Base

    def self.hmac_procedure(key, digester)
      Proc.new do |data|
        hmac = Digest::HMAC.new(key, digester)
        hmac.update(data)
        hmac.digest
      end
    end

    def self.sign_uri(uri, proc, exclude, param)
      normalized = normalize_uri(uri, exclude, param)
      sig = compute_signature(normalized, proc)
      append_signature(uri, sig, param)
    end

    def self.verify_uri(uri, proc, exclude, param)
      normalized = normalize_uri(uri, exclude, param)
      sig = compute_signature(normalized, proc)
      (extract_signature(uri, param) == sig)
    end

    def self.normalize_uri(uri, exclude, param)
      u = uri.dup
      if u.query
        components = u.query.split('&')
        components.reject! { |c| c.start_with?(param + '=') }
        u.query = components.join('&')
      end
      u.scheme = nil if u.scheme == '' || exclude.include?(:scheme)
      u.host = nil if u.host == '' || exclude.include?(:host)
      u.path = '' if u.path == nil || exclude.include?(:path)
      u.query = nil if u.query == '' || exclude.include?(:query)
      u.fragment = nil if u.fragment == '' || exclude.include?(:fragment)
      u.normalize!
      u
    end

    def self.compute_signature(uri, proc)
      data = proc.call(uri.to_s)
      encode_base64(data)
    end

    def self.append_signature(uri, signature, param)
      u = uri.dup
      u.query ||= ''
      u.query += (u.query.size > 0 ? '&' : '')
      u.query += param + '=' + signature
      u
    end

    def self.extract_signature(uri, param)
      return unless uri.query
      components = uri.query.split('&').select{ |c| c.start_with?(param + '=') }
      return unless components.size == 1
      components.first[4..-1]
    end

    def self.encode_base64(data)
      Base64.urlsafe_encode64(data).gsub('=','')
    end

    def self.decode_base64(data)
      padded = data + ('=' * (-data.size % 4))
      Base64.urlsafe_decode64(padded)
    end

  end

end
