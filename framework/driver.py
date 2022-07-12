from selenium.common.exceptions import TimeoutException
from selenium.webdriver.chromium.options import ChromiumOptions
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from data.config import settings
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
import os

from time import sleep

class Driver:

    def __init__(self,browser="chrome"):

        service = Service(executable_path=os.path.abspath(os.path.join(__file__, os.pardir, os.pardir, 'chromedriver_win32/chromedriver.exe')))
        match browser:
            case "chrome":
                print('init driverrrr')
                options = webdriver.ChromeOptions()
                options.add_argument('--headless')
                options.add_argument('no-sandbox')
                options.add_argument('--disable-gpu')
                options.add_argument('--disable-dev-shm-usage')
                options.add_argument('start-fullscreen')
                self.driver = webdriver.Chrome(options=options, service=service)
                #sleep(10)
            case "firefox":
                pass
            case _:
                pass

    """
    def __init__(self):
        print('sto inizializzando il browser')
        browser = settings['browser']
        match browser['type']:
            case "firefox":
                self.driver = webdriver.Firefox()
            case "chrome":
                options = webdriver.ChromeOptions()
                self.add_options(options, browser['options'])
                #options.add_argument('--headless')
                self.driver = webdriver.Chrome(options=options)
            case _:
                self.driver = webdriver.Firefox()
        """
    @staticmethod
    def add_options(options: ChromiumOptions, options_settings: list):
        for o in options_settings:
            options.add_argument(o)

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
            return WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((type_of_search, content_of_search)))
        except TimeoutException:
            self.driver.close()
            assert False

    def back(self):
        self.driver.back()

    def click(self):
        self.driver.click()

    def find_element_by_class_name(self,name):
        return self.driver.find_element_by_class_name(name)
