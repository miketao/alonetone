# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def authorized_for(user_related_record)
    logged_in? && (current_user.admin? || (user_related_record.user == current_user))
  end
  
  def authorized_for_comment(commment)
    (logged_in? && admin?) || (logged_in? && (comment.commenter == current_user || comment.user == current_user))
  end
  
  def edit_or_show(user, playlist)
    if authorized_for(playlist)
      edit_user_playlist_path(@user.login, playlist)
    else
      user_playlist_path(@user.login, playlist.permalink)
    end
  end
  
  def mp3_info_for(asset)
    mp3 = Mp3Info::Mp3Info.new(asset.authenticated_s3_url)
    "Filename: #{asset.permalink}<br/>Length: #{mp3.length}<br/>Name: #{mp3.tag.title}<br/>Artist: #{mp3.tag.artist} <br/>Album: #{mp3.tag.album}<br/>#{mp3.to_s}"
  rescue
    "File #{asset.permalink} was unopenable or did not exist."
  end
  
  def offer(html)
    result = '<div id="offer">'
    result += html
    result += '</div>'
    result
  end
  
  def rss_date(date)
    CGI.rfc1123_date(date)
  end
  
  def website_for(user)
    link_to "#{user.name}'s website", ('http://'+h(user.website))
  end
  
  def itunes_link_for(user)
    link_to "Open #{user.name}'s music in iTunes", 'http://'+h(user.itunes)
  end
  
  def avatar(user, size=nil)
    case size
      when 100 then image_tag(user.has_pic? ? user.pic.public_filename(:large) : 'no-pic-thumb100.jpg')
      when 50 then image_tag(user.has_pic? ? user.pic.thumb.public_filename(:small) : 'no-pic-thumb50.jpg')
      when nil then image_tag(user.has_pic? ? user.pic.public_filename(:tiny) : 'no-pic.jpg' )
    end
  end
  
  def user_location(user)
      "from " + ((user.city) ? "#{user.city}, " : '') + user.country if user.city || user.country
  end
  
  def track_name_for(asset, length=40)
    truncate(h(asset.name),length)
  end

  def link_to_play(asset, referer=nil)
    link_to ' ', formatted_user_track_path(asset.user.login, asset.permalink, :mp3), :id=>"play-#{asset.id}", :class => 'play_link', :referer => referer
  end
  
  def user_nav_item(text, link, added_class='link')
    content_tag(:li, link_to_unless_current(text, link),:class=> ("#{added_class} #{"current" if current_page?(link)}"))
  end
  
  def recently_online
    @online.each {|person| link_to person.login, user_home_path(person) }
  end
  
  def authorized?
    admin? || @user === current_user 
  end
end
