# -*- encoding : utf-8 -*-
class User
  
  # has a bunch of prefs
  serialize :settings
  
  before_save :normalize_itunes_url
  
  # deprecated
  def last_seen_at
    last_login_at
  end
  
  def normalize_itunes_url
    self.itunes = itunes.to_s.strip.gsub(/http\:\/\//, "")
  end
  
  def has_public_playlists?
    playlists.public.count >= 1
  end
  
  def has_tracks?
    self.assets_count > 0 
  end
  
  def has_as_favorite?(asset)
    favorite_asset_ids.include?(asset.id)
  end

  def dummy_pic(size)
    case size
      when :album then 'no-pic.png'
      when :large then 'no-pic_large.png'
      when :small then 'no-pic_small.png'
      when :tiny then 'no-pic_tiny.png'
      when nil then 'no-pic.png' 
    end
  end
  
  def avatar(size = nil)
    return dummy_pic(size) unless self.has_pic?
    self.pic.pic.url(size) 
  end
  
  def favorite_asset_ids
    Track.where(:playlist_id => favorites).collect(&:asset_id)
  end
  
  def favorites
    playlists.favorites.first
  end
  
  def has_pic?
    pic && !pic.new_record?
  end
  
  def site
    "#{Alonetone.url}/#{login}"
  end
  
  def printable_bio
    self.bio_html || BlueCloth::new(self.bio).to_html
  end
  
  def website
    self[:website] || site
  end
  
  def name
    self[:display_name] || login
  end
  
  def self.dummy_pic(size)
    first.dummy_pic(size)
  end
  
  def has_setting?(setting, value=nil)
    if value != nil # account for testing against false values
      self.settings.present? && self.settings[setting].present? && (self.settings[setting] == value)
    else
      self.settings.present? && self.settings[setting].present? 
    end
  end
end
