require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'omniauth/oauth'

enable :sessions
APP_ID      = "YOUR-FACEBOOK-APP-ID" 
APP_SECRET  = "YOUR-FACEBOOK-APP-SECRET"
BASE_URL    = "http://www.irishrail.ie/your_journey/ajax/ajaxRefreshResults.asp?station="

use OmniAuth::Builder do
  provider :facebook, APP_ID, APP_SECRET, { :scope => 'email, status_update, publish_stream' }
end

get '/' do
  erb :index
end

post '/' do
  erb :index
end

get '/train' do
  @station = URI.escape(params[:station])
  doc = Nokogiri::HTML(open("#{BASE_URL}#{@station}"))
  @trains = []
  doc.search('tr').each {|t| @trains << t if t.content =~ /DART/}
  erb :train 
end

get '/auth/facebook/callback' do
  session['fb_auth']  = request.env['omniauth.auth']
  session['fb_token'] = session['fb_auth']['credentials']['token']
  session['fb_error'] = nil
  redirect '/'
end
