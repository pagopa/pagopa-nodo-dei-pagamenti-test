from behave import *
import json
from data.config import settings
from framework.driver import *
from time import sleep
import requests

@given('Payment generated with mock')
def step_impl(context):
    resp=requests.patch(url=settings['mockPayment']['url'],
                    headers=settings['mockPayment']['headers'],
                    data=json.dumps(settings['mockPayment']['body']))
    context.resp=resp.json()[0]

@step('Browse the payment response url')
def step_impl(context):
    url_wisp = context.resp['url']
    print('##############################################################')
    print(url_wisp)
    context.driver = Driver()
    context.driver.get(url_wisp)

@step('Enter with the mail')
def step_impl(context):
    context.driver.wait_until(By.XPATH,
                           #'//*[@action="enterEmail"]//button[contains(text(),"Entra con la tua email")][contains(@class, "azure")]') \
                           '//*[@action="enterEmail"]//button[contains(@class, "azure")]') \
        .click()
    casella = context.driver.wait_until(By.CLASS_NAME, 'input-email')
    casella.send_keys(settings['holder']['mail'])
    casella.submit()
    context.driver.wait_until(By.XPATH, '//input[@name="privacy"]').click()
    context.driver.submit()

@step('Select credit card')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME, 'credit-card').click()
    context.driver.wait_until(By.NAME, 'pan').send_keys(settings['holder']['pan'])
    context.driver.wait_until(By.NAME, 'expDate').send_keys(settings['holder']['expDate'])
    context.driver.wait_until(By.CLASS_NAME, 'input-cvc').send_keys(settings['holder']['cvc'])
    context.driver.wait_until(By.CLASS_NAME, 'input-holder').send_keys(settings['holder']['name'])
    a = context.driver.wait_until(By.XPATH, "/html/body/div[5]/form/div[4]/button")
    a.click()

@step('Confirm payment')
def step_impl(context):
    sleep(2)
    context.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    context.driver.submit()

@step('Payment is made successfully')
def step_impl(context):
    context.driver.wait_until(By.ID, "success_message")
    context.driver.find_element(By.XPATH,
                             '//*[@action="/wallet/logout"]//button').click()


@step("Select don't you have spid")
def step_impl(context):
    context.driver.wait_until(By.XPATH,'/html/body[1]/div[5]/div[4]/div/div/a').click()

@then('check mail button')
def step_impl(context):
    a = context.driver.wait_until(By.XPATH, 'html/body/div[2]/div/div/div[3]/div/form/button')
    assert a


@then('check cos button is missing')
def step_impl(context):
    f = False
    try:
        a = context.driver.find_element(By.XPATH, "//*[contains(text(), 'come ottenere SPID')]")
        if a:
            assert False
        else:
            assert True
    except:
        assert True


@step('Select the language {lang}')
def step_impl(context,lang):
    context.driver.wait_until(By.XPATH, 'html/body/div[5]/div/button').click()
    a = context.driver.find_element(By.XPATH, 'html/body/div[5]/div/ul/li/a[@href="#' + lang+ '"]')
    if a:
        pass
        a.click()
    else:
        assert False
    sleep(0.5)


@then('Check the text in {lang}')
def step_impl(context,lang):
    context.driver.wait_until(By.XPATH, '/html/body[1]/div[5]/div[4]/div/div/a').click()
    a = context.driver.find_element(By.XPATH, '/html/body/div[2]/div/div/div[2]')



@step('click on why costs')
def step_impl(context):
    context.driver.wait_until(By.XPATH,'html/body/div[5]/div/div[6]/div[2]/h2/a').click()

@then('check costs pop up')
def step_impl(context):
    assert context.driver.wait_until(By.ID, 'dynamic_modal')
    assert context.driver.wait_until(By.XPATH, 'html/body/div[4]/div/div/div/button')
    assert context.driver.wait_until(By.XPATH, 'html/body/div[4]/div/div/div[3]/button')



