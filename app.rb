require 'sinatra'
require 'sinatra/reloader'

# ブラウザに表示するフォームのクラス
class MyForm
  # @timesへのアクセスメソッド
  attr_accessor :times  

  def initialize
    @times = 0    # ボタンをクリックした回数
  end

  def btn_clicked
    # ボタンをクリックするとカウントアップ
    @times += 1
  end
end
 
myform = MyForm.new

# URL'/'にアクセス
get '/' do
  # ボタンの数字を0にしてviewsフォルダのindex.erbを表示
  myform.times = 0
  @btn_caption = myform.times
  erb :index
end

# URL'/'にPOSTメソッドでアクセス
post '/' do
  # ボタンの数字を増やしてviewsフォルダのindex.erbを表示
  @btn_caption = myform.btn_clicked
  erb :index
end
