require_relative '../../test_helper'

describe Sigmund::Base do

  let(:uri) { URI('http://www.test.com/path?query#fragment') }

  describe "hmac_procedure" do
    it "returns sha1 procedure" do
      digest = Sigmund::Base.hmac_procedure('test', Digest::SHA1).call('x')
      Sigmund::Base.encode_base64(digest).must_equal("9nX6BQQtf-lOAkme0pXTWm7b2zo")
    end
  end

  describe "sign_uri" do
    it "signs a uri" do
      u = Sigmund::Base.sign_uri(uri, Proc.new{ |d| d + 'x' }, [], 'sig')
      u.to_s.must_equal('http://www.test.com/path?query&sig=aHR0cDovL3d3dy50ZXN0LmNvbS9wYXRoP3F1ZXJ5I2ZyYWdtZW50eA#fragment')
    end
  end

  describe "normalize_uri" do
    it "downcases scheme and host" do
      u = Sigmund::Base.normalize_uri(URI('hTTp://www.TEST.com/'), [], 'sig')
      u.to_s.must_equal('http://www.test.com/')
    end

    it "appends /" do
      u = Sigmund::Base.normalize_uri(URI('http://www.test.com'), [], 'sig')
      u.to_s.must_equal('http://www.test.com/')
    end

    it "removes empty query" do
      u = Sigmund::Base.normalize_uri(URI('http://www.test.com/?'), [], 'sig')
      u.to_s.must_equal('http://www.test.com/')
    end

    it "removes empty fragment" do
      u = Sigmund::Base.normalize_uri(URI('http://www.test.com/#'), [], 'sig')
      u.to_s.must_equal('http://www.test.com/')
    end

    it "removes existing signature" do
      u = Sigmund::Base.normalize_uri(URI('http://www.test.com/?sig=test'), [], 'sig')
      u.to_s.must_equal('http://www.test.com/')
    end
  end

  describe "compute_signature" do
    it "invokes proc" do
      data = nil
      Sigmund::Base.compute_signature(uri, Proc.new{ |d| data = d })
      data.must_equal(uri.to_s)
    end

    it "returns proc result" do
      sig = Sigmund::Base.compute_signature(uri, Proc.new{ |d| 'test' })
      sig.must_equal('dGVzdA')
    end
  end

  describe "append_signature" do
    it "appends test signature" do
      u = Sigmund::Base.append_signature(uri, 'test', 'sig')
      u.to_s.must_equal('http://www.test.com/path?query&sig=test#fragment')
    end

    it "handles empty signature" do
      u = Sigmund::Base.append_signature(uri, '', 'sig')
      u.to_s.must_equal('http://www.test.com/path?query&sig=#fragment')
    end
  end

  describe "extract_signature" do
    it "extracts test signature" do
      sig = Sigmund::Base.extract_signature(URI("http://www.test.com/path?query&sig=test#fragment"), 'sig')
      sig.must_equal('test')
    end
  end

  describe "encode_base64" do
    it "encodes test string" do
      Sigmund::Base.encode_base64('test').must_equal('dGVzdA')
    end

    it "handles empty string" do
      Sigmund::Base.encode_base64('').must_equal('')
    end
  end

  describe "encode_base64" do
    it "encodes test string" do
      Sigmund::Base.decode_base64('dGVzdA').must_equal('test')
    end

    it "handles empty string" do
      Sigmund::Base.decode_base64('').must_equal('')
    end
  end

end
