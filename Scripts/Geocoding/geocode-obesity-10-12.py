import csv
import re
import geocoder
import sys
import csv
fp=open('10_12_Student_Weight_Status_Category.csv','rb')
reader=csv.reader(fp)
Weightdata=[]
for row in reader:
  Weightdata.append(row)
# map(lambda(age,_):age,filter(lambda(_,person_id):person_id==10,mylist))
Weightdata_rev=zip(*Weightdata)
LCodeList=Weightdata_rev[0][1:]
LCodeEdit=[]
for i in LCodeList:
	LCodeEdit.append((6-len(i))*'0'+i)
LCode=set(LCodeEdit)
DistrictUnit=[]
for i in sorted(LCode):
	DistrictUnit.append(LCodeEdit.index(i))
DistrictUnit2=map(lambda x:x+3,DistrictUnit)
fp=open('2013-14-SchoolDirectoryandGeneralInformation.csv','rb')
reader=csv.reader(fp)
Schooldata=[]
for row in reader:
  Schooldata.append(row)
# print Schooldata[57][2]
# print type(Schooldata[57][2])
#search all the school district and their sub schools
SchoolCodes=list(zip(*Schooldata)[2])
SchoolCodesAb=[]
for i in SchoolCodes:
	#remove last 6 character of the Complete Codes
	SchoolCodesAb.append(i[:-6])
# for i in
j=0

