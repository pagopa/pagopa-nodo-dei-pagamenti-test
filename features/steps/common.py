from behave import given, when, then, step
from framework.webapp import WebApp

webapp = WebApp.get_instance()




@given(u'Payment generated with mock')
def step_impl_load_website(context):
    webapp.genera_pagamento()


@when(u'Browse the payment response url')
def step_impl_goto_page(context):
    webapp.goto_page()


@step("Enter with the mail")
def step_impl(context):
    webapp.entro_con_mail()


@then(u'Payment is made successfully')
def step_impl_verify_component(context):
    webapp.verify_payment()


@step("Select credit card")
def step_impl(context):
    webapp.seleziono_carta()


@step("Confirm payment")
def step_impl(context):
    webapp.confermo()

##########################################

@step("Select don't you have spid")
def step_impl(context):
    webapp.nospid()


@then("check mail button")
def step_impl(context):
    webapp.mailBtnCheck()

@then("check cos button is missing")
def step_impl(context):
    webapp.cosBtnCheck()

@then("chiudi il browser")
def step_impl(context):
    pass
    #webapp.chiudiBrowser()

@step("Select the language {lingua}")
def step_impl(context,lingua):
    webapp.selezionolingua(lingua)


@then("Check the text in {lingua}")
def step_impl(context,lingua):
    webapp.controllotesto(lingua)

@step("Enter with wrong mail")
def step_impl(context):
    webapp.mailerrata()


@step("Check wrong mail message")
def step_impl(context):
    webapp.checkmessaggiomailerrata()


@step("Enter with not valid mail")
def step_impl(context):
    webapp.mailnonvalida()


@step("Check not valid mail message")
def step_impl(context):
    webapp.checkmessaggiomailnonvalida()


@step("Enter with your mail")
def step_impl(context):
    webapp.mailtua()


@step("Check privacy page landing")
def step_impl(context):
    webapp.checkpaginaprivacy()


@step("click on why costs")
def step_impl(context):
    webapp.perchecosti()


@then("check costs pop up")
def step_impl(context):
    webapp.checkpopupcosti()

@step("Select onus credit card")
def step_impl(context):
    webapp.seleziono_carta_onus()

@step("Select not onus credit card")
def step_impl(context):
    webapp.seleziono_carta_non_onus()

@then("Check login with spid ways")
def step_impl(context):
    webapp.spidlogin()

@then("Check login as guest")
def step_impl(context):
    webapp.guestlogin()


@step('Login as registered user')
def step_impl(context):
    webapp.loginregistreduser()

@then('Check login is successful')
def step_impl(context):
    webapp.loginsuccessful()