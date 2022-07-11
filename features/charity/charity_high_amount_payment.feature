Feature: Charity Payment with high amount

  Scenario: Charity Payment on wisp with high amount as registered user.
    Given Payment generated with mock body
      """
      {
        "identificativoIntermediarioPA": "11111111111",
        "identificativoStazioneIntermediarioPA": "11111111111_01",
        "identificativoDominio": "11111111111",
        "importoTotaleDaVersare": "100000000.50",
        "responseEnum": "OK"
      }
      """
    When Browse the payment response url
    And Login as registered user
    And Select add payment method
    And Select onus credit card
    #And the psp is not displayed
    #And the message "Il tuo pagamento supera l'importo massimo accettato dai gestori su pagoPA per il metodo di pagamento scelto. Ti invitiamo a selezionarne un altro." is displayed
    Then the high amount message is displayed

  Scenario: Charity Payment on wisp with high amount as guest user.
    Given Payment generated with mock body
      """
      {
        "identificativoIntermediarioPA": "11111111111",
        "identificativoStazioneIntermediarioPA": "11111111111_01",
        "identificativoDominio": "11111111111",
        "importoTotaleDaVersare": "100000000.50",
        "responseEnum": "OK"
      }
      """
    When Browse the payment response url
    And Enter with the mail
    And Select onus credit card
    #And the psp is not displayed
    #And the message "Il tuo pagamento supera l'importo massimo accettato dai gestori su pagoPA per il metodo di pagamento scelto. Ti invitiamo a selezionarne un altro." is displayed
    Then the high amount message is displayed