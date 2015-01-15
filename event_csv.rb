require_relative 'clerk'

puts 'Enter the URL to be scraped'
url = gets.chomp

clerk = Clerk.new(url)

File.open('events.csv', 'w') { |file| file.write(clerk.build_csv) }
