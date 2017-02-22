# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html
import csv

class SuffolkPipeline(object):
	def __init__(self):
		self.file = open('sufflok.csv', 'wb')
	def process_item(self, item, spider):
		fieldnames = ['Name','Address','City','State','ZipCode']
		writer = csv.DictWriter(self.file,fieldnames=fieldnames)
		# writer.writeheader()
		writer.writerows(item['FoodService'])