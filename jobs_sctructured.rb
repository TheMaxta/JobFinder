
class CreateUriObject
	attr_accessor, 
	def initialize(protocol, host, city, search)
		@protocol = protocol
		@host = host
		@city = city
		@category = category
	end

	def plugInVars
		@page = HTTParty.get("#{protocol}#{city}.#{host}#{@search}")
		#page = HTTParty.get("https://#{city}.craigslist.org/search/jjj?excats=12-1-2-1-1")

		@parsed = Nokogiri::HTML(@page)

		return(@parsed)
	end

end

class ProgramController
	def welcome
		puts "\n\n============================================================\n\n"
		puts "Welcome to the Job Finder!!"
		puts "Coded by: Max Mahlke."
		puts "\n\n============================================================\n\n"

		puts "Press Enter To Commence Jobifying!!"

		set_uri()

	end

	def set_uri
		
		instance1 = Settings.new
		@protocol = 'https://www.'
		@host = instance1.set_host(@websites)
		@city = instance1.set_city(@cities)
		@search = instance1.set_search(@searches) ## what categories?
		UriInstance = CreateUriObject.new(@protocol, @host, @city, @search)
		@parsedPage = UriInstance.plugInVars
		@keywords = set_keywords(@parsedPage) #pass on controll to next method

	end

	def set_keywords
		puts "\n\nWhat kind of keywords would you like the program to scan for?\n"
		puts "Type 1 for preset keywords.\n\n"
		respone = gets.chomp
		if response == 1

				@keywords = %w[php Php PHP ruby Ruby rails Rails c++ C++ html, Html HTML XML xml css Css CSS sql Sql
				 SQL javascript Javascript JavaScript java Java json Json JSON c# C# Knockout.js node.js 
				 Node.js jquery jQuery bootstrap Bootstrap python Python iOS ios IOS Ios Swift swift SWIFT
				  perl Perl PERL .net .Net .NET VisualBasic VB vb Vb objective-c Objective-C OBJECTIVE-C ]
				  set_pages_to_load(@keywords)
		end

		puts "Please Enter 5 Keywords.\n"

		@keywords = []
		5.times do |i|
		    puts "keyword#{i}:    "
			temp = gets.chomp
		    @keywords << temp
		end

		@keywordsCap = createCapitalizedWords(@keywords)
		@keywordsUp = createUpcaseWords(@keywords)
		set_pages_to_load(@keywords)


	end

	def set_posts_to_load

		puts "\n\nHow many Pages do you want parsed and scanned? (max: 100)\n\n"

		response = gets.chomp

		return (resonse)

	end


	def 


	def createCapitalizedWords(words)
		words.each do |word|

			word.capitalize!

		end

		return words
	end

	def createUpcasedWords(words)
		words.each do |word|

			word.upcase!
			
		end

		return words
	end



	def listofcities
		@cities = %w[ denver sandiego sanantonio newyork seattle chicago orangecounty losangeles louisville ]
	end

	def listofwebsites
		@websites = %w[Craigslist.org Indeed.com Monster.com ]
	end

	def listofsearches
		@searches = %w[ /search/jjj?excats=12-1-2-1-7-1-1-1-1-1-19-1-1-3-2-1-2-2-2-14-25-25-1-1-1-1-1-1 ]
		#only contains one list currently. search sets to programming jobs... list[0]
	end

	class CreateUriObject
		attr_accessor, 
		def initialize(protocol, host, city, search)
			@protocol = protocol
			@host = host
			@city = city
			@category = category
		end

		def plugInVars
			@page = HTTParty.get("#{protocol}#{city}.#{host}#{@search}")
			#page = HTTParty.get("https://#{city}.craigslist.org/search/jjj?excats=12-1-2-1-1")

			@parsed = Nokogiri::HTML(@page)

			return(@parsed)
		end

	end
	
	class Settings



		def set_host(list)
	
			printList(list) ## doesn't return anything. just puts command.

			puts "These are websites we currently support. Please choose one."

			response = gets.chomp
			
			validate = checkResponse(response, list)
			
			if validate == true
				puts "Correct selection!"
				return (response) ## returns the user's choice of a host.
				#return to caller
			else
				puts "Wrong! We do not support that website!"
				set_host(list)	##recursively call, and pass list again.
			end


		end

		#cities array contains list of all cities we can run
		def set_city(list) #pass list of available cities

			printList(list) #no return, just output

			puts "\n\nVisit https://geo.craigslist.org/iso/us for more cities."

			puts "\n\nPlease enter your city, as it appears on craigslist.."

			response = gets.chomp
			
			validate = checkResponse(response, list)

			if validate == true
				puts "Correct selection!"
				return (response) ## returns the user's choice of city.
				#return to caller
			else
				puts "Wrong! We do not support that website!"
				set_city(list)	##recursively call, and pass list again.
			end

			
		end


		def set_search(list)
			printList(list)
			puts "Please Select your choice of jobs to search for."

			response = list[0] ## Not Settup yet!! 

			validate = checkResponse(response, list)

			if validate == true
				puts "Okay, good selection!"
				return (response)
			else
				puts "That option does not exist anywhere.. "
			end

		end


		def city_list

		end

		def checkResponse(checkThis, againstThis)
			againstThis.each do |against|

				if checkThis == against
					puts "Return True"
					true
				else
					puts "Return False"
					false
				end
		end ## end checkResponse method

		def printList(array)
			int = 1
			list.each do |i| 
				puts "#{int}).   #{i}"
				int += 1
			end
		end


	end ## end settings class


end ## end of program controller
