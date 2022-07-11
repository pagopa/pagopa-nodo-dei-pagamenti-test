Feature: Charity Payment with card amex
  Scenario: Charity Payment on wisp with card amex as registered user.
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
    And Select amex credit card
    And Confirm payment
    Then operation denied

  Scenario: Charity Payment on wisp with card amex as guest user.
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
    And Select amex credit card
    And Confirm payment
    Then operation denied