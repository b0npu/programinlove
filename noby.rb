require 'sinatra'
require 'sinatra/reloader'

require_relative 'unmo'


# 会話ログを格納する配列
log_area = []

# ヘルパーメソッドを定義する
# ルーティングメソッドの中で使う
helpers do
  def noby
    # ノビィ生成
    @noby ||= Unmo.new('noby')
  end

  def prompt(resp_opt)
    # 応答を表示する際のプロンプトを作成
    resp_opt ? "#{noby.name}：#{noby.responder_name}" : "#{noby.name}"
  end

  def change_looks
    case noby.mood
    when -5..5 then 'talk'
    when -10..5 then 'angry_talk'
    when -15..-10 then 'more_angry_talk'
    when 5..10 then 'happy_talk'
    when 10..15 then 'more_happy_talk'
    end
  end
end

# URL'/'にアクセス
get '/' do
  # 会話ログを初期化してnobyfomを表示
  log_area = []

  erb :index
end

# URL'/'にPOSTメソッドでアクセス
post '/' do
  # ユーザの入力を取得
  talk_text = params['inputarea']

  # Responderを表示するチェックボックスの状態を取得
  # チェックされてる場合は状態を維持
  resp_opt = params['respoption']
  @check = "checked" if resp_opt

  # ユーザの入力があれば応答して会話ログに表示
  unless talk_text.empty?
    @noby_state = change_looks
    @responder_resp = noby.dialogue(talk_text)
    log_area << "> #{talk_text}<br>"
    log_area << "#{prompt(resp_opt)}> #{@responder_resp}<br>"
  end

  @talk_log = log_area.join

  erb :index
end
