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


#this is how we can select things with xpath, aswell :)
temp = parse.css('.content').css('.row').xpath("//a[@class='hdrlnk']/@href")





#Printing out all data in orderly fashion :D
puts "\n\n\n"
puts "====================================================================================="
puts "----------------------Programming jobs available in your area! ----------------------"
puts "====================================================================================="

puts "\n\n\n"

(99).downto(0) do |i|

	puts
	puts "Title:              " + titles[i]
	puts "Posted:             " + times_posted[i]
	puts "Location:          " + locations[i]
	puts "Link to job:        " + "https://denver.craigslist.org" + link_targets[i]
	puts

end



# deugging tool 4 dev
#Pry.start(binding)


mobile_count = 0
engineer_count = 0
web_count = 0
jr_count = 0

titles.each do |title|
	mobile_found = title.scan("Mobile").length + title.scan("mobile").length
	engineer_found = title.scan("Engineer").length + title.scan("engineer").length
	web_found = title.scan("Web").length + title.scan("web").length
	jr_found = title.scan("Junior").length + title.scan("junior").length + title.scan("Jr").length + title.scan("jr").length


	mobile_count += mobile_found
	engineer_count += engineer_found
	web_count += web_found
	jr_count += jr_found

end


puts "\n\n-------------  Keyword Evaluation Found  -------------"
puts
puts "  #{mobile_count}  mobile related jobs available."
puts "  #{engineer_count}  engineering jobs available."
puts "  #{web_count}  web related jobs available."
puts "  #{jr_count}  junior positions available."
puts
puts "------------------------------------------------------\n\n"







## THE NEXT STEP IN THIS PROGRAM USES HREF LINKS TO SCRAPE ALL JOBS PAGES 
## FOR EVEN MORE INFO
#1). run keyword searches over all pages, and tell users how many times a language was mentioned
#2). could pull compensation, and employment type
#3). needs to return location info for data pulled

4.times do |i|

	job_page = HTTParty.get("https://denver.craigslist.org/#{link_targets[i]}")

	job_parse = Nokogiri::HTML(job_page)


	puts "-------------------------------------------------------------------------------"
	puts job_parse.css('.body').css('.postingtitle').css('#titletextonly').text
	puts "-------------------------------------------------------------------------------"
	puts 
	puts job_parse.css('.body').css('.userbody').css('#postingbody').text
	puts


	puts "\n\n\n\n"


end




