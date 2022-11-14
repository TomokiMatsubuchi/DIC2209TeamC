class VendingMachine
  # ステップ０　お金の投入と払い戻しの例コード
  # ステップ１　扱えないお金の例コード
  
  include StockControl, MoneyManagement
  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 初期値を設定する
    @slot_money = 0
    # 最初の自動販売機に入っている金額は0円
    @sales_amount = 0
    # 最初の売上は０円を定義する（amount)
    @drinks = { cola: {price: 120, stock: 5} }
    # 最初のコーラの値段と在庫を定義する
  end

  #@drinksの値段[:price]と在庫[:stock]の情報を取り出し、@slot_moneyが値段以上かつ在庫が0より多い場合に、現在の購入可能なドリンクの情報を取得する。selectメソッドは配列で返すため、keysでキーの情報を取得している。
  def stock_list
    @drinks.select { |drink, content|  content[:price] <= @slot_money && content[:stock] > 0  }.keys
    # ドリンクの値段と在庫が投入金額かつ在庫がある場合？
    # .keys=キーだけを配列の中に取り出す
  end
  def buy?(price, stock)
    # buy?メソッド＝真偽値（trueかfalse）
    # buy_drinkの(price,stock)の変数を代入
    # price = @drinks[drink_id][:price]
    # ドリンクの値段を定義
    # stock = @drinks[drink_id][:stock]
    # ドリンクの在庫を定義
    if @slot_money >= price && stock > 0
    # if文 => 投入金額が価格より多くて、かつ、在庫があるかどうかを真偽する
      return true
    else
      return false
    # trueかfalseのどちらかをかえす。
    end
  end
    # 【投入金額が値段以上で買うと、在庫を減らし、売上を増やす】
  def buy_drink
    if stock_list == []
      # 配列(買える商品)が空の場合の処理
      puts "品切れ中です"
    else
      puts "-----販売中----"
      p stock_list
      # stock_list(買える商品)が配列だとわかる処理
      puts "---------------"
      puts "欲しい商品番号を入力してください"
      puts"左から０から２を入力してください"
      drink = gets.to_i
      # getsメソッドは入力した値を文字列として取得する
      # to_iメソッドは数値オブジェクトに変換する
      drink_id = stock_list[drink]
      # stock_listから該当のドリンクを取得したものをdrink_idに代入する。
      price = @drinks[drink_id][:price]
      # 変数の値を"シンボル:キー(drink_id)"を使って取り出す
      stock = @drinks[drink_id][:stock]
      # 変数の値を"シンボル:キー(drink_id)"を使って取り出す
      if buy?(price, stock)
        # (price,stock)の変数を代入
        # コードを代入してるので、スマートにする
        stock = stock-1
        # 在庫を減らす
        @sales_amount += price
        # 売上を増やす
        @slot_money -= price
        # 投入金額からドリンク代を減らす
        return_money
        # お釣りを返して、お金の中身を空にする
        # def return_money
        #   puts @slot_money
        #   @slot_money = 0
        # end
        # @drinks[:cola][:stock] = @drinks[:cola][:stock]-1
        # 在庫を減らす
        # @sales_amount += @drinks[:cola][:price]
        # 売上を増やす
        # @slot_money -= @drinks[:cola][:price]
        # 投入金額からドリンク代を減らす
      end
    end
  end
end
# 【irb仕様書】
# require_relative'VendingMachine'
# load("ファイル名.rb")
# v=VendingMachine.new
# v.（メソッド名）

module StockControl
  #在庫を表示する
  def stock_checker
    @drinks
  end 

  # 【商品を増やすメソッド】
  def stock_add
    @drinks[:redbull] = {price: 200, stock: 5}
    # ハッシュ（キーとバリュー）を使って、レッドブルの値段と在庫を追加する。
    @drinks[:water] = {price: 100, stock: 5}
    # ハッシュ（キーとバリュー）を使って、お水の値段と在庫を追加する。
  end
end

module MoneyManagement
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze
  # freezeメソッド=>絶対に変更できないようにする
  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end

    # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
    # 投入は複数回できる。
  def slot_money
    puts "------------------------------------------------------"
    puts "10円玉、50円玉、100円玉、500円玉、1000円札から投入してください"
    money = gets.to_i
    # 想定外のもの（１円玉や５円玉。千円札以外のお札、そもそもお金じゃないもの（数字以外のもの）など）
    # が投入された場合は、投入金額に加算せず、それをそのまま釣り銭としてユーザに出力する。
    return false unless MONEY.include?(money)
    # 自動販売機にお金を入れる
    @slot_money += money
  end

  # 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
  def return_money
    # 返すお金の金額を表示する
    puts "#{@slot_money}円です"
    # 自動販売機に入っているお金を0円に戻す
    @slot_money = 0
  end

  # 【売上を定義し、出力させる】
  def current_sales_amount
    @sales_amount
  end
end