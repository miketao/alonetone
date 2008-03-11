
# you are working with git
SVN_COMMAND = 'svn info'
BRIGHTNESS = ''
LASTCHANGED = Date.today

# Set the protect_from_forgery secret key in alonetone.yml
APP_SECRET = YAML.load_file(File.join(RAILS_ROOT,'config','alonetone.yml'))['alonetone']['secret']

# MAKE FACEBOOKER HAPPY
ActionController::Base.asset_host = ''

# FLASH STUFF
FLASH_PLAYER = 'http://alonetone.com/flash/alonetone_player.swf'

# MAILER STUFF

UserMailer.default_url_options[:host] = 'alonetone.com'
UserMailer.mail_from = 'music@alonetone.com'

# GENERATE THE NEEDED CSS STYLESHEETS

Sass::Plugin.update_stylesheets

require 'randomness'
PASSWORD_SALT = 'so_salty_its_unbearable'

# DEPENDENCIES 

begin 
  require 'mp3info'
  require 'zip/zip'
  require 'gchart'
rescue
  raise GemInstallNeeded
end