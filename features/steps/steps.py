from datetime import datetime
from webbrowser import get
from behave import *
import json
from data.config import settings
from framework.driver import *
from time import sleep
import requests
import db_operation as db


@given('the {name} scenario executed successfully')
def step_impl(context, name):
    phase = ([phase for phase in context.feature.scenarios if name in phase.name] or [None])[0]
    text_step = ''.join([step.keyword + " " + step.name + "\n\"\"\"\n" + (step.text or '') + "\n\"\"\"\n" for step in phase.steps])
    context.execute_steps(text_step)

@given('Payment generated with mock')
def step_impl(context):
    resp=requests.patch(url=settings['mockPayment']['url'],
                    headers=settings['mockPayment']['headers'],
                    data=json.dumps(settings['mockPayment']['body']))
    #print(resp)
    #print(resp.json())
    context.resp=resp.json()[0]
    print(context.resp)

@step('Browse the payment response url')
def step_impl(context):
    url_wisp = context.resp['urlCloud']
    print('##############################################################')
    print(url_wisp)
    context.driver = Driver()
    context.driver.get(url_wisp)
    elem=context.driver.wait_until(By.XPATH,"//div[@style='display:none'][@class='block']")
    print(elem)
    print(elem.text)
    print(elem.get_attribute("style"))
    context.driver.execute_script("arguments[0].setAttribute('style','display')", elem)
    #context.driver.execute_script("arguments[0].style.display = 'block';", elem)
    #context.driver.get('https://spid-ppt-lmi-npa-sit.tst-npc.sia.eu/login')
    #context.driver.execute_script("arguments[0].style.display = 'block';", elem)


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

@step('Confirm payment')
def step_impl(context):
    sleep(2)
    context.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    #context.driver.wait_until(By.XPATH, "//button[@class='fhSubmit']").click()
    context.driver.wait_until(By.CLASS_NAME, "fhSubmit").click()

@step('Payment is made successfully')
def step_impl(context):
    context.driver.wait_until(By.ID, "success_message")
    context.driver.find_element(By.XPATH,
                             '//*[@action="/wallet/logout"]//button').click()

@step('Close the page')
def step_imp(context):
    context.driver.close()

@then('Check card number is incorrect')
def step_impl(context):
    assert context.driver.wait_until(By.CLASS_NAME, "invalid-error")   


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

@step('Enter with {type_email} mail')
def step_impl(context, type_email):
    context.driver.wait_until(By.XPATH,
                           '//*[@action="enterEmail"]//button[contains(text(),"Entra con la tua email")][contains(@class, "azure")]') \
        .click()
    casella = context.driver.wait_until(By.CLASS_NAME, 'input-email')
    casella.send_keys(settings['holder'][type_email])
    casella.submit()

@then('Check wrong mail message')
def step_impl(context):
    mes = context.driver.find_element(By.XPATH,
                                   "html/body/div[5]/form/div/label[@class='input-label fhError invalid-error']")
    assert mes

@then('Check not valid mail message')
def step_impl(context):
    mes = context.driver.wait_until(By.XPATH, "//*[@class='alert alert-warning alert-dismissable']")
    assert mes.text


@then('Check privacy page landing')
def step_impl(context):
    titolo = context.driver.wait_until(By.XPATH, 'html/body/div[5]/form/div[1]/h5')
    print(titolo.text)
    assert 'privacy' in titolo.text


@step('Select {type_credit_card} credit card')
def step_impl(context, type_credit_card):
    context.driver.wait_until(By.CLASS_NAME, 'credit-card').click()
    context.driver.wait_until(By.NAME, 'pan').send_keys(settings['holder']['credit_cards'][type_credit_card]['pan'])
    context.driver.wait_until(By.NAME, 'expDate').send_keys(settings['holder']['credit_cards'][type_credit_card]['expDate'])
    context.driver.wait_until(By.CLASS_NAME, 'input-cvc').send_keys(settings['holder']['credit_cards'][type_credit_card]['cvc'])
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
    assert context.driver.wait_until(By.ID,'navbar')


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
    context.driver.back()
    context.driver.back()


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

