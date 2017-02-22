import csv
import geocoder

fp=open('erie.csv','rb')
reader=csv.reader(fp)
Weightdata=[]
for row in reader:
  Weightdata.append(row)
# j=0
with open('erie_geocoding2.csv', 'w') as fp:	
	a = csv.writer(fp, delimiter=',')	
	a.writerow([
	'FACILITY','ADDRESS','COUNTY','CITY',
	'ZIP.CODE','LONGITUDE','LATITUDE'])
	for Service in Weightdata[2465:]:
		Address=Service[1]+','+Service[2]+','+'NY'
		print Address
		g=geocoder.google(Address,key='AIzaSyDezpHYMhzU6VLRMuniZa1V6_ZExzGwC8k')
		# print g.json
		a.writerow([Service[0],Service[1],"ERIE",Service[2],g.postal,g.lng,g.lat])
		# j=j+1
		# if j==2:
		# 	break
