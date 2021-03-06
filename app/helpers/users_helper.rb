# -*- encoding : utf-8 -*-
module UsersHelper
  
  def website_for(user)
    "#{user.name}'s website " + (link_to "#{user.website}", ('http://'+h(user.website)))
  end
  
  def myspace_for(user)
    link_to "#{user.name} on Myspace.com",('http://myspace.com/'+h(user.myspace))
  end
  
  def itunes_link_for(user)
    link_to "Open #{user.name}'s music in iTunes", 'http://'+h(user.itunes)
  end
  
  def avatar(user, size=nil)
    case size
      when 100 then image_tag(user.has_pic? ? user.pic.pic.url(:large) : 'no-pic-thumb100.jpg')
      when 50 then image_tag(user.has_pic? ? user.pic.pic.url(:small) : 'no-pic-thumb50.jpg')
      when nil then image_tag(user.has_pic? ? user.pic.pic.url(:tiny) : 'no-pic.jpg' )
    end
  end
  
  def user_location(user)
    if (user.try(:city) && user.try(:country))
      "from #{[user.city.strip, user.country.strip].compact.join(', ')}" 
    elsif (user.try(:city) || user.try(:country))
      "from #{[user.city.strip, user.country.strip].compact.to_s}" 
    end
  end
  
  def user_image_link(user, size = :large)
    link_to(image_tag(user.avatar(size),
      :class => (user.has_pic? ? '' : 'no_border'),
      :alt => "#{user.name}"), 
      user_home_path(user), 
      :title => " #{user.name}
 #{user.assets_count > 0 ? pluralize(user.assets_count,'uploaded tracks') : ''} 
 Joined alonetone #{user.created_at.to_date.to_s(:long)}
 #{user_location(user)}") 
  end
  
  def notice_hidden?(notice)
    logged_in? && current_user.has_setting?('hide_notice') && current_user.settings['hide_notice'][notice].present?
  end
  
  def setting(symbol_or_string, user=current_user)
    logged_in? && user.settings && user.settings[symbol_or_string.to_sym] 
  end
  
  def favorite_toggle(asset)
    link_to('add to favorites', toggle_favorite_path(:asset_id => asset.id), :class => 'add_to_favorites')
  end
  
  def follow_toggle(user)
    return unless logged_in? and user.id != current_user.id
    is_favorite = current_user.is_following?(user)
    link_to ' ', toggle_follow_user_path(current_user, :followee_id => user.id), 
      :class => 'follow '+(is_favorite ? 'following' : '') 
  end
  
  def new_to_user?(thing)
    thing && (logged_in? and current_user.last_session_at) && (current_user.last_session_at < thing.created_at.utc)
  end

end