@step('Select amex card from the list')
def step_impl(context):
    context.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    context.driver.wait_until(By.XPATH, "//div[@id='walletCard-21785']/div/div[2]/div/div/div").click()
    #sleep(1000)

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
    context.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    a=context.driver.wait_until(By.XPATH,"//form[@action='/wallet/addWallet']/button")
    a.click()

@step('Select amex card')
def step_impl(context):
    a1 = context.driver.wait_until(By.XPATH, "//div[@data-card-id='22373']/div/div/div[2]/div")
    print(a1.text)

    a1.click()
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
    context.driver.wait_until(By.XPATH,"//div[@class='psp-menu']/a/div/div").click()
    context.driver.wait_until(By.XPATH,"//form[@action='/wallet/psp']/button").click()


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

@step('Select conto after login')
def step_impl(context):
    context.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    a=context.driver.wait_until(By.CLASS_NAME,"azure")
    a.click()
    context.driver.wait_until(By.CLASS_NAME,'bank_account').click()
    context.driver.wait_until(By.CLASS_NAME,'input-search').click()
    context.driver.wait_until(By.CLASS_NAME,'input-search').send_keys('mod2 bp ila')
    context.driver.find_element(By.CLASS_NAME,'search-ico').click()
    sleep(2)
    context.driver.wait_until(By.XPATH,"//div[@class='psp-menu']/a/div/div").click()


@step('Select Bancomat Pay')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME,'input-search').click()
    context.driver.find_element(By.CLASS_NAME, 'input-search').send_keys('bancomat')
    context.driver.wait_until(By.CLASS_NAME, 'search-ico').click()
    sleep(1)
    context.driver.wait_until(By.XPATH,"//div[@class='psp-menu']/a/div/div").click()


@step('Insert a valid jiffy telephone number')
def step_impl(context):
    context.driver.wait_until(By.XPATH, "//form[@action='/wallet/jiffy/change-phone']/button").click()
    context.driver.wait_until(By.CLASS_NAME, 'input-cellphone').click()
    context.driver.wait_until(By.CLASS_NAME, 'input-cellphone').send_keys(settings['holder']['jiffy_phone'])
    context.driver.find_element(By.CLASS_NAME, 'fhSubmit').click()

@step('Insert a valid jiffy telephone number and confirm')
def step_impl(context):
    context.driver.wait_until(By.XPATH, "//form[@action='/wallet/jiffy/change-phone']/button").click()
    context.driver.wait_until(By.CLASS_NAME, 'input-cellphone').click()
    context.driver.wait_until(By.CLASS_NAME, 'input-cellphone').send_keys(settings['holder']['jiffy_phone'])
    context.driver.find_element(By.CLASS_NAME, 'fhSubmit').click()
    context.driver.wait_until(By.CLASS_NAME, 'azure').click()

@step('Payment is made successfully jiffy')
def step_impl(context):
    assert True


@step('Insert a not valid jiffy telephone number')
def step_impl(context):
    context.driver.wait_until(By.XPATH, "//form[@action='/wallet/jiffy/change-phone']/button").click()
    context.driver.wait_until(By.CLASS_NAME, 'input-cellphone').click()
    context.driver.wait_until(By.CLASS_NAME, 'input-cellphone').send_keys(settings['holder']['jiffy_phone_wrong'])
    context.driver.find_element(By.CLASS_NAME, 'fhSubmit').click()

@step('Telephone number must be requested again')
def step_impl(context):
    assert context.driver.wait_until(By.CLASS_NAME,'alert-dismissable')


@step('Insert a valid jiffy telephone number but disabled')
def step_impl(context):
    context.driver.wait_until(By.XPATH, "//form[@action='/wallet/jiffy/change-phone']/button").click()
    context.driver.wait_until(By.CLASS_NAME, 'input-cellphone').click()
    context.driver.wait_until(By.CLASS_NAME, 'input-cellphone').send_keys(settings['holder']['jiffy_phone_disabled'])
    context.driver.find_element(By.CLASS_NAME, 'fhSubmit').click()

