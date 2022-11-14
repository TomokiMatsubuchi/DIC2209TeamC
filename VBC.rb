module LoopMaster
  
  def boolean_loop(comment)
    while true
      puts "続けて#{comment}しますか？(y/n)"
      continue = gets.chomp
      if continue == "y"
        break true
      elsif continue == "n"
        return false
      else
        puts "yかnで入力してください"
      end
    end
  end
end  

class VendingMachine
  
  include LoopMaster

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
    while true
      if stock_list == []
        puts "品切れ中です"
        return
      else
        puts "-----販売中----"
        p stock_list
        puts "---------------"
        puts "欲しい商品番号を入力してください"
        puts"左から1 ~ #{stock_list.length}を選んで入力してください"
        drink = gets.to_i - 1
        drink_id = stock_list[drink]
        price = @drinks[drink_id][:price]
        stock = @drinks[drink_id][:stock]  
        if buy?(price, stock)
          stock = stock-1
          @cash.sales_amount += price
          @slot_money -= price
        end
      end
      puts "残金は#{@slot_money}円です。"
      if boolean_loop("商品を購入") == false
        @cash.return_money(@slot_money)
        puts "まいどおおきに"
        return
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

  include LoopMaster
  
  def initialize
    @sales_amount = 0
    @slot_money = 0
  end

  def insert_money
    while true
      puts "------------------------------------------------------"
      puts "10円玉、50円玉、100円玉、500円玉、1000円札から投入してください"
      money = gets.to_i
      unless MONEY.include?(money)
        return_money(@slot_money + money)
        money = 0
        break false
      else  
        @slot_money += money
      end
      puts "現在#{@slot_money}円投入されています。"
      return if boolean_loop("お金を投入") == false
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

StartUp.purchase

# 【irb仕様書】
# require_relative'VendingMachine'
# load("ファイル名.rb")
# v=VendingMachine.new
# v.（メソッド名）