@step('Enter with wrong mail')
def step_impl(context):
    context.driver.wait_until(By.XPATH,
                           '//*[@action="enterEmail"]//button[contains(text(),"Entra con la tua email")][contains(@class, "azure")]') \
        .click()
    casella = context.driver.wait_until(By.CLASS_NAME, 'input-email')
    casella.send_keys('aaaaaaaaa')


@then('Check wrong mail message')
def step_impl(context):
    mes = context.driver.find_element(By.XPATH,
                                   "html/body/div[5]/form/div/label[@class='input-label fhError invalid-error']")
    assert mes

@step('Enter with not valid mail')
def step_impl(context):
    context.driver.wait_until(By.XPATH,
                       '//*[@action="enterEmail"]//button[contains(text(),"Entra con la tua email")][contains(@class, "azure")]') \
        .click()
    casella = context.driver.wait_until(By.CLASS_NAME, 'input-email')
    casella.send_keys('aaaaaa@arjbfu')
    casella.submit()

@then('Check not valid mail message')
def step_impl(context):
    mes = context.driver.wait_until(By.XPATH, "//*[@class='alert alert-warning alert-dismissable']")
    assert mes.text

@step('Enter with your mail')
def step_impl(context):
    context.driver.wait_until(By.XPATH,
                           '//*[@action="enterEmail"]//button[contains(text(),"Entra con la tua email")][contains(@class, "azure")]') \
        .click()
    casella = context.driver.wait_until(By.CLASS_NAME, 'input-email')
    casella.send_keys('aaaaaa@arjbfu.com')
    casella.submit()


@then('Check privacy page landing')
def step_impl(context):
    titolo = context.driver.wait_until(By.XPATH, 'html/body/div[5]/form/div[1]/h5')
    print(titolo.text)
    assert 'privacy' in titolo.text


@step('Select onus credit card')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME, 'credit-card').click()
    context.driver.wait_until(By.NAME, 'pan').send_keys(settings['holder']['pan'])
    context.driver.wait_until(By.NAME, 'expDate').send_keys(settings['holder']['expDate'])
    context.driver.wait_until(By.CLASS_NAME, 'input-cvc').send_keys(settings['holder']['cvc'])
    context.driver.wait_until(By.CLASS_NAME, 'input-holder').send_keys(settings['holder']['name'])
    a = context.driver.wait_until(By.XPATH, "/html/body/div[5]/form/div[4]/button")
    a.click()

@step('Select not onus credit card')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME, 'credit-card').click()
    context.driver.wait_until(By.NAME, 'pan').send_keys(settings['holder']['pan_not_onus'])
    context.driver.wait_until(By.NAME, 'expDate').send_keys(settings['holder']['expDate'])
    context.driver.wait_until(By.CLASS_NAME, 'input-cvc').send_keys(settings['holder']['cvc'])
    context.driver.wait_until(By.CLASS_NAME, 'input-holder').send_keys(settings['holder']['name'])
    a = context.driver.wait_until(By.XPATH, "/html/body/div[5]/form/div[4]/button")
    a.click()


@step('Login as registered user')
def step_impl(context):
    a = context.driver.wait_until(By.CLASS_NAME, 'italia-it-button-icon')
    a.click()
    list = context.driver.find_elements(By.CLASS_NAME, 'spid-idp-button-link')
    for i in list:
        if i.text == 'Test SIT':
            i.click()
            break
    #sleep(1)
    a = context.driver.wait_until(By.ID, 'username')
    #a.send_keys(self.user['username'])
    a.send_keys('fabiospid3')
    a = context.driver.wait_until(By.ID, 'password')
    a.send_keys('fabiospid3')
    #a.send_keys(self.user['password'])
    context.driver.wait_until(By.NAME, 'confirm').click()
    context.driver.wait_until(By.NAME, 'confirm').click()

