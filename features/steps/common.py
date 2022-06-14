from behave import given, when, then, step
from framework.webapp import WebApp

webapp = WebApp.get_instance()


@given(u'Pagamento generato tramite mock')
def step_impl_load_website(context):
    webapp.genera_pagamento()


@when(u'Navigo l\'url di risposta al pagamento')
def step_impl_goto_page(context):
    webapp.goto_page()


@step("Entro con la mail")
def step_impl(context):
    webapp.entro_con_mail()


@then(u'Il pagamento viene effettuato con successo')
def step_impl_verify_component(context):
    webapp.verify_payment()


@step("Seleziono carta di credito")
def step_impl(context):
    webapp.seleziono_carta()


@step("Confermo pagamento")
def step_impl(context):
    webapp.confermo()

##########################################

@step("Seleziono non hai spid")
def step_impl(context):
    webapp.nospid()


@then("controlla bottone tua mail")
def step_impl(context):
    webapp.mailBtnCheck()

@then("controlla assenza bottone cos")
def step_impl(context):
    webapp.cosBtnCheck()

@then("chiudi il browser")
def step_impl(context):
    webapp.chiudiBrowser()

@step("seleziono lingua {lingua}")
def step_impl(context,lingua):
    webapp.selezionolingua(lingua)


@then("controllo il testo in {lingua}")
def step_impl(context,lingua):
    webapp.controllotesto(lingua)

@step("entro con la mail errata")
def step_impl(context):
    webapp.mailerrata()


@step("check messaggio mail errata")
def step_impl(context):
    webapp.checkmessaggiomailerrata()


@step("entro con la mail non valida")
def step_impl(context):
    webapp.mailnonvalida()


@step("check messaggio mail non valida")
def step_impl(context):
    webapp.checkmessaggiomailnonvalida()


@step("entro con la mail tua")
def step_impl(context):
    webapp.mailtua()


@step("check atterraggio pagina privacy")
def step_impl(context):
    webapp.checkpaginaprivacy()


@step("click su perche costi")
def step_impl(context):
    webapp.perchecosti()


@then("check pop up costi")
def step_impl(context):
    webapp.checkpopupcosti()

@step("Seleziono carta di credito onus")
def step_impl(context):
    webapp.seleziono_carta_onus()

@step("Seleziono carta di credito non onus")
def step_impl(context):
    webapp.seleziono_carta_non_onus()