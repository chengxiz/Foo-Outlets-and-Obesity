import csv
import geocoder
fp=open('Geocoded_Retail_Food_Stores.csv','rb')
reader=csv.reader(fp)
rawdata=[]
for item in reader:
	rawdata.append(item)
LocationList=[]
ProblemList=[]
UnCtgList=[]
UnGCList=[]
List1=[]# for confidence==9 while different zipcode or city by searching name
List2=[]# for confidence==9 while different zipcode or city by searching address
J=0
with open('Geocoded_Google.csv', 'w') as fp:
	a = csv.writer(fp, delimiter=',')	
	a.writerow(rawdata[0]+['Geocoded_CITY','Geocoded_POSTAL','Geocoded_LON','Geocoded_LAT'])
	for item in rawdata[1:]:
		Address=item[6]+' '+item[7].strip()+','+item[10].strip()+','+item[11].strip()
		J=J+1
		print Address
		g=geocoder.google(Address)
		print type(item)
		a.writerow(item+[g.city,g.postal,g.latlng[0],g.latlng[-1]])
		if J==1:
			break
	