# -*- coding: utf-8 -*-

from scrapy.spiders import Spider
from scrapy.selector import Selector
from scrapy.http import Request
from re import split

from ERIE.items import ErieItem


class ErieSpider(Spider):
	name = "ERIECOUNTY"
	allowed_domains = [
		"www.healthspace.com"
	]
	start_urls = [
		'http://www.healthspace.com/Clients/NewYork/Erie/Erie_Live_Web.nsf/Food-CityList?OpenView&Count=999&'
	]

	def parse(self,response):
		print "Let's begin"
		print str(self)
		pre_url="http://www.healthspace.com"
		sel = Selector(response)
		City_List=sel.xpath('//body[@class="CityList"]')
		# FS_Name
		for i in range(4,82):			
			index='a['+str(i)+']'
			City=City_List.xpath(index)
			City_Name=(City.xpath('text()').extract()[0]).encode()
			City_Url=pre_url+(City.xpath('@href').extract()[0]).encode()
			City_Url=City_Url.replace("Count=35","Count=3500")
			print(City_Name)
			# print(City_Url)
			yield Request(City_Url,callback=self.parse_citylevel)

	def parse_citylevel(self,response):
		items=[]
		sel = Selector(response)
		foodservice=sel.xpath('//table/tr')
		print(len(foodservice[1:]))
		for i in foodservice[1:]:
			item = ErieItem()
			FS_Name=i.xpath('td[1]/a/text()')
			FS_Facility_Location=i.xpath('td[2]/text()')
			FS_City=i.xpath('td[3]/text()')

			pre_url="http://www.healthspace.com"
			FS_Type_Link=pre_url+(i.xpath('td[1]/a/@href').extract()[0]).encode()

			# print(FS_Name.extract()[0].encode('utf8'))
			# print(FS_Facility_Location.extract()[0].encode('utf8').strip())
			# print(FS_City.extract()[0].encode('utf8').strip())


			item['Name'] = FS_Name.extract()[0].encode('utf8')
			item['Facility_Location'] = FS_Facility_Location.extract()[0].encode('utf8')[2:]
			item['City'] = FS_City.extract()[0].encode('utf8')[2:]
			# print (FS_Type_Link)
			# request.meta['item'] = item
			# item['Facility_Type'] = 
			items.append(item)
		back = {'FoodService' : items}
		return back
		# print(foodservice.extract())
	# def parse_citylevel(self,response):
	# 	# sel = Selector(response)
	# 	# foodservice=sel.xpath('//table/tr[1]/td[2]/text()')
	# 	item = response.meta['item']
	# 	item['Facility_Type'] = "WTF"# print(foodservice.extract()[0].encode('utf8'))
	# 	return item
