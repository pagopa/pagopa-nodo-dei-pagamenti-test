Feature: Charity Payment as registred
  Scenario Outline: Charity Payment on wisp with onus card as registered user.
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
    And Login as registered user
    And select add payment method
    And Select <type_credit_card> credit card
    Then the corresponding psp is displayed
    Examples:
      | type_credit_card |
      | onus             |
      | not onus         |