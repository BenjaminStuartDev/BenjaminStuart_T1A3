# frozen_string_literal: true

require 'tty-prompt'
require './helpers'

# The Menu class represents the generic Menu prompt that is inherited by all Menu subclasses
class Menu
  # Sets the Menu class variables @@business that is used to access the business object by all Menu subclasses
  @@business = nil 
  # Sets the Menu class variable @@current_user to store the currently logged in user to access manager perms by Menu subclasses
  @@current_user = nil
  # Sets the number of times a menu should break for.
  @@breaks = 0
  # Initialises the tty prompt
  #
  # @param menu_name [String] A string containing the name of the menu to be displayed
  # @param options [Array] An array of hashes containing all option keys and their selection values to be displayed by ttp prompt
  def initialize(menu_name, options)
    @menu_name = Rainbow(menu_name).blue
    @options = options
    @prompt = TTY::Prompt.new
  end

  # the run method is used to begin the menu loop and will break out of the menu until @@breaks == 0
  def run
    loop do
      selection = @prompt.select(@menu_name, @options, cycle: true, filter: true, per_page: 10)
      break if handle_selection(selection) == :break

      clear_terminal
      @@business.save('./saves/savefile.json') # saves changed information after every loop
      if @@breaks.positive?
        @@breaks += -1
        break
      end
    end
  end

  # handle_selection is used to determine what to do based on the users menu selection.
  # the handle_selection raises a NotImplementedError if the handle_selection has not been overwritten by inheriting classes.
  def handle_selection(_selection)
    raise NotImplementedError, 'handle_selection must be implmenented'
  end

  # self.business= is used to set the class attribute @@business outside of the class.
  def self.business=(business)
    @@business = business
  end

  # self.current_user= is used to set the attribute @@current_user outside of the class.
  def self.current_user=(user)
    @@current_user = user
    puts Rainbow("Welcome #{@@current_user.name}!").white
  end
end
