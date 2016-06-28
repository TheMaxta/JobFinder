# JobFinder
Web Scraper pulls data from craigslist listings for your city. Scans through up to 100 listings,
and calculates the most in-demand programming languages for your city!

PURPOSE: 
  scrapes live data from job posting sites like craigslist. Manipulates data in a number of ways
to inform user on the current job market. Specifically searches for keywords like programming languages,
and tells user how many jobs are hiring for those languages. 

GEMS USED: nokogiri, pry(debugging), httparty for get requests, and json + csv gem for parsing and printing data to a excell doc.
 
HOW?: 
  run program through command line,  and it will automatically pull 100 live listings from craigslist. press enter,
  and program will then parse and load all 100 listings, and run calculations and evaluations over every post.
