require 'HTTParty'		#sends request to page
require 'Nokogiri'		#places xml info into ruby object
require 'JSON'			
require 'Pry'			#debugging gem	
require 'csv'



#this requests a craigslist page for, pets for scraping
page = HTTParty.get('https://newyork.craigslist.org/search/pet?s=0')

#pass html string into nokogiri, this makes it a ruby object
parse_page = Nokogiri::HTML(page)

#array for storing pets
pets_array = []


#this is how we parse only headline data
parse_page.css('.content').css('.row').css('.hdrlnk').map do |a|
		post_name = a.text
		pets_array.push(post_name)
end


#push all data pets listing into a excell / csv file.
CSV.open('pets.csv','w') do |csv|
	csv << pets_array
end





Pry.start(binding)