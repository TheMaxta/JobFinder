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



## naming vars to increment when a keyword is matched.
mobile_count = 0
engineer_count = 0
web_count = 0
jr_count = 0

#loops over listing titles. Searches for keywords and increments a counter
#when a match is found.
titles.each do |title|
	mobile_found = title.scan("Mobile").length + title.scan("mobile").length
	engineer_found = title.scan("Engineer").length + title.scan("engineer").length
	web_found = title.scan("Web").length + title.scan("web").length
	jr_found = title.scan("Junior").length + title.scan("junior").length + title.scan("Jr").length + title.scan("jr").length

	#inc counters
	mobile_count += mobile_found
	engineer_count += engineer_found
	web_count += web_found
	jr_count += jr_found

end

#display all data to console
puts "\n\n-------------  Keyword Evaluation Found  -------------"
puts
puts "  #{mobile_count}  mobile related jobs available."
puts "  #{engineer_count}  engineering jobs available."
puts "  #{web_count}  web related jobs available."
puts "  #{jr_count}  junior positions available."
puts
puts "------------------------------------------------------\n\n\n"
puts "\n\n\nPress Enter To Run Advanced Analytics Over Every Post"

#pauses program
user_response = gets.chomp





## THE NEXT STEP IN THIS PROGRAM USES HREF LINKS TO SCRAPE ALL JOBS PAGES 
## FOR EVEN MORE INFO
#1). run keyword searches over all pages, and tell users how many times a language was mentioned
#2). could pull compensation, and employment type
#3). needs to return location info for data pulled



#contains all keywords our scan loop found in all listings total
global_temp_array = []

temp = 0
40.times do |i|

	job_page = HTTParty.get("https://denver.craigslist.org/#{link_targets[i]}")
	job_parse = Nokogiri::HTML(job_page)


	## SET VARS, AND SCRAPING INSTUCTIONS FOR JOB LISTINGS
	job_title = job_parse.css('.body').css('.postingtitle').css('#titletextonly').text
	job_body_content = job_parse.css('.body').css('.userbody').css('#postingbody').text
	job_compensation = 0 #later
	job_hours = 0 #later



	# SCAN FOR SPECIFIC MENTIONS IN JOB LISTING
	keywords = %w[php Php PHP ruby Ruby rails Rails c++ C++ html, Html HTML XML xml css Css CSS sql Sql
				 SQL javascript Javascript JavaScript java Java json Json JSON c# C# Knockout.js node.js 
				 Node.js jquery jQuery bootstrap Bootstrap python Python iOS ios IOS Ios Swift swift SWIFT
				  perl Perl PERL .net .Net .NET VisualBasic VB vb Vb objective-c Objective-C OBJECTIVE-C ]




	#contains all keyword mentions in this specific listing
	temp_array = []

	#loops through every word in keywords and scans the listing content for those words
	keywords.each do |word|
		found = job_body_content.scan(word).length


		#if a keyword hits a mach, push it into an array! 
		if found > 0
		temp += found


		#temp array applies only to current listing. Does not remove duplicate matches.
		temp_array << job_body_content.scan(word)

		#global array applies to all listing iterated over. uniq method removes duplicate matches. 
		global_temp_array << job_body_content.scan(word).uniq
		end
	end 




	#temp is just a counter for found keywords
	puts "\n\n\n"
	puts "================================================="
	puts temp
	puts "================================================="
	puts "================================================="
	puts "================================================="
	puts temp_array #testing purposes
	puts "================================================="
	puts "================================================="
	puts "================================================="
	puts "\n\n\n"



	# DISPLAY ALL DATA BY FORMAT
	puts "-------------------------------------------------------------------------------"
	puts job_title
	puts "-------------------------------------------------------------------------------"
	puts 
	puts job_body_content
	puts

	puts "\n\n\n\n"


end


puts "\n\n\n\n"

#temp is the num of matches made. TOTAL.
puts temp
puts "\n\n"

#diplay languages mentioned by employers. 
puts global_temp_array.sort



#USE THIS METHOD TO PRINT EVERY LANGUAGE
puts css_mentions = global_temp_array.join.scan('CSS').length
puts html_mentions = global_temp_array.join.scan('HTML').length



#Pry.start(binding)
