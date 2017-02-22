# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html

import csv

class CsvWriterPipeline(object):
	def __init__(self):
		self.file = open('Erie.csv', 'wb')
	def process_item(self, item, spider):
		fieldnames = ['Name','Facility_Location','City']
		writer = csv.DictWriter(self.file,fieldnames=fieldnames)
		# writer.writeheader()
		writer.writerows(item['FoodService'])
        # return item