@then('Check login is successful')
def step_impl(context):
    pass

@step('Check login with spid ways')
def step_impl(context):
    btn = context.driver.wait_until(By.XPATH, '//a[@spid-idp-button="#spid-idp-button-medium-post"]')
    btn.click()
    tmp = context.driver.find_elements(By.CLASS_NAME, 'spid-idp-button-link')
    btn.click()
    assert len(tmp) >= 9


@then('Check login as guest')
def step_impl(context):
    tmp = context.driver.find_elements(By.XPATH, 'html/body/div[5]/div[3]/form/a')
    assert len(tmp) >= 1

@step('sleep {time} s')
def step_impl(context,time):
    sleep(int(time))

@then('check logo is not clickable')
def step_impl(context):
    #pass
    f=False
    a = context.driver.wait_until(By.CLASS_NAME,'logo')
    assert a
    try:
        a.click()
    except:
        f=True
    assert f

@step('check cvv not predictive')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME, 'credit-card').click()
    context.driver.wait_until(By.NAME, 'pan').send_keys(settings['holder']['pan'])
    context.driver.wait_until(By.NAME, 'expDate').send_keys(settings['holder']['expDate'])
    a = context.driver.wait_until(By.CLASS_NAME, 'input-cvc')
    a.click()
    #list=context.driver.find_elements(By.XPATH,'//li')
    #assert len(list)==0
    a.send_keys(settings['holder']['cvc'])
    context.driver.wait_until(By.CLASS_NAME, 'input-holder').send_keys(settings['holder']['name'])
    a = context.driver.wait_until(By.XPATH, "/html/body/div[5]/form/div[4]/button")
    a.click()


@then('Check burger menu')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME,'navbar-toggler-icon').click()
    lis = context.driver.find_elements(By.XPATH,"//div[@class='modal-area']/ul/li")
    assert len(lis)==2
    assert context.driver.find_element(By.ID,'cancel_payment_button')


@then('check change payment manager')
def step_impl(context):
    mod = context.driver.wait_until(By.XPATH,"html/body/div[5]/div/div[5]/div[2]/h2/a")
    assert mod
    mod.click()
    assert context.driver.wait_until(By.CLASS_NAME,'psp-menu')


@step('Select a card from the list')
def step_impl(context):
    #implementare modo più robusto di trovare l'elemento?
    context.driver.wait_until(By.XPATH,"html/body/div[5]/div/div/div/div[2]/div/div/div[2]/div").click()


@step('Select favorite card from the list')
def step_impl(context):
    context.driver.wait_until(By.XPATH, "html/body/div[5]/div/div[2]/div/div[2]/div/div/div[2]/div").click()


@step('Select credit card amex')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME, 'credit-card').click()
    context.driver.wait_until(By.NAME, 'pan').send_keys(settings['holder']['pan_amex'])
    context.driver.wait_until(By.NAME, 'expDate').send_keys(settings['holder']['expDate'])
    context.driver.wait_until(By.CLASS_NAME, 'input-cvc').send_keys(settings['holder']['cvc'])
    context.driver.wait_until(By.CLASS_NAME, 'input-holder').send_keys(settings['holder']['name'])
    a = context.driver.wait_until(By.XPATH, "/html/body/div[5]/form/div[4]/button")
    a.click()

@then('check not change payment manager')
def step_impl(context):
    f=False
    try:
        context.driver.wait_until(By.XPATH,"html/body/div[5]/div/div[5]/div[2]/h2/a")
    except:
        f=True

    assert f

@step('Select add Payment method')
def step_impl(context):
    print('###########################')
    #a=context.driver.wait_until(By.CSS_SELECTOR,"button[class='btn button azure']")
    a=context.driver.wait_until(By.XPATH,"//div[@data-card-id='22373']/div/div/div[2]/div")
    print(a)
    print(a.text)
    print('#####################################')
    a.click()
    print('&&&&&&&&&')

