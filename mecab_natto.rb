require 'natto'

module MeCabNatto

  def setarg(opt)
    @mecab_natto = Natto::MeCab.new(opt)
  end

  def analyze(text)
    @mecab_natto.enum_parse(text)
  end

  module_function :setarg, :analyze
end

# モジュール単体テスト用のスクリプト
if $0 == __FILE__

  # 出力フォーマットを指定して和布蕪納豆を作る
  MeCabNatto::setarg('-F%m\s%F-[0,1,2]')

  # 標準入力を取得
  while line = gets() do
    line.chomp!
    break if line.empty?

    # 解析する
    enum = MeCabNatto::analyze(line)

    # 解析結果を表示
    enum.each do |n|
      puts n.feature
    end
  end
end