SchoolListErr=[]
RegionList=[]
SchoolDisLevelList=[]
LocationList=[]
ProblemList=[]
UnCtgList=[]
UnGCList=[]
List1=[]# for confidence==9 while different zipcode or city by searching name
List2=[]# for confidence==9 while different zipcode or city by searching address
with open('MergedDataTrial.csv', 'w') as fp:	
	a = csv.writer(fp, delimiter=',')	
	a.writerow([
	'SED CODE','COUNTY','LNSD','REGION',
	'INST TYPE CODE','INST TYPE DESC','INST SUBTYPE CODE','INST SUBTYPE DESC','GRAD ORG CODE','GRAD ORG DESC','COM TYPE CODE','COM TYPE DESC',
	'GRADE LEVEL',
	'NO OVERW','PCT OVERW','NO OBESE','PCT OBESE','NO OVERW OBESE','PCT OVERW OBESE',
	'MAIL ADD','CITY','STATE','ZIP CODE',
	'LOCATION1','LATITUDE','LONGITUDE'
	])
	k=0# count the number of using google map service
	length=len(DistrictUnit)
	for N_Row in range(length):
		item=DistrictUnit[N_Row]
		try:
			# DistrictCode=Weightdata[item][0]+'03'+'0000'
			Pattern=Weightdata[item][0]+'0'+'\d\d\d\d\d' # Weightdata[item][0] is a 6-digit number like 010100		
			# print 'Code is'+Pattern
			try:
				StartIndex=SchoolCodesAb.index(Weightdata[item][0])
				j=j+1
				# print 'StartIndex is'+str(StartIndex)
				SchoolIndex=SchoolCodes[StartIndex]
				# print 'S is'+str(SchoolIndex)
				n=StartIndex
				# Postfix _SD means of Same School District
				# DATA_SH_D will store the specific type of data like 'county' of all schools from the same school district
				DATA_SH_D=[]				
				# print Pattern
				# Get property from School Data	or Weight Data
				while re.match(Pattern,SchoolIndex) is not None:
					# print 'successful:'+SchoolIndex
					# print n				
					SED_CODE=Schooldata[n][2]
					COUNTY=Schooldata[n][1]			
					LNSD=Schooldata[n][3] 
					REGION=Weightdata[item][3]
					INST_TYPE_CODE=Schooldata[n][4] 
					INST_TYPE_DESC=Schooldata[n][5]
					INST_SUBTYPE_CODE=Schooldata[n][6]
					INST_SUBTYPE_DESC=Schooldata[n][7]
					GRAD_ORG_CODE=Schooldata[n][8] 
					GRAD_ORG_DESC=Schooldata[n][9]
					# print GRAD_ORG_DESC
					COM_TYPE_CODE=Schooldata[n][10]
					COM_TYPE_DESC=Schooldata[n][11]
					# Catogorized by GRAD_ORG_CODE
					if GRAD_ORG_CODE=='': # School district
						GRADE_LEVEL='DISTRICT TOTAL'
						PCT_OVERW=Weightdata[item][6]
						PCT_OBESE=Weightdata[item][8]
						PCT_OVERW_OBESE=Weightdata[item][10]					
					elif int(GRAD_ORG_CODE)==1: #Elementary school
						GRADE_LEVEL='ELEMENTARY'
						#PCT for Elementary school
						PCT_OVERW=Weightdata[item+1][6]
						PCT_OBESE=Weightdata[item+1][8] 
						PCT_OVERW_OBESE=Weightdata[item+1][10]
					elif int(GRAD_ORG_CODE)>=2 and int(GRAD_ORG_CODE)<=5: #Middle/High School
						GRADE_LEVEL='MIDDLE/HIGH'
						PCT_OVERW=Weightdata[item+2][6]
						PCT_OBESE=Weightdata[item+2][8]
						PCT_OVERW_OBESE=Weightdata[item+2][10]
					else:
						print 'Uncategorized School:'+SED_CODE
						GRADE_LEVEL='N/A'
						#PCT for district total
						PCT_OVERW=Weightdata[item][6]
						PCT_OBESE=Weightdata[item][8]
						PCT_OVERW_OBESE=Weightdata[item][10]
						# Save Uncategorized Schools
						UnCtgList.append([int(SED_CODE),GRAD_ORG_DESC])
					# Only for school districts level data
					NO_OVERW=Weightdata[item][5] if str(SchoolIndex)[-4:]=='0000' else "N/A"
					# Only for school districts level data
					NO_OBESE=Weightdata[item][7] if str(SchoolIndex)[-4:]=='0000' else "N/A"
					# Only for school districts level data
					NO_OVERW_OBESE=Weightdata[item][9] if str(SchoolIndex)[-4:]=='0000' else "N/A"
					MAIL_ADD=Schooldata[n][12]
					CITY=Schooldata[n][13]
					STATE=Schooldata[n][14]
					ZIP_CODE=Schooldata[n][15]
					Address=MAIL_ADD+','+CITY+','+STATE

					# print Address_Name
					##CHECK SCHOOL DISTRICT IS UNION FREE OR NOT, IF IT IS, DIRECTLY USE THE ADDRESS
					##FIRST GOOGLE NAME CHECK ITS CONFIDENCE AND CITY AND ZIPCODE
					##IF CITY AND ZIPCODE IS DOUBTFUL AND CONFIDENCE IS WRIGHT,ACCEPT,RECORD
					##ELSE IF CONFIDENCE IS NOT 9, TRY GOOGLE ADDRESS
					## IF CONFIDENCE IS RIGHT, ACCEPT
					## ELSE ,TAKE IT AS 
					###########UNION FREE#######################
					# g=geocoder.google(Address_Name)
					g=geocoder.google(Address, key='AIzaSyDezpHYMhzU6VLRMuniZa1V6_ZExzGwC8k')
					k=k+1
					# g=geocoder.bing(Address,key='Ar1tQJQm7oDCxBGPCNLus2qiYt6lrDuTWtNYAWaBbjP7GwxrCbpe83FreJSfe-oT')
					# Check ZIP_CODE and COUNTY
					if g.city is None:
						g_city = 'N/A'
					else:
						g_city=g.city.upper()
					if g.postal==ZIP_CODE and g_city==CITY and g.confidence==9:
						LOCATION1 = g.latlng
						# print LOCATION1
						LATITUDE=LOCATION1[0]
						LONGITUDE=LOCATION1[-1]
					elif g.confidence==9:
						LOCATION1 = g.latlng
						# print LOCATION1
						LATITUDE=LOCATION1[0]
						LONGITUDE=LOCATION1[-1]
						List1.append([SED_CODE,COUNTY,LNSD,LOCATION1,LATITUDE,LONGITUDE,ZIP_CODE,CITY,g.postal,g_city,g.confidence])
					#Try directly use School Name to geocode instead of Address
					else: 
						#Variable 'Name' for checking Location Accuracy
						Address_Name=LNSD+','+CITY+','+STATE
						k=k+1
						g_alt=geocoder.google(Address_Name,key='AIzaSyDezpHYMhzU6VLRMuniZa1V6_ZExzGwC8k')
						if g_alt.city is None:
							g_alt_city = 'N/A'
						else:
							g_alt_city=g_alt.city.upper()
						if g_alt.postal==ZIP_CODE and g_alt_city==CITY and g_alt.confidence==9:
							LOCATION1 = g_alt.latlng
							# print LOCATION1
							LATITUDE=LOCATION1[0]
							LONGITUDE=LOCATION1[-1]
						elif g_alt.confidence==9:
							LOCATION1 = g_alt.latlng
							# print LOCATION1
							LATITUDE=LOCATION1[0]
							LONGITUDE=LOCATION1[-1]
							List2.append([SED_CODE,COUNTY,LNSD,LOCATION1,LATITUDE,LONGITUDE,ZIP_CODE,CITY,g.postal,g_city,g.confidence])
						else:
							'Ungeocoded School:'+SED_CODE						
							try:
								if g.confidence>=g_alt.confidence:
									print 'conf is '+str(g.confidence)
									LOCATION1=g.latlng
									LATITUDE=LOCATION1[0]
									LONGITUDE=LOCATION1[-1]
									pass
								else:
									print 'conf is '+str(g_alt.confidence)
									LOCATION1=g_alt.latlng
									LATITUDE=LOCATION1[0]
									LONGITUDE=LOCATION1[-1]
							except :
								LOCATION1='N/A'
								LATITUDE='N/A'
								LONGITUDE='N/A'							
							UnGCList.append([SED_CODE,COUNTY,LNSD,LOCATION1,LATITUDE,LONGITUDE,ZIP_CODE,CITY,g.postal,g_city,g.confidence,g_alt.postal,g_alt_city,g_alt.confidence])
					DATA_SH=[
					SED_CODE,COUNTY,LNSD,REGION,
					INST_TYPE_CODE,INST_TYPE_DESC,INST_SUBTYPE_CODE,INST_SUBTYPE_DESC,GRAD_ORG_CODE,GRAD_ORG_DESC,COM_TYPE_CODE,COM_TYPE_DESC,
					GRADE_LEVEL,
					NO_OVERW,PCT_OVERW,NO_OBESE,PCT_OBESE,NO_OVERW_OBESE,PCT_OVERW_OBESE,
					MAIL_ADD,CITY,STATE,ZIP_CODE,
					LOCATION1,LATITUDE,LONGITUDE
					]
					# print DATA_SH
					DATA_SH_D.append(DATA_SH)

					# Update SchoolIndex to iterate
					n=n+1
					SchoolIndex=Schooldata[n][2]
					#output...
					
				# Write School Districts and Schools Data into CSV 
				a.writerows(DATA_SH_D)

			except ValueError as e:
				print str(e)
				print 'Problem'+str(item)			
				# check whether it is school district level data
				ProblemList.append(Weightdata[item][0])
				try:				
					if int(Weightdata[item][0])<100000:
						# It is school district level data
						SchoolDisLevelList.append(item)
					elif Weightdata[item][1]=='N/A':
						RegionList.append(item)
					else:
						SchoolListErr.append(item)
				except:
					#Weightdata[0][0] is "Location Code"
					pass			
				pass
		except ValueError:
			print 'what the hell'+str(i)
			pass
		# if k>=200:
		# 	break
		# if j==10:
		# 	break
		print 'District # is '+str(j)
	print 'Geocoding service using times is'+str(k)
	print 'N of District is '+str(j)
	print 'N of Row is '+str(N_Row)
	# sys.exit("Finished")

