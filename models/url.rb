class Url < ActiveRecord::Base
  
  validates_presence_of :url

  before_create :clean_url

  after_create do
    self.short = (self.id).to_s(36)
    save!
  end

  def clean_url
    self.url = url.gsub(/^https?:\/\//, "")
    self.url.gsub!(/^www./, "")
    self.url.gsub!(/\/$/, "")
  end

end
