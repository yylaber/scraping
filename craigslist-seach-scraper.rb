# scrapes all craigslist posting headers, time of post,location,
require 'open-uri'
require 'nokogiri'

# document = open('https://newyork.craigslist.org/search/jjj?query=html+css+javascript')
document = open('https://newyork.craigslist.org/search/jjj?query=html+css')
content = document.read
parsed_content = Nokogiri::HTML(content)

n = 0
parsed_content.css('.content').css('.result-row').each do |row|
    title = row.css('.hdrlnk').first.inner_text
    link = row.css('.hdrlnk').first.attributes['href'].value
    posted_at = row.css('time').first.attributes['datetime'].value
    neighb_elem = row.css('span .result-hood').inner_text.strip
    if neighb_elem
        neighberhood = neighb_elem
        else
        neighberhood = ''
    end
    
    # if  statment only if they offer an internship or entry level
    if title.include?('design') || title.include?('entry level') || title.include?('internship') || title.include?('designer') || title.include?('Design')
        n += 1
        puts %Q(
                Result #{n}:
                #{title} #{neighberhood}
                Posted at: #{posted_at}
                ---------------------------)
    end
end


# # scrapes all craigslist posting headers, time of post,location,
# require 'open-uri'
# require 'nokogiri'
#
# document = open('https://newyork.craigslist.org/search/jjj?query=html+css+javascript')
# content = document.read
# parsed_content = Nokogiri::HTML(content)
# # we are returning an array of various attrubutes ('attrubutes' may be an incorrect termenoligy) of the (first title) html
# # parsed_content.css('.content').css('.rows').css('.hdrlnk').first.class.instance_methods.sort
#
# # returns the first title
# # parsed_content.css('.content').css('.rows').css('.hdrlnk').first.inner_text
#
# # returns all page titles UNORGENIZED
# parsed_content.css('.content').css('.result-row').each_with_index do |row, i|
#
#   title = row.css('.hdrlnk').first.inner_text
#   link = row.css('.hdrlnk').first.attributes['href'].value
#   posted_at = row.css('time').first.attributes['datetime'].value
#   neighb_elem = row.css('span .result-hood').inner_text.strip
#
#   if neighb_elem
#     neighberhood = neighb_elem
#   else
#     neighberhood = ''
#   end
#
# # if  statment only if they offer an internship or entry level
#   puts "#{i+1}"
#   puts "#{title} #{neighberhood}" #if title.include?('internship') || title.include?('entry level') || title.include?('paid internship')
#   # puts '-'
#   puts "Posted at: #{posted_at}"
#   # uncomment to add link
#   # puts '-'
#   # puts "At link: #{link}"
#
#   puts '---------------------------------'
# end





