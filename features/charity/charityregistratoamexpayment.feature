Feature: Charity Payment with card amex
  """
  Scenario: Charity Payment on wisp with card amex as registered user.
    Given Payment generated with mock's body equal to {
    "identificativoIntermediarioPA": "11111111111",
    "identificativoStazioneIntermediarioPA": "11111111111_01",
    "identificativoDominio": "11111111111",
    "importoTotaleDaVersare": "10.50",
    "responseEnum": "OK"
    }
    When Browse the payment response url
    And Enter as registered user
    And Select credit card 
    And Insert a amex card
    And confirm Payment
    Then operation denied
"""
    Scenario: Charity Payment on wisp with card amex as guest user.
    Given Payment generated with mock charity
    When Browse the payment response url
    And Enter with mail
    And Select credit card amex
    Then sleep 1000 s
    Then operation denied