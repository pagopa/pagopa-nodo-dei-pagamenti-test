from selenium.common.exceptions import TimeoutException
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from data.config import settings
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
import os

from time import sleep

class Driver:

    def __init__(self,browser=None):

        if browser=="chrome":
            service=Service(executable_path=os.path.abspath(os.path.join(__file__, os.pardir, os.pardir, 'chromedriver_win32\\chromedriver.exe')))
            options = webdriver.ChromeOptions()
            #options.add_argument('--headless')
            options.add_argument('no-sandbox')
            options.add_argument('--disable-gpu')
            options.add_argument('--disable-dev-shm-usage')
            options.add_argument('start-fullscreen')
            self.driver = webdriver.Chrome(options=options, service=service)
        elif browser=="firefox":
            pass
        else:
            options = Options()
            options.binary_location = '/usr/bin/google-chrome'
            options.add_argument('--no-sandbox')
            options.add_argument('--headless')
            options.add_argument("--remote-debugging-port=9222")
            # options.add_argument('--disable-gpu') Only for Windows
            options.add_argument('--disable-dev-shm-usage')
            options.add_argument("--disable-extensions")
            options.add_argument("start-maximized")
            options.add_argument("disable-infobars")
            self.driver = webdriver.Chrome(chrome_options=options, executable_path='/usr/local/share/chromedriver')
            # sleep(10)


    def get(self, url):
        self.driver.get(url)

    def submit(self):
        self.driver.find_element(By.CLASS_NAME, 'fhSubmit').click()

    def close(self):
        self.driver.close()

###########
    def quit(self):
        self.driver.quit()

    def isDisplayed(self):
        self.driver.isDisplayed()


    def find_element(self, by, param):
        return self.driver.find_element(by, param)

    def find_elements(self, by, param):
        return self.driver.find_elements(by, param)

    def execute_script(self, script,e=None):
        self.driver.execute_script(script,e)

    def wait_until(self, type_of_search: str, content_of_search: str):
        try:
            return WebDriverWait(self.driver, 20).until(
                EC.presence_of_element_located((type_of_search, content_of_search)))
        except TimeoutException:
            self.driver.close()
            assert False

    def back(self):
        self.driver.back()

    def click(self):
        self.driver.click()


    def get_current_url(self):
        return self.driver.current_url
