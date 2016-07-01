require 'HTTParty'		#sends request to page
require 'Nokogiri'		#places xml info into ruby object
require 'JSON'			
require 'Pry'			#debugging gem	
require 'csv'


#https://geo.craigslist.org/iso/us 
cities = %w[ denver abilene akroncanton albanyga albany albuquerque altoona amarillo ames anchorage annapolis 
	annarbor appleton asheville ashtabula athensga athensohio atlanta auburn augusta austin bakersfield baltimore
	 batonrouge battlecreek beaumont bellingham bemidji bend sandiego sanantonio newyork seattle chicago 
	 orangecounty losangeles louisville ]


#for looping and pulling data from all cities to evaluate trends	 
big_cities = %w[ denver sandiego sanantonio newyork seattle chicago orangecounty losangeles louisville ]

puts "City Examples: \n\n"
puts big_cities

puts "\n\n\nvisit https://geo.craigslist.org/iso/us for all cities"
puts "press enter to update all big cities. Will take a long time.\n\n\n"

gets.chomp

#Need to check for valid cities
	temp_val = 0
	cities.each do |key|
		if city == key
			temp_val = 1
		else
			#do nothing
		end

	end

	if temp_val == 1 
		#continue
	else
		puts "\n\n\nNon-valid entry. Exiting program\n\n"
		exit
	end






								## plug city in uri
page = HTTParty.get("https://#{city}.craigslist.org/search/jjj?excats=12-1-2-1-7-1-1-1-1-1-19-1-1-3-2-1-2-2-2-14-25-25-1-1-1-1-1-1")

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


(titles.length-1).downto(0) do |i|

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
sr_count = 0

#loops over listing titles. Searches for keywords and increments a counter
#when a match is found.
titles.each do |title|
	mobile_found = title.scan("Mobile").length + title.scan("mobile").length
	engineer_found = title.scan("Engineer").length + title.scan("engineer").length
	web_found = title.scan("Web").length + title.scan("web").length
	jr_found = title.scan("Junior").length + title.scan("junior").length + title.scan("Jr").length + title.scan("jr").length
	sr_found = title.scan("Senior").length + title.scan("senior").length + title.scan("Sr").length + title.scan("sr").length


	#inc counters
	mobile_count += mobile_found
	engineer_count += engineer_found
	web_count += web_found
	jr_count += jr_found
	sr_count += sr_found
end

#display all data to console
puts "\n\n-------------  Keyword Evaluation Found  -------------"
puts
puts "  #{mobile_count}  mobile related jobs available."
puts "  #{engineer_count}  engineering jobs available."
puts "  #{web_count}  web related jobs available."
puts "  #{jr_count}  junior positions available."
puts "  #{sr_count}  senior positions available."
puts
puts
puts "------------------------------------------------------\n\n"
puts "      from the #{titles.length} jobs evaluated.      \n\n"
puts "\n\nPress Enter To Run Advanced Analytics Over Every Post"

#pauses program
user_response = gets.chomp
puts
puts "How many posts should we run?   ---   (MAX: 100)"
puts
post_count = gets.chomp.to_i	#sets loop to user specification
puts
puts




## THE NEXT STEP IN THIS PROGRAM USES HREF LINKS TO SCRAPE ALL JOBS PAGES 
## FOR EVEN MORE INFO
#1). run keyword searches over all pages, and tell users how many times a language was mentioned
#2). could pull compensation, and employment type
#3). needs to return location info for data pulled



#contains all keywords our scan loop found in all listings total
global_temp_array = []

temp = 0
post_count.times do |i|

	job_page = HTTParty.get("https://#{city}.craigslist.org/#{link_targets[i]}")
	job_parse = Nokogiri::HTML(job_page)


	## SET VARS, AND SCRAPING INSTUCTIONS FOR JO BLISTINGS
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


#ARRAY FOR STORING A NUMBER OF KEYWORD MATCHES
mention_counts = []

languages = %w[CSS HTML JavaScript jQuery Bootstrap SQL PHP Python Java Ruby Rails C# Swift C++ .NET]

languages.each do |term|

	mention_counts << global_temp_array.join.scan(term).length


end

	puts mention_counts


puts

(mention_counts.length).times do |z|


	puts "#{mention_counts[z]} listings mentioned a proficiency in #{languages[z]}."
	puts "That's #{(mention_counts[z].to_f / post_count.to_f * 100).to_i}% of the jobs found.\n\n"


	end
	puts "\n\njava and javascript may be inaccurate!!"

#Now, we want to display the top 5 in-demand languages. from 1 to 5



#puts "Top 5 Languages Found:"
#This doesn't work. 









#Pry.start(binding)
