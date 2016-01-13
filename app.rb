require 'sinatra'
require 'sinatra/reloader'

# 会話ログを格納する配列
talk = []

# URL'/'にアクセス
get '/' do
  # nobyfomを表示
  erb :index
end

# URL'/'にPOSTメソッドでアクセス
post '/' do
  # ユーザの入力を会話ログに表示
  talk << "#{params['inputarea']}<br>"
  @talk_log = talk.join

  erb :index
end