@then('psp is displayed')
def step_impl(context):
    assert context.driver.wait_until(By.XPATH,"//img[@class='img-fluid']")



@step('Add credit card')
def step_impl(context):
    context.driver.get('https://acardste.vaservices.eu:1443/wallet/addWallet?')
    context.driver.wait_until(By.CLASS_NAME,'credit-card').click()


@then('Boxes save and preferred are on the page')
def step_impl(context):
    sleep(5)
    assert context.driver.wait_until(By.XPATH,"//input[@id='saveCheckBox']")
    assert context.driver.wait_until(By.XPATH,"//input[@id='favoriteCheckBox']")


@then('check label is not equal to "paga con il tuo conto corrente presso"')
def step_impl(context):
    a=context.driver.wait_until(By.XPATH,"//div[@id='main-element']/div/p")
    assert a
    assert 'conto corrente' not in a.text

@then('psp are displayed')
def step_impl(context):
    assert context.driver.wait_until(By.CLASS_NAME,'psp-logo')
    context.driver.wait_until(By.XPATH,'//div/h2/a').click()
    assert context.driver.wait_until(By.CLASS_NAME,'psp-menu')

@given('Payment generated with mock body')
def step_impl(context):
    payload = context.text
    resp=requests.patch(url=settings['mockPayment']['url'],
                    headers=settings['mockPayment']['headers'],
                    data=payload)
    context.resp=resp.json()[0]

@then('the corresponding psp is displayed')
def step_impl(context):
    assert context.driver.wait_until(By.CLASS_NAME,'psp-logo')

@then('the corresponding psp is not displayed')
def step_impl(context):
    flag = False
    try:
        context.driver.wait_until(By.CLASS_NAME,'psp-logo')
    except:
        flag = True
    assert flag

@then('operation denied')
def step_impl(context):
    assert context.driver.wait_until(By.XPATH, "//div[@id='error_message']/div/div/h3")
    

@step('the high amount message is displayed')
def step_impl(context):
    a=context.driver.wait_until(By.CLASS_NAME,'alert-warning')
    assert "Il tuo pagamento supera l'importo massimo accettato dai gestori su pagoPA per il metodo di pagamento scelto. Ti invitiamo a selezionarne un altro." in a.text

@step('change psp')
def step_impl(context):
    context.driver.wait_until(By.XPATH,"//div/h2/a[@href]").click()


@step('Confirm payment with conto')
def step_impl(context):
    context.driver.wait_until(By.XPATH,"//form[@action='/wallet/psp']/button[@type='submit']").click()

@then('change payment manager is not present')
def step_impl(context):
    pass


@then('Check cvv is required')
def step_impl(context):
    assert context.driver.wait_until(By.XPATH,'//input[@class]')
    context.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    context.driver.wait_until(By.XPATH,'//input[@class]').click()
    context.driver.wait_until(By.XPATH,'//input[@class]').send_keys('1234')

@step('cancel payment')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME,'annulla-blue').click()

@step('cancel payment from burger menu')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME,'navbar-toggler-icon').click()
    context.driver.wait_until(By.ID,'cancel_payment_button').click()

@step('Select enter with mail')
def step_impl(context):
    context.driver.wait_until(By.XPATH,
                              '//*[@action="enterEmail"]//button[contains(@class, "azure")]') \
        .click()

################3ds
@step('Insert OTP')
def step_impl(context):
    sleep(10)
    context.driver.wait_until(By.ID,'challengeDataEntry').send_keys('1234')
    context.driver.wait_until(By.ID, 'confirm').click()

@step('Insert PIN')
def step_impl(context):
    sleep(10)
    context.driver.wait_until(By.ID,'challengeDataEntry').send_keys('1234')
    context.driver.wait_until(By.ID, 'confirm').click()


######################## DB OPERATION ###########################

