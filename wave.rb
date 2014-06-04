require 'wav-file'
require 'pry'
require 'readline'
require 'win32/sound' 
include Win32

# prompt the user to see what they want to do

def input(prompt = "", newline=false)
  prompt += "\n" if newline
  Readline.readline(prompt, true).squeeze(" ").strip
end

option = input "What would you like to do? Press 1 to play normal,\n press 2 to play backwards, or press 3 to exit"

# If they select 1, loads the wave file, plays the sound, upacks the data and converts to integers, looks for largest value
# smallest value, and number of values above a test number
if option == '1'

file = open("bomb.wav")  #setting which file to open
format = WavFile::readFormat(file)
data = WavFile::readDataChunk(file).data   

Sound.play("bomb.wav")  #plays the actual wave file

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

p "The Largest Value is #{@largest_value}"   #displays largest value, smallest value, and result of counter to screen
p "The Smallest Value is #{@smallest_value}"
p "#{counter} instances are greater than #{test}" 
 
elsif   # if they select option 2, it plays the file in reverse instead
   
   option == '2'    
    
file = open("bomb.wav")
format = WavFile::readFormat(file)
dataChunk = WavFile::readDataChunk(file)
file.close
wavs = dataChunk.data.unpack('c*')

dataChunk.data = wavs.reverse.pack('c*')

open("output.wav", "w"){|out|
  WavFile::write(out, format, [dataChunk])
}

Sound.play('output.wav')

elsif  #if they select exit, they get a friendly little message
  
  option == '3'
    p "Thank you for playing!"
  
else   #if they select any other characters, it gives them an error
  p "I don't think you entered a valid selection"
end







