Feature: Charity Payment with card not onus

  Scenario Outline: Charity Payment on wisp with card not onus as guest user.
    Given Payment generated with mock body
      """
      {
        "identificativoIntermediarioPA": "11111111111",
        "identificativoStazioneIntermediarioPA": "11111111111_01",
        "identificativoDominio": "11111111111",
        "importoTotaleDaVersare": "10.50",
        "responseEnum": "OK"
      }
      """
    When Browse the payment response url
    And Enter with the mail
    And Select <type_credit_card> credit card
    Then the corresponding psp is displayed
    Examples:
      | type_credit_card |
      | onus             |
      | not onus         |