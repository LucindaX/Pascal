class Url < ActiveRecord::Base
  attr_accessor :base_url
  validates_presence_of :url
  validates_format_of :url, with: %r"\A(https?://)?[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]{2,6}(/.*)?\Z"i
  validate :url_domain

  after_create do
    self.short = (self.id).to_s(36)
    save!
  end

  def url_domain
    domain = url.gsub(/http:\/\//,"")
    domain = domain.match(/([^\/]+)/)[0]
    errors.add(:url, "shortned domain") if domain =~ Regexp.new(base_url)
  end

  def self.clean_url(url)
    url.gsub!(/^https?:\/\//, "")
    url.gsub!(/^www./, "")
    url.gsub!(/\/$/, "")
    url = "http://"+url
  end

end
