class Apartment <ActiveRecord::Base
  has_and_belongs_to_many(:users)
  
  def self.search_craigs(url, quadrant)
    apts = []
    html_data = open(url).read
    nokogiri_object = Nokogiri::HTML(html_data)
    result = nokogiri_object.xpath("//a[@class='result-title hdrlnk']/@href")
    result.each do |link|
      html_title = open(link).read
      nokogiri_object_title = Nokogiri::HTML(html_title)
      title = nokogiri_object_title.xpath("//span[@id='titletextonly']")
      br = nokogiri_object_title.xpath("//span[@class='shared-line-bubble'][1]/b[1]").children.text.to_i
      bathroom = nokogiri_object_title.xpath("//span[@class='shared-line-bubble'][1]/b[2]").children.text.to_i
      address_street = nokogiri_object_title.xpath("//div[@class='mapaddress']")
      sqft = (nokogiri_object_title.xpath("//span[2]/b")).text.to_i
      price = (nokogiri_object_title.xpath("//span[@class='price']")).text.gsub!('$','').to_i
      date_posted = (nokogiri_object_title.xpath("//time")).text.split(' ')[0]
      extras = []
      field1 = (nokogiri_object_title.xpath("//p[@class='attrgroup'][2]/span[1]")).text
      field2 = (nokogiri_object_title.xpath("//p[@class='attrgroup'][2]/span[2]")).text
      field3 = (nokogiri_object_title.xpath("//p[@class='attrgroup'][2]/span[3]")).text
      field4 = (nokogiri_object_title.xpath("//p[@class='attrgroup'][2]/span[4]")).text
      field5 = (nokogiri_object_title.xpath("//p[@class='attrgroup'][2]/span[5]")).text
      field6 = (nokogiri_object_title.xpath("//p[@class='attrgroup'][2]/span[6]")).text
      field7 = (nokogiri_object_title.xpath("//p[@class='attrgroup'][2]/span[7]")).text
      field8 = (nokogiri_object_title.xpath("//p[@class='attrgroup'][2]/span[8]")).text
      field9 = (nokogiri_object_title.xpath("//p[@class='attrgroup'][2]/span[9]")).text
      extras.push(field1, field2, field3, field4, field5, field6, field7, field8, field9)
      cat_ok = extras.any? { |x| x == 'cats are OK - purrr'}
      dog_ok = extras.any? { |x| x == 'dogs are OK - wooof'}
      washer_ok = extras.any? { |x| x == 'w/d in unit' || 'laundry in bldg'}
      smoking_ok = extras.any? { |x| x == 'no smoking'}
      garage_ok = extras.any? { |x| x == 'attached garage'}
      more_info = nokogiri_object_title.xpath("//section[@id='postingbody']")
      more_infos = []
      more_info.children.each do |info|
        (info.text).gsub("[\r\n]", '')
        if ((info.text).gsub("\n            QR Code Link to This Post\n            \n        ", '').length >=12)
        more_infos.push(info.text)
        end
      end
      apts.push(name: (title.text),url: (link.value),price: (price),bed: (br),bath: (bathroom),sqft: (sqft),address: (address_street.children.text),cat: (cat_ok),dog: (dog_ok),washer: (washer_ok),smoke: (smoking_ok),garage: (garage_ok),description: (more_infos),posted: (date_posted),section: (quadrant))
    end
    apts
  end
end
