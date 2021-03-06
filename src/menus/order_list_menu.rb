# frozen_string_literal: true

require 'tty-prompt'
require_relative './menu'
require_relative './place_order_menu'
require './menuitem'
require 'io/console'
require './helpers'

# The OrderListMenu class represents the menu in which users can navigate the Orders a table has as well as
# place and edit orders for a table
class OrderListMenu < Menu
  # initialises the @table class instance variable as well as the Menu's options
  def initialize(table)
    @table = table
    super("Table #{table.table_num} Orders", create_options)
  end

  # The create_options method generates a list of options to be displayed to the user.
  def create_options
    options = @table.orders.map do |menuitem|
      { name: menuitem.name, value: menuitem }
    end
    options << { name: 'Back', value: :break }
    options.unshift({ name: 'Place new order', value: :new_order }, { name: 'Process table', value: 'Tabulate' })
    @bill_total = sum_bill(@table.orders)
    options.unshift({ name: "Bill total: $#{@bill_total}", value: nil, disabled: '' })
  end

  # sum_bills returns bill_total and iterates of order which is an array of menu_items
  #
  # @param orders [Array] an array containing a list of all orders made for a table
  #
  # @return A total of the tables bill 'bill_total' [Float]
  def sum_bill(orders)
    bill_total = 0
    orders.each do |menuitem|
      bill_total += menuitem.price
    end
    return bill_total
  end

  # handle_selection has been over written to handle the users menu selection.
  # Selection 1: Bill total: $x - > will display the tables current bill total as a disabled option
  # Selection 2: Place new order: - > will launch the PlaceOrderMenu
  # Selection 3: Process Table - > will tabulate the tables receipt and print it to the screen.
  # Selection n + 3: ordered menu item 'n' - > Will launch the ViewMenuItemMenu
  # Selection n + 4: Back - > will return the user to the previous Menu
  def handle_selection(selection)
    return :break if selection == :break

    case selection
    when :new_order
      menu = PlaceOrderMenu.new(@table)
      menu.run
    when 'Tabulate'
      puts @table.tabulate(@bill_total)
      puts 'Press any character to continue: '
      input = STDIN.getch # this pauses the program so that the bill is viewable
      @table.orders = []
      @@breaks = 2
    else
      menu = ViewMenuItemMenu.new(@table, selection)
      menu.run

    end
    # This is to ensure it recalculates bill total after items have been added to the table orders
    @options = create_options
  end
end
