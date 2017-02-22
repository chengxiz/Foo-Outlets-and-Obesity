#!/usr/bin/env python
# -*- coding: utf-8 -*-
from scrapy.spiders import Spider
from scrapy.selector import Selector
from scrapy.http import Request, FormRequest
from SUFFOLK.items import SuffolkItem
class LoginSpider(Spider):
    name = 'suffolkcounty'
    allowed_domains = [
		"http://apps.suffolkcountyny.gov"
	]
    start_urls = ['http://apps.suffolkcountyny.gov/health/Restaurant/Rest_Search.aspx']
    items=[]
  #   def start_requests(self):
		# yield [ Request("http://apps.suffolkcountyny.gov/health/Restaurant/Rest_Search.aspx", meta = {'cookiejar' : 1}, callback = self.parse)]  #添加了meta

    def parse(self, response):    	
    	# sel = Selector(response)
    	__EVENTVALIDATION=response.xpath('//form[@id="Form1"]/input[@name="__EVENTVALIDATION"]/@value').extract()[0].encode()
    	__VIEWSTATE=response.xpath('//form[@id="Form1"]/input[@name="__VIEWSTATE"]/@value').extract()[0].encode()
        __VIEWSTATEGENERATOR=response.xpath('//form[@id="Form1"]/input[@name="__VIEWSTATEGENERATOR"]/@value').extract()[0].encode()
        table=response.xpath('//form[@id="Form1"]/table/tr[3]//select[@name="ddl_Town"]/option')
        town_list=[]
        for i in table[1:]:
        	town_list.append([i.xpath('text()').extract()[0].encode(),i.xpath('@value').extract()[0].encode()])
    	print len(town_list)
    	# print town_list	
    	for j in range(len(town_list)):
    		print j
    		print town_list[j][1]
    		item=SuffolkItem()
	        request=FormRequest.from_response(
	            response, "http://apps.suffolkcountyny.gov/health/Restaurant/Rest_Search.aspx",
	            # meta = {'cookiejar' : response.meta['cookiejar']},
	            formdata={
	            '__VIEWSTATE': __VIEWSTATE, 
	            '__VIEWSTATEGENERATOR': __VIEWSTATEGENERATOR,
	            '__EVENTVALIDATION':__EVENTVALIDATION,
	            'ddl_Town':town_list[j][1],
	            'btnView_By_Town':'View+Establishment',
	            'txt_Rest_Name':'',
	            'ddl_Town2':'',
	            'txt_Rest_Name_2':''
	            },
	            callback=self.parse_town,
	            dont_filter = True
	        )
	        request.meta['item'] = town_list[j][0]
	        yield request
        # return
    def parse_town(self,response):
        items=[]
    	cityname=response.meta['item']
    	print "WTFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFf"+cityname
    	table_l=response.xpath("//table/tr/td[1]//a")
        # table=response.xpath("//table/tr/td[1]")
        table=response.xpath("//table[@id='Table1']/tr/td/table[@id='dgResults']")
        # print table.extract()
        row=table.xpath("tr")[2:]
        for i in row:
            item=SuffolkItem()        
            name=i.xpath("td[1]//a/text()").extract()[0].encode()
            print name
            item['Name']=name
            address=i.xpath("td[2]//span")
            print len(address)
            # print address
            item['Address']=i.xpath("td[2]//span[1]/text()").extract()[0].encode()
            # item['City']=i.xpath("td[2]//span[2]/text()").extract()[0].encode()
            item['City']=cityname
            item['State']="NY"
            item['ZipCode']=i.xpath("td[2]//span[4]/text()").extract()[0].encode()
            print item
            items.append(item)
        back = {'FoodService' : items}        
        return back
    