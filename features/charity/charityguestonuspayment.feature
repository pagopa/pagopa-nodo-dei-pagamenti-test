Feature: Charity Payment with card not onus
  Scenario: Charity Payment on wisp with card not onus as guest user.
    Given Payment generated with mock's body equal to {
    "identificativoIntermediarioPA": "11111111111",
    "identificativoStazioneIntermediarioPA": "11111111111_01",
    "identificativoDominio": "11111111111",
    "importoTotaleDaVersare": "10.50",
    "responseEnum": "OK"
    }
    When Browse the payment response url
    And Enter with the mail
    And Select credit card 
    And Insert a onus card
    Then the corresponding psp is displayed