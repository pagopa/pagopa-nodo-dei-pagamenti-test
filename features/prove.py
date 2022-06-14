from selenium import webdriver

PATH = "C:\\Users\\matteo.villano\\OneDrive - Accenture\\Desktop\\work\\PagoPa\\PM2\chromedriver_win32\\chromedriver.exe"
driver = webdriver.Chrome(PATH)

driver.get("https://wikipedia.com")
driver.quit()
print('doneee')