# Adapted from:
#   https://github.com/glebd/cocoafob/blob/master/ruby/licensekey.rb

require "openssl"
require "rubygems"
require "base32"

def make_license_source(product_code, name)
  product_code + "," + name
end

def make_license(product_code, name)
  sign_dss1 = OpenSSL::Digest::DSS1.new
  key_path = File.expand_path(File.dirname(__FILE__) + '/lib/dsapriv512.pem')
  priv = OpenSSL::PKey::DSA.new(File.read(key_path))
  b32 = Base32.encode(priv.sign(sign_dss1, make_license_source(product_code, name)))
  # Replace Os with 8s and Is with 9s
  # See http://members.shaw.ca/akochoi-old/blog/2004/11-07/index.html
  b32.gsub!(/O/, '8')
  b32.gsub!(/I/, '9')
  # chop off trailing padding
  b32.delete("=").scan(/.{1,5}/).join("-")
end

license_code = make_license("MyNewApp", "John Appleseed")
puts license_code