@given('db connection opened')
def step_impl(context):
    with open(os.path.abspath(os.path.join(__file__, os.pardir, os.pardir, os.pardir, 'data/configurations.json'))) as f:
        json_file = json.load(f)
    
    host, database, user, password, port = json_file.get('host'), json_file.get('database'), json_file.get('user'), json_file.get('password'), json_file.get('port')
    conn = db.getConnection(host, database, user, password, port)
    setattr(context, 'conn', conn)

@then('close db connection')
def step_impl(context):
    db.closeConnection(getattr(context, 'conn'))


@step('Check {parameter} in {column} is {value}')
def step_impl(context, parameter, column, value):
    conn = getattr(context, 'conn')
    query = f"SELECT v.{column} from PP_VPOS_AUTH v, PP_TRANSACTION t, PP_PAYMENT p WHERE v.FK_TRANSACTION = t.ID AND t.FK_PAYMENT = p.ID \
            AND p.ID_SESSION = {context.resp.get('idSession')}"
    query_result = db.executeQuery(conn, query)[0].get(parameter)
    assert query_result == value

#########################AdminPanel
@given('Access to Admin Panel with Admin')
def step_impl(context):
    context.driver = Driver()
    context.driver.get("https://api.dev.platform.pagopa.it/pp-admin-panel/bo/")
    context.driver.wait_until(By.XPATH,
                              '/html/body/app-root/main/app-login/page-without-sidebar/div/div/div/section/div/form/div/div/input').send_keys(
        "admin")
    context.driver.wait_until(By.XPATH, "//input[@placeholder='Password']").send_keys("admin")
    context.driver.wait_until(By.CLASS_NAME, "login").click()

@step('click on Elimina Utente')
def step_impl(context):
    context.driver.wait_until(By.XPATH,
                              'html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div/div/div/button').click()


@step('click on view transactions')
def step_impl(context):
    context.driver.wait_until(By.XPATH, "/html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div[2]/a[3]").click()


@then('the list of transactions is displayed')
def step_impl(context):
    a = context.driver.find_element(By.XPATH,
                                    'html/body/app-root/main/app-transaction-list/page-with-sidebar/div/div/div/div/div/div/div/h2')
    assert a

@then('the user is displayed')
def step_impl(context):
    name = context.driver.wait_until(By.XPATH, '/html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div[3]/div[2]/div/div/div/p').text           
    surname = context.driver.wait_until(By.XPATH, '/html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div[3]/div[2]/div[2]/div/div/p').text
    assert name and surname

@step('username is displayed')
def step_impl(context):
    assert context.driver.wait_until(By.XPATH, '/html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div[3]/div[2]/div[3]/div/div/p').text           



@step('field Registered_Spid is displayed')
def step_impl(context):
    assert context.driver.wait_until(By.XPATH, '/html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div/div[2]/div[5]/div/div/p')           


@step('user\'s stato is displayed')
def step_impl(context):
    assert context.driver.find_element(By.XPATH, 'html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div[3]/div[2]/div[5]/div/div/p').text



@then('the list is displayed')
def step_impl(context):
    a = context.driver.wait_until(By.XPATH,
                                  '/html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div/div/div/div/div/label')
    assert a


@then('mail is displayed')
def step_impl(context):
    a = context.driver.wait_until(By.XPATH,
                                  'html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div/div/div/div/div/div')
    assert a


@then('the user is not displayed')
def step_impl(context):
    a = context.driver.wait_until(By.XPATH,
                                  'html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div/table')
    assert a


@step('search a user\'s mail')
def step_impl(context):
    context.driver.wait_until(By.XPATH, '/html/body/app-root/main/page-search/page-with-sidebar/div/div/div/div/div/section/div/app-search/div/div/div/div[3]/input').send_keys('fabio.pizzini@gft.com')
    context.driver.wait_until(By.XPATH, '/html/body/app-root/main/page-search/page-with-sidebar/div/div/div/div/div/section/div/app-search/div/div/div/button').click()


