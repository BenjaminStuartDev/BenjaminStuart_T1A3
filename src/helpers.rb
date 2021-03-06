# frozen_string_literal: true

require_relative './errors'
require_relative './business'
require_relative './staff'
require 'io/console' #note that the gets in this method rewrites the gets in ruby. Hence all gets look like: STDIN.gets
require 'rainbow'

# returns the user input while handling input errors and input confirmation.
#
# @param data_name [String] A string containing the name of the data that is being requested.
# @param *validators [Proc] A validation proc containing raise errors and error messages to be displayed to the user.
#
# @return A string conaining the user input [String]
def get_user_input(data_name, *validators)
  print "Please enter your #{data_name}: "
  begin
    user_input = STDIN.gets.chomp
    validators.each do |validator|
      validator.call(user_input, data_name)
    end

    confirmation = get_confirmation("Is '#{user_input}' correct? (Y/N): ")

    raise InvalidInputError, "Please re-enter your #{data_name}: " unless confirmation == 'Y'
  rescue InvalidInputError => e
    print e.message
    retry
  end
  user_input
end

# Returns confirmation in the form of 'Y' or 'N' from user input.
#
# @param input [String] A string containing the confirmation message to be displayed to the user
#
# @return confirmation string 'Y' or 'N [String]
def get_confirmation(input)
  begin
    print input
    confirmation = STDIN.gets.chomp.upcase
    raise(InvalidInputError) unless %w[Y N].include?(confirmation)
  rescue InvalidInputError => _e
    puts "Invalid input '#{confirmation}'. Please try again."
    retry
  end
  confirmation
end

# Generates the login prompt and returns logged_in = true/false if username and password has a match
#
# @param business [Business] A Business object containing all information relevent to the business
#
# @return true or false [Boolean] if login was succesful or unsuccessful
# @return logged in user [Staff] if login was succesful
def login(business)
  logged_in = false
  puts Rainbow('Login Menu').blue
  login = TTY::Prompt.new
  username = login.ask('Please enter your username: ', required: true)
  password = login.mask('Please enter your password: ', required: true)
  login_attempt = Staff.new(username, password, false)
  user = nil
  business.staff.each do |staff_member|
    if staff_member == login_attempt
      logged_in = true
      user = staff_member
    end
  end
  if logged_in == false
    puts "#{Rainbow('Incorrect username or password. ').red}(Press any character to continue)"
    input = STDIN.getch
  else
    puts Rainbow('Username and password is correct').green
  end
  return logged_in, user
end

# clears the terminal
def clear_terminal
  system('clear')
  system('cls')
end
