require_relative '../test_helper'

describe Sigmund do

  let(:uri) { URI('http://www.test.com/path?query#fragment') }

  describe "sign" do
    it "signs with sha1" do
      u = Sigmund.sign("http://www.test.com/path", 'test')
      u.to_s.must_equal('http://www.test.com/path?sig=ZCqYKJiLS7WMZX7l5wEU016Mv1s')
    end

    it "signs with other key" do
      u = Sigmund.sign("http://www.test.com/path", 'test' + 'Z')
      u.to_s.must_equal('http://www.test.com/path?sig=TVQPBRB9DUagk9N7mf6z3YIIHaE')
    end

    it "signs with other url" do
      u = Sigmund.sign("http://www.test.com/path?query#fragment", 'test')
      u.to_s.must_equal('http://www.test.com/path?query&sig=fEpucXVmFSzkC6V4MMcXDmYEhk4#fragment')
    end
  end

  describe "verify" do
    it "verifies with sha1" do
      v = Sigmund.verify("http://www.test.com/path?sig=ZCqYKJiLS7WMZX7l5wEU016Mv1s", 'test')
      v.must_equal(true)
    end

    it "fails if sig incorrect" do
      v = Sigmund.verify("http://www.test.com/path?sig=ZCqYKJiLS7WMZX7l5wEU016Mv1s" + 'Z', 'test')
      v.must_equal(false)
    end

    it "fails if key incorrect" do
      v = Sigmund.verify("http://www.test.com/path?sig=ZCqYKJiLS7WMZX7l5wEU016Mv1s", 'test' + 'Z')
      v.must_equal(false)
    end

    it "fails if query incorrect" do
      v = Sigmund.verify("http://www.test.com/path?sigg=ZCqYKJiLS7WMZX7l5wEU016Mv1s", 'test')
      v.must_equal(false)
    end

    it "fails if sig missing" do
      v = Sigmund.verify("http://www.test.com/path", 'test')
      v.must_equal(false)
    end
  end

  describe "verify" do
    it "raises if sig incorrect" do
      proc { Sigmund.verify!("http://www.test.com/path?sig=ZCqYKJiLS7WMZX7l5wEU016Mv1s" + 'Z', 'test') }.must_raise Sigmund::SignatureBrokenError
    end
  end

end
