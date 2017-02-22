import csv
import geocoder

fp=open('suffolk.csv','rb')
reader=csv.reader(fp)
Weightdata=[]
for row in reader:
  Weightdata.append(row)
# j=0
with open('suffolk_geocoding3.csv', 'w') as fp:	
	a = csv.writer(fp, delimiter=',')	
	a.writerow([
	'FACILITY','ADDRESS','COUNTY','CITY',
	'ZIP.CODE','LONGITUDE','LATITUDE'])
	for Service in Weightdata[4995:]:
		Address=Service[1]+','+Service[2]+','+'NY'
		print Address
		g=geocoder.google(Address,key='AIzaSyDezpHYMhzU6VLRMuniZa1V6_ZExzGwC8k')
		# print g.json
		a.writerow([Service[0],Service[1],"SUFFOLK",Service[2],Service[4],g.lng,g.lat])
		# j=j+1
		# if j==2:
		# 	break	