@step('Select amex card')
def step_impl(context):
    a1 = context.driver.wait_until(By.XPATH, "//div[@data-card-id='22373']/div/div")
    print(a1.text)

    #a1.click()
    sleep(1000)



@step('look for the psp by entering Ragione sociale')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME,'input-search').send_keys('intesa')
    context.driver.find_element(By.XPATH,"//form[@id='search-form']/a/img").click()


@then('psp found successfully')
def step_impl(context):
    a=context.driver.wait_until(By.XPATH,"//div[@class='psp-menu']/a")
    assert a
    pass

@step('Select conto')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME, 'bank_account').click()

@step('Select Altri metodi')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME, 'other').click()

@step('look for the psp by entering Nome servizi')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME, 'input-search').send_keys('mod')
    context.driver.find_element(By.XPATH, "//form[@id='search-form']/a/img").click()


@step('Select transaction history')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME,'navbar-toggler-icon').click()
    context.driver.find_element(By.XPATH,"//div[@class='modal-body']/div[@class='modal-area']/ul/li[2]/a").click()

@then('Check previous transactions')
def step_impl(context):
    context.driver.wait_until(By.XPATH,"//div[@class='transaction-list']/div")
    list=context.driver.find_elements(By.XPATH,"//div[@class='transaction-list']/div")
    print(len(list))
    assert len(list)>0

@then('circuit logo is visible')
def step_impl(context):
    assert context.driver.wait_until(By.CLASS_NAME,'card-logo')

@then('circuit logo is not visible')
def step_impl(context):
    assert context.driver.wait_until(By.CLASS_NAME,'card-logo')

@then('Error message is shown')
def step_impl(context):
    assert context.driver.wait_until(By.CLASS_NAME,'error-title')
    assert context.driver.wait_until(By.CLASS_NAME,'error-description')

@step('Select credit card with wrong card holder')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME, 'credit-card').click()
    context.driver.wait_until(By.NAME, 'pan').send_keys(settings['holder']['pan'])
    context.driver.wait_until(By.NAME, 'expDate').send_keys(settings['holder']['expDate'])
    context.driver.wait_until(By.CLASS_NAME, 'input-cvc').send_keys(settings['holder']['cvc'])
    context.driver.wait_until(By.CLASS_NAME, 'input-holder').send_keys(settings['holder']['wrong_name'])


@then('Check name error')
def step_impl(context):
    f=False
    a = context.driver.find_elements(By.CLASS_NAME, "input-label")
    for i in a:
        if 'nome e cognome non validi' in i.text:
            f=True
    assert f

@step('Enter with mail with uppercase characters')
def step_impl(context):
    context.driver.wait_until(By.XPATH,
                              '//*[@action="enterEmail"]//button[contains(@class, "azure")]') \
        .click()
    casella = context.driver.wait_until(By.CLASS_NAME, 'input-email')
    casella.send_keys(settings['holder']['mail_upper'])
    casella.submit()
    context.driver.wait_until(By.XPATH, '//input[@name="privacy"]').click()
    context.driver.submit()

@then('Login successfully as guest')
def step_impl(context):
    assert context.driver.wait_until(By.CLASS_NAME,'wallet-menu')


@step('Select credit card with apostrophe on cardHolder')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME, 'credit-card').click()
    context.driver.wait_until(By.NAME, 'pan').send_keys(settings['holder']['pan'])
    context.driver.wait_until(By.NAME, 'expDate').send_keys(settings['holder']['expDate'])
    context.driver.wait_until(By.CLASS_NAME, 'input-cvc').send_keys(settings['holder']['cvc'])
    context.driver.wait_until(By.CLASS_NAME, 'input-holder').send_keys(settings['holder']['name_apostrophe'])
    a = context.driver.wait_until(By.XPATH, "/html/body/div[5]/form/div[4]/button")
    a.click()
