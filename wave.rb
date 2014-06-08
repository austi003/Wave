require 'wav-file'   #https://github.com/shokai/ruby-wav-file
require 'pry'
require 'readline'
require 'find'
require 'win32/sound' 
include Win32

@user_choice = 0  #declare a variable to start my while loop
@file_to_play = "nil"

# define a method to prompt the user for a few options
def user_input(prompt = "", newline=false)
  prompt += "\n" if newline
  Readline.readline(prompt, true).squeeze(" ").strip
end

# define a method to list available wav files to be played
def file_choices 
  puts "You have the following file choices:"
  list_of_files = Dir["*.wav"]
  puts "   #{list_of_files}"
  @file_to_play = user_input "\nWhich file would you like to play?\n"
end 

#define a method to display options to the user of how they want to play the file
def provide_user_option 
  @user_choice = user_input "\nWhat would you like to do?\nPress 1 to pick a file and play normally\nPress 2 to play file in reverse\nPress 3 if you'd like to exit\n"
end

#explains to the user what happens in this file
puts "\nThis program allows you to select wave files to play. You can play them normally or in reverse.\n\n"

#begin program with first user prompt
provide_user_option  

#begin while loop to start program based on user's first choice

while @user_choice != '3' do

# If they select 1, loads the wave file, plays the sound, upacks the data and converts to integers, looks for largest value
# smallest value, and number of values above a test number
if @user_choice == '1'

file_choices
file = open(@file_to_play)  #setting which file to open
format = WavFile::readFormat(file)
data = WavFile::readDataChunk(file).data   

Sound.play(@file_to_play)  #plays the actual wave file

array = data.unpack('s*') #reads the Datachunk & converts into readable format

@largest_value = 0    #declaring baseline values to compare against
@smallest_value = 0
counter = 0           #my counter to increment against for values above my test variable
test = 22000          #my variable to count number of values above

array.each do |entry|       #iterates thorugh all values within my wave file to test for larguest & smallest values
  number = entry
  
  if @largest_value <= number 
    @largest_value = number
  end
  
  if @smallest_value >= number
    @smallest_value = number
  end
  
  if @largest_value >= test
    counter += 1
  end
  
end

puts "\nThe Largest Value is #{@largest_value}"   #displays largest value, smallest value, and result of counter to screen
puts "The Smallest Value is #{@smallest_value}"
puts "#{counter} instances are greater than #{test}\n\n" 

provide_user_option
 
elsif   # if they select option 2, it plays the file in reverse instead
   @user_choice == '2'    

file_choices    
file = open(@file_to_play)
format = WavFile::readFormat(file)
dataChunk = WavFile::readDataChunk(file)
file.close
wavs = dataChunk.data.unpack('c*')

dataChunk.data = wavs.reverse.pack('c*')

open("c:/Users/shaustin/dev/wave/reverse/output.wav", "w"){|out|
  WavFile::write(out, format, [dataChunk])
}

Sound.play('c:/Users/shaustin/dev/wave/reverse/output.wav')

provide_user_option

else
  puts "That is not a valid selection. Please try again."
  provide_user_option
end

end

puts "Thank you for playing!"