# UnGCListInt=[]

# for i in UnGCList:
#     UnGCListInt.append(int(i))

with open('UnGCList.csv','w') as fpp:
    b=csv.writer(fpp)
    b.writerow(['SED_CODE','COUNTY','LNSD','LOCATION1','LATITUDE','LONGITUDE','ZIP_CODE','CITY','g.postal','g.city.upper()','g.confidence','g_alt.postal','g_alt_city.upper()','g_alt.confidence'])
    b.writerows(UnGCList)
    # b.writerow('Problem')
    # b.writerows(ProblemList)
with open('List1.csv','w') as fpp:
    b=csv.writer(fpp)
    b.writerow(['SED_CODE','COUNTY','LNSD','LOCATION1','LATITUDE','LONGITUDE','ZIP_CODE','CITY','g.postal','g_city.upper()','g.confidence'])
    for item in List1:
    	b.writerow(item)
with open('List2.csv','w') as fpp:
    b=csv.writer(fpp)
    b.writerow(['SED_CODE','COUNTY','LNSD','LOCATION1','LATITUDE','LONGITUDE','ZIP_CODE','CITY','g_alt.postal','g_alt_city.upper()','g_alt.confidence'])
    for item in List2:
    	b.writerow(item)
with open('UnCtgList.csv','w') as fpp:
    b=csv.writer(fpp)
    b.writerow(['Uncategorized','Gradlevel'])
    for item in UnCtgList:
    	b.writerow(item)
with open('ProbList.csv','w') as fpp:
    b=csv.writer(fpp)
    for item in ProblemList[1:]:
    	b.writerow([item])
    # b.writerows(ProblemList[1:]) 