@step('search a user\'s telephone number')
def step_impl(context):
    context.driver.find_element(By.XPATH,
                                "//input[@placeholder='Cerca per numero di telefono con prefisso (es. +39)']").send_keys(
        "ilariafurla91@gmail.com")
    context.driver.wait_until(By.XPATH,
                              '/html/body/app-root/main/page-search/page-with-sidebar/div/div/div/div/div/section/div/app-search/div/div/div/button').click()

@step('username is equal to mail')
def step_impl(context):
    username =  context.driver.wait_until(By.XPATH, '/html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div[3]/div[2]/div[3]/div/div/p').text
    email = context.driver.wait_until(By.XPATH, '/html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div[3]/div[2]/div[2]/div/div/p').text          
    print('username', username)
    print('email', email)
    assert username == email



@step('username is not equal to mail')
def step_impl(context):
    username =  context.driver.wait_until(By.XPATH, '/html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div[3]/div[2]/div[3]/div/div/p').text
    email = context.driver.wait_until(By.XPATH, '/html/body/app-root/main/app-customer/page-with-sidebar/div/div/div/div/div/div[3]/div[2]/div[2]/div/div/p').text          
    print('username', username)
    print('email', email)   
    assert username != email

@when('search payment')
def step_impl(context):
    context.driver.wait_until(By.XPATH,
                              'html/body/app-root/main/page-search/page-with-sidebar/div/div/div/div/div/section/div/app-search-payment/div/div/div/div/input').send_keys(
        'ae51ff05-a836-4c60-bdcf-d7c9f64bf330')
    context.driver.wait_until(By.XPATH,
                              'html/body/app-root/main/page-search/page-with-sidebar/div/div/div/div/div/section/div/app-search-payment/div/div/div/button').click()


@then('payment detail is displayed')
def step_impl(context):
    a = context.driver.wait_until(By.XPATH,
                                  'html/body/app-root/main/app-payment/page-with-sidebar/div/div/div/div/div/div/div/div/table/thead/tr')
    assert a


@step('Check historical payments')
def step_impl(context):
    context.driver.wait_until(By.CLASS_NAME, 'navbar-toggler-icon').click()
    context.driver.wait_until(By.XPATH, 'html/body/div/div/div/ul/li[2]/a').click()
    date = context.driver.wait_until(By.XPATH, 'html/body/div[5]/div[2]/div/div/p').text
    date_converted = datetime.strptime(date, '%m/%d/%Y, %I:%M:%S %p')
    date = datetime.strftime(date_converted, '%d.%m.%Y - %H.%M')
    setattr(context, 'transaction_date', date)


@step('Check the date is correct')
def step_impl(context):
     current_date = context.driver.wait_until(By.XPATH, 'html/body/app-root/main/app-transaction-list/page-with-sidebar/div/div/div/div/div/div/div/div/table/tbody/tr/td').text
     transaction_date = getattr(context, 'transaction_date')
     assert current_date == transaction_date, f'{current_date} != {transaction_date}'
    


@when('Search a user\'s Codice Fiscale')
def step_impl(context):
    context.driver.wait_until(By.XPATH, '/html/body/app-root/main/page-search/page-with-sidebar/div/div/div/div/div/section/div/app-search/div/div/div/div/input').send_keys(settings['users']['registered']['username_equal_email']['CF'])
    context.driver.wait_until(By.XPATH, '/html/body/app-root/main/page-search/page-with-sidebar/div/div/div/div/div/section/div/app-search/div/div/div/button').click() 

@when('Search a {value} user\'s Codice Fiscale')
def step_impl(context, value):
    fiscal_code = context.driver.wait_until(By.XPATH, '/html/body/app-root/main/page-search/page-with-sidebar/div/div/div/div/div/section/div/app-search/div/div/div/div/input').send_keys(settings['users']['registered'][value]['CF'])
    context.driver.wait_until(By.XPATH, '/html/body/app-root/main/page-search/page-with-sidebar/div/div/div/div/div/section/div/app-search/div/div/div/button').click() 


@then('{message} is dislpayed')
def step_impl(context, message):
    a = context.driver.wait_until(By.XPATH, '//div[@class="col"]/h3').text
    assert message in a, f'{message}, {a}'