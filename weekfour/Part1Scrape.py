## Part 1 of Week 4 Assignment
# env: Python 3
# Author: Yunjia Zeng

# import libraries
from bs4 import BeautifulSoup
import urllib3 as url
import certifi as cert

def yahoo_stock():
	while True:
		try:
			flag = int(input("Do you wish to quit or continue? 1 for continue and 0 for quit: "))
		except ValueError:
			print("Please input the correct command!")
			continue
		if flag == 1:
			ticker = input("Please input the name of stock (eg. AAPL): ")
			http = url.PoolManager(cert_reqs='CERT_REQUIRED', ca_certs=cert.where())
			html_doc = http.request('GET', 'https://finance.yahoo.com/quote/' + ticker + '?p=' + ticker)
			soup = BeautifulSoup(html_doc.data, 'html.parser')
			stock_price = soup.find("span", class_="Trsdu(0.3s) Fw(b) Fz(36px) Mb(-4px) D(ib)").get_text()
			print("The price of " + ticker + " is: $", stock_price)
			#flag = input("Do you wish to quit or continue? 1 for continue and 0 for quit: ")
		else:
			print("See you next time...")
			break
			

if __name__ == "__main__":
	yahoo_stock()
				