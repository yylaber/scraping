# searches multiple searches
require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'csv'
require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'

# setup mechanize
agent = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

# setup page
#document = open('https://www.amazon.com/Best-Sellers-Cell-Phones-Accessories-Unlocked/zgbs/wireless/2407749011/')
document = open('https://www.amazon.com/Best-Sellers-Cell-Phones-Accessories-Unlocked/zgbs/wireless/2407749011/ref=zg_bs_pg_2?_encoding=UTF8&pg=2')
# saves all content of the page
content = document.read

#grabs the 50 products on the page by selecting the ol and the li children class (.zg-item-immersion)
amazon_top_50 = Nokogiri::HTML(content).css('ol > .zg-item-immersion')

# map the relevent product info
one = {'product_num' => amazon_top_50.css('.zg-badge-text').map{|x| x.inner_text[1..-1].to_i}}
two = {'title' => amazon_top_50.css('span > div > span > a > div').map{|x| x.inner_text.strip}}
three = {'num_of_ratings' => amazon_top_50.css('span span .a-size-small').map{|x| x.inner_text.delete(',').to_i}}
four = {'price' => amazon_top_50.css('.p13n-sc-price').map{|x| x.inner_text[1..-1].to_f}}
five = {'rating' => amazon_top_50.css('.a-link-normal').css('.a-icon-alt').map{|x| x.inner_text[0..2].to_f}}


# put title in csv
CSV.open('amazon-data.csv', 'w+') do |csv|
    csv << [one.keys[0], two.keys[0], three.keys[0], four.keys[0], five.keys[0]]
    csv << ['']
end
 i = 0
while i < amazon_top_50.length-1

#   if rating > n,             and num of ratings > n,                 and price > n
    if five[five.keys[0]][i] > 4.2 && three[three.keys[0]][i] > 200 && four[four.keys[0]][i] < 500
         delay_time = rand(10)#60 is prob better
           sleep(delay_time)
         puts ''
         puts "PRODUCT NUMBER: #{one[one.keys[0]][i]}"
         puts "PRICE IS: #{two[two.keys[0]][i]}"
         puts "RATING: #{three[three.keys[0]][i]}"
         puts "NUMBER OF RATINGS: #{four[four.keys[0]][i]}"
         puts "TITLE: #{five[five.keys[0]][i]}"
         puts '----------------------------------------------'
         
         #place resuts into csv
         CSV.open('amazon-data.csv', 'a') do |csv|
             csv << [
                     one[one.keys[0]][i], two[two.keys[0]][i], three[three.keys[0]][i], four[four.keys[0]][i], five[five.keys[0]][i]
                     ]
         end
     end
     i += 1
end









#puts parsed_content.scan('\d\.\d out of 5 stars')
#puts page = agent.get('https://www.amazon.com/Best-Sellers-Cell-Phones-Accessories-Unlocked/zgbs/wireless/2407749011/')
#puts results = Nokogiri::HTML(page.body)
#puts one_result = results.at_css('.zg-item-immersion').at_css('.a-icon-alt').first.text


#search_terms.each do |term|
#  search_form.search = term
#  results = agent.submit(search_form, search_form.button('go'))
#  html_results = Nokogiri::HTML(results.body)
#
#  name = html_results.at_css('#firstHeading').text
#  bday = html_results.at_css('.bday').text
#
#  puts "#{name} was born on #{bday}"
#  CSV.open('life-data.csv', 'a+') do |csv|
#    csv << [name, bday]
#  end
#  delay_time = rand(5)#60 is prob better
#  sleep(delay_time)
#  Spreadsheet.open('sheet.xls', 'a+') do |spreadsheet|
#    spreadsheet << [name, bday]
#  end
#  # delay_time = rand(5)#60 is prob better
#  sleep(delay_time)
#end
