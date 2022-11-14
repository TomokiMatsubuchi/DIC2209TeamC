class VendingMachine
  
  def initialize
    @products = Products.new                           
    @products.new_drinks
    @drinks = @products.drinks
    @cash = Cash.new
  end
  
  def stock_list
    @drinks.select { |drink, content|  content[:price] <= @slot_money && content[:stock] > 0  }.keys
  end

  def buy?(price, stock)
    if @slot_money >= price && stock > 0
      true
    end 
  end
  
  def buy_drink
    return if @cash.insert_money == false
    @slot_money = @cash.slot_money
    
    if stock_list == []
      puts "品切れ中です"
    else
      puts "-----販売中----"
      p stock_list
      puts "---------------"
      puts "欲しい商品番号を入力してください"
      puts"左から０から２を入力してください"
      drink = gets.to_i
      drink_id = stock_list[drink]
      price = @drinks[drink_id][:price]
      stock = @drinks[drink_id][:stock]  
      if buy?(price, stock)
        stock = stock-1
        @cash.sales_amount += price
        @slot_money -= price
        @cash.return_money(@slot_money)
      end
    end
  end
end  
  
class Products 
  attr_accessor :drinks
  def initialize
    @drinks = { cola: {price: 120, stock: 5} }
  end

  def new_drinks
    @drinks[:redbull] = { price: 200, stock: 5 }
    @drinks[:water] = { price: 100, stock: 5 }
  end
end

class Cash 
  attr_accessor :sales_amount, :slot_money
  MONEY = [10, 50, 100, 500, 1000].freeze
  
  def initialize
    @sales_amount = 0
    @slot_money = 0
  end

  def insert_money
    puts "------------------------------------------------------"
    puts "10円玉、50円玉、100円玉、500円玉、1000円札から投入してください"
    money = gets.to_i
    unless MONEY.include?(money)
      return_money(money)
      money = 0
      false
    else  
      @slot_money += money
    end  
  end

  def return_money(money)
    puts "おつりは#{money}円です"
    @slot_money = 0
  end
end

class StartUp
  def self.purchase
    vending_machine = VendingMachine.new
    vending_machine.buy_drink
  end
end

# StartUp.purchase

# 【irb仕様書】
# require_relative'VendingMachine'
# load("ファイル名.rb")
# v=VendingMachine.new
# v.（メソッド名）