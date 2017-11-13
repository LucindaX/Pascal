class Url < ActiveRecord::Base
  
  validates_presence_of :url
  validates_format_of :url, with: %r"\A(https?://)?[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]{2,6}(/.*)?\Z"i


  after_create do
    self.short = (self.id).to_s(36)
    save!
  end

  def self.clean_url(url)
    url.gsub!(/^https?:\/\//, "")
    url.gsub!(/^www./, "")
    url.gsub!(/\/$/, "")
    url = "http://"+url if url.slice(1) != "/"
  end

end
