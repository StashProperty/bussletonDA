require 'scraperwiki'
require 'mechanize'
require 'date'

base_url = 'https://yoursay.busselton.wa.gov.au/development-applications'
info_url = 'https://yoursay.busselton.wa.gov.au/'


agent = Mechanize.new

page = agent.get(base_url)

DA_set = page.search('li.shared-content-block')

DA_set.each do |row|
	record = {}
	title = row.at('h2.title').text.split(" : ")
	record['council_reference'] = title[0].strip()
	record['info_url'] = info_url + title[0].strip()
	record['description'] = title[1].strip()
	record['date_scraped'] = Date.today.to_s
	record['date_received'] = row.at("span.timestamp").text.strip()
	record['address'] = row.at("p:contains('PROPERTY')").text.split("PROPOSED")[0].split("PROPERTY: ")[1]
	puts "Saving " + title[0].strip()
	ScraperWiki.save_sqlite(['council_reference'], record)
end