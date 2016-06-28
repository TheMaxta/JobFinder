require 'HTTParty'		#sends request to page
require 'Nokogiri'		#places xml info into ruby object
require 'JSON'			
require 'Pry'			#debugging gem	
require 'csv'

page = HTTParty.get('https://denver.craigslist.org/search/jjj?excats=12-1-2-1-7-1-1-1-1-1-19-1-1-3-2-1-2-2-2-14-25-25-1-1-1-1-1-1')

#pass html string to nokogiri ruby object
parse = Nokogiri::HTML(page)

#array for storing job post data
titles = []
times_posted = []
locations = []
link_targets = []



#select specific css inside of nokogiri object.
parse.css('.content').css('.row').map do |tag|


	post_title = tag.css('.hdrlnk').text	
	titles << post_title


	post_date = tag.css('time').text
	times_posted << post_date

	post_location = tag.css('.pnr').css('small').text
	locations << post_location

	post_link = tag.css('.hdrlnk').attribute('href')
	link_targets << post_link

end



temp = parse.css('.content').css('.row').xpath("//a[@class='hdrlnk']/@href")


Pry.start(binding)

puts "\n\n\n"
puts "====================================================================================="
puts "----------------------Programming jobs available in your area! ----------------------"
puts "====================================================================================="

puts "\n\n\n"

100.time do |i|

	puts
	puts "Title: " + titles[i]
	puts "Posted: " + times_posted[i]
	puts "Location: " + locations[i]
	puts "link to job: " + link_targets[i]
	puts

end


puts titles[0]
puts times_posted[0]
puts locations[0]
puts link_targets[0]



