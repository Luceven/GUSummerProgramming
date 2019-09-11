# Part 2 of Week 4 assignment
# Author: Yunjia Zeng
# env: Python 3

import pandas as pd
import datetime
import urllib
from urllib.request import urlopen

def AirNow():
	count = 0
	baseURL = "http://www.airnowapi.org/aq/forecast/"
	api_key = '###YOUR_API_KEY###'
	#date = '2018-08-04'
	# get the current date as input
	now = datetime.datetime.now()
	date = str(now)
	miles = 25
	dfs = list()

	while count < 4:
		try:
			flag = int(input("Do you wish to quit or continue? 1 for continue and 0 for quit: "))
		except ValueError:
			print("\nPlease input the correct command!\n")
			continue
		if flag == 1:
			zipcode = input("\nPlease input your zip code: ")
			zipURL = baseURL + "zipCode/?" + urllib.parse.urlencode({
				'format': 'application/json',
				'zipCode': zipcode,
				'date': date[:10],
				'distance': miles,
				'API_KEY': api_key
				})
			response = urlopen(zipURL).read().decode('utf-8')
			df = pd.read_json(response)
			df = df.assign(Zipcode=zipcode)
			dfs.append(df)
			count = count + 1
		else:
			print("\nSee your next time...")
			break

	results = pd.concat(dfs)
	columns = ['ActionDay', 'Category', 'DateIssue', 'Discussion', 'Latitude', 'Longitude']
	results.drop(columns, inplace=True, axis=1)
	return results

def main():
	results = AirNow()
	print("\nAQI data collected:\n\n", results)
	results.to_csv('OUTFILE.txt', sep='\t', index=False)

if __name__ == "__main__":
	main()
