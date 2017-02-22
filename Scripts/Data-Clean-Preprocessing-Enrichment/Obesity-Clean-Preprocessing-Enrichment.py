import csv
import re
import os.path
fp=open('Student_Weight_Status_Category_Reporting_Results__Beginning_2010.csv','rb')
reader=csv.reader(fp)
data=[]
for row in reader:
  data.append(row)
subset1=data[1:1036]
subset2=zip(*subset1)
a=subset2[-1]
subsetEdit=[]
for i in range(len(subset1)):
	b=re.split('\n',a[i])
	subsetEdit.append(b[-1])
subset2[-1]=subsetEdit
data_12_13=zip(*subset2)
data_10_12=data[1037:]
data[0].append('LATITUDE')
data[0].append('LONGITUDE')
title=data[0]
def Pct_to_Float(data):
	data_float=[]
	print len(data)
	for i in data:		
		j=re.sub('%','',i)
		try:
			data_float.append(float(j))
		except ValueError:			
			print 'Pct data missing'
			data_float.append('')
	print data_float
	return data_float
def Lon_Lat_Extract(data,title):
	l=len(data)
	data=zip(*data)
	data_lat=[]
	data_lon=[]
	for item in data[-1]:
		i1=re.sub('\(','',str(item))
		i2=re.sub('\)','',str(i1))
		try:
			[lat,lon]=re.split(',\s',i2)
			data_lat.append(float(lat))
			data_lon.append(float(lon))
		except ValueError:
			print 'data missing'
			data_lat.append('')
			data_lon.append('')	
	print type(data[6])
	print len(data[6])
	data[6]=tuple(Pct_to_Float(data[6]))
	data[8]=tuple(Pct_to_Float(data[8]))
	data[10]=tuple(Pct_to_Float(data[10]))	
	data.append(data_lat)
	data.append(data_lon)
	print len(data)
	data_pro=zip(*data)
	data_pro.insert(0,title)
	return data_pro
data_12_13=Lon_Lat_Extract(data_12_13,title)
data_10_12=Lon_Lat_Extract(data_10_12,title)
with open('12_13_Student_Weight_Status_Category.csv','wb') as fp:
	a=csv.writer(fp)
	a.writerows(data_12_13)
with open('10_12_Student_Weight_Status_Category.csv','wb') as fp:
	a=csv.writer(fp)
	a.writerows(data_10_12)