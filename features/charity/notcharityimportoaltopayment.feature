Feature: Not Charity Payment with high amount 
  Scenario: Not Charity Payment on wisp with high amount as registered user.
    Given Payment generated with mock's body equal to {
    "identificativoIntermediarioPA": "90000000001",
    "identificativoStazioneIntermediarioPA": "90000000001_01",
    "identificativoDominio": "90000000001",
    "importoTotaleDaVersare": "700000000.23",
    "responseEnum": "OK"
    }
    When Browse the payment response url
    And Enter as registered user
    And Select credit card 
    And Insert a onus card
    Then the corresponding psp is not displayed
    And the message "Il tuo pagamento supera l'importo massimo accettato dai gestori su pagoPA per il metodo di pagamento scelto. Ti invitiamo a selezionarne un altro." is displayed

    Scenario: Not Charity Payment on wisp with high amount as guest user.
    Given Payment generated with mock's body equal to {
    "identificativoIntermediarioPA": "90000000001",
    "identificativoStazioneIntermediarioPA": "90000000001_01",
    "identificativoDominio": "90000000001",
    "importoTotaleDaVersare": "700000000.23",
    "responseEnum": "OK"
    }
    When Browse the payment response url
    And Enter with mail
    And Select credit card 
    And Insert a onus card
    Then the corresponding psp is not displayed
    And the message "Il tuo pagamento supera l'importo massimo accettato dai gestori su pagoPA per il metodo di pagamento scelto. Ti invitiamo a selezionarne un altro." is displayed