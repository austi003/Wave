require 'wav-file'
require 'pry'
require 'win32/sound' 
include Win32

# This file is hopefully reversing the wave file and playing it

file = open("bomb.wav")
format = WavFile::readFormat(file)
dataChunk = WavFile::readDataChunk(file)
file.close

puts format

Sound.play('bomb.wav')

wavs = dataChunk.data.unpack('c*')

dataChunk.data = wavs.reverse.pack('c*')

open("output.wav", "w"){|out|
  WavFile::write(out, format, [dataChunk])
}

Sound.play('output.wav')

