
class Apartment <ActiveRecord::Base
  has_and_belongs_to_many(:users)




  def self.search_craigs
    parse_file = Nokogiri::HTML(open('https://portland.craigslist.org/search/apa?postedToday=1&min_price=1&min_bedrooms=1&minSqft=1&availabilityMode=0'))


    apartments = parse_file.xpath("//span[@class='result-meta']")
    title = parse_file.xpath("//p[@class='result-info']/a")

    rents = []
    title_counter = 0
    apartments.each do |x|
      apartment = x.text.gsub(/ /, '').gsub(/[\n]/, '').split("pic")[0].split('-')
      y = apartment[0].index('br')
      bed = apartment[0][y-1]
      apartment[0].gsub!("br", '')
      apartment[0].gsub!('$', '')
      apartment[0].chop!
      apartment[1].gsub!('ft2', '')

      apartment.push(bed)

      if apartment.length == 3
        apartment.insert(2, '')
      else
        apartment[2][0] = ""
        apartment[2].chop!
      end

      apartment[0] = apartment[0].to_i
      apartment[1] = apartment[1].to_i
      apartment[3] = apartment[3].to_i

      apartment.push(title[title_counter].text)
      rents.push(apartment)

      title_counter += 1
    end

    rents
  end

end
