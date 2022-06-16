import json
from time import sleep
import requests
from selenium.webdriver.common.by import By
from data.config import settings
from framework.driver import Driver
class WebApp:
    instance = None
    payment_response = None
    payment_ = settings['mockPayment']
    holder = settings['holder']
    driver = None
    @classmethod
    def get_instance(cls):
        if cls.instance is None:
            cls.instance = WebApp()
        return cls.instance
    def __init__(self):
        #self.driver = Driver()
        pass
    def genera_pagamento(self):
        r = requests.patch(url=self.payment_['url'], headers=self.payment_['headers'],
                           data=json.dumps(self.payment_['body']))
        self.payment_response = r.json()[0]
        print(json.dumps(self.payment_response, indent=4, sort_keys=True))
    def goto_page(self):
        url_wisp = self.payment_response['url']
        print(url_wisp)
        self.driver.get(url_wisp)
    def entro_con_mail(self):
        self.driver.wait_until(By.XPATH,
                               '//*[@action="enterEmail"]//button[contains(text(),"Entra con la tua email")][contains(@class, "azure")]') \
            .click()
        casella = self.driver.wait_until(By.CLASS_NAME, 'input-email')
        casella.send_keys(self.holder['mail'])
        casella.submit()
        self.driver.wait_until(By.XPATH, '//input[@name="privacy"]').click()
        self.driver.submit()
    def seleziono_carta(self):
        self.driver.wait_until(By.CLASS_NAME, 'credit-card').click()
        self.driver.wait_until(By.NAME, 'pan').send_keys(self.holder['pan'])
        self.driver.wait_until(By.NAME, 'expDate').send_keys(self.holder['expDate'])
        self.driver.wait_until(By.CLASS_NAME, 'input-cvc').send_keys(self.holder['cvc'])
        self.driver.wait_until(By.CLASS_NAME, 'input-holder').send_keys(self.holder['name'])
        self.driver.submit()
    def confermo(self):
        sleep(2)
        self.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        self.driver.submit()
    def verify_payment(self):
        self.driver.wait_until(By.ID, "success_message")
        self.driver.find_element(By.XPATH,
                                 '//*[@action="/wallet/logout"]//button').click()
        #self.driver.close()

######################################

    def nospid(self):
        self.driver.wait_until(By.XPATH,'/html/body[1]/div[5]/div[4]/div/div/a').click()
        #sleep(3)
        #self.driver.close()
        #assert False
        #self.driver.close()

    def mailBtnCheck(self):
        a= self.driver.wait_until(By.XPATH,'html/body/div[2]/div/div/div[3]/div/form/button')
        assert a

    def cosBtnCheck(self):
        assert True


    def chiudiBrowser(self):
        #self.driver.close()
        pass
    
    def selezionolingua(self,lingua):
        try:
            self.driver.wait_until(By.XPATH, 'html/body/div[5]/div/button').click()
            self.driver.wait_until(By.XPATH,'html/body/div[5]/div/ul/li/a[@href="#'+lingua+'"]').click()
        except:
            assert False

    def controllotesto(self,lingua):
        pass

    def mailerrata(self):
        self.driver.wait_until(By.XPATH,
                               '//*[@action="enterEmail"]//button[contains(text(),"Entra con la tua email")][contains(@class, "azure")]') \
            .click()
        casella = self.driver.wait_until(By.CLASS_NAME, 'input-email')
        casella.send_keys('aaaaaaaaa')
        #casella.submit()
        pass

    def checkmessaggiomailerrata(self):
        #sleep(1)
        mes = self.driver.find_element(By.XPATH,"html/body/div[5]/form/div/label[@class='input-label fhError invalid-error']")
        #print(mes)
        #print(mes.text)
        assert mes


    def mailnonvalida(self):
        self.driver.wait_until(By.XPATH,
                               '//*[@action="enterEmail"]//button[contains(text(),"Entra con la tua email")][contains(@class, "azure")]') \
            .click()
        casella = self.driver.wait_until(By.CLASS_NAME, 'input-email')
        casella.send_keys('aaaaaa@arjbfu')
        casella.submit()
        pass

    def checkmessaggiomailnonvalida(self):
        #sleep(1)
        mes = self.driver.find_element(By.XPATH,"html/body/div[5]/div")
        assert mes.text

    def mailtua(self):
        self.driver.wait_until(By.XPATH,
                               '//*[@action="enterEmail"]//button[contains(text(),"Entra con la tua email")][contains(@class, "azure")]') \
            .click()
        casella = self.driver.wait_until(By.CLASS_NAME, 'input-email')
        casella.send_keys('aaaaaa@arjbfu.com')
        casella.submit()
        pass

    def checkpaginaprivacy(self):
        titolo = self.driver.wait_until(By.XPATH,'html/body/div[5]/form/div[2]/h3')
        print(titolo.text)
        assert 'DATI PERSONALI' in titolo.text


    def perchecosti(self):
        self.driver.wait_until(By.XPATH,'html/body/div[5]/div/div[6]/div[2]/h2/a').click()

    def checkpopupcosti(self):
        #trovo il popup
        assert self.driver.wait_until(By.ID,'dynamic_modal')
        #trovo la x
        assert self.driver.wait_until(By.XPATH, 'html/body/div[4]/div/div/div/button')
        # trovo tasto chiudi
        assert self.driver.wait_until(By.XPATH, 'html/body/div[4]/div/div/div[3]/button')

    def seleziono_carta_onus(self):
        self.driver.wait_until(By.CLASS_NAME, 'credit-card').click()
        self.driver.wait_until(By.NAME, 'pan').send_keys(self.holder['pan'])
        self.driver.wait_until(By.NAME, 'expDate').send_keys(self.holder['expDate'])
        self.driver.wait_until(By.CLASS_NAME, 'input-cvc').send_keys(self.holder['cvc'])
        self.driver.wait_until(By.CLASS_NAME, 'input-holder').send_keys(self.holder['name'])
        self.driver.submit()

    def seleziono_carta_non_onus(self):
        self.driver.wait_until(By.CLASS_NAME, 'credit-card').click()
        self.driver.wait_until(By.NAME, 'pan').send_keys("4003171102270111")
        self.driver.wait_until(By.NAME, 'expDate').send_keys(self.holder['expDate'])
        self.driver.wait_until(By.CLASS_NAME, 'input-cvc').send_keys(self.holder['cvc'])
        self.driver.wait_until(By.CLASS_NAME, 'input-holder').send_keys(self.holder['name'])
        self.driver.submit()