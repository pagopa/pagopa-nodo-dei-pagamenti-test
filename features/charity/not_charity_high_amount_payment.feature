Feature: Not Charity Payment with high amount
    Scenario: Not Charity Payment on wisp with high amount as guest user.
      Given Payment generated with mock body
      """
        {
          "identificativoIntermediarioPA": "90000000001",
          "identificativoStazioneIntermediarioPA": "90000000001_01",
          "identificativoDominio": "90000000001",
          "importoTotaleDaVersare": "700000000.23",
          "responseEnum": "OK"
        }
      """
      When Browse the payment response url
      And Enter with the mail
      And Select onus credit card
      And the high amount message is displayed


    Scenario: Not Charity Payment on wisp with high amount as registered user.
      Given Payment generated with mock body
      """
        {
          "identificativoIntermediarioPA": "90000000001",
          "identificativoStazioneIntermediarioPA": "90000000001_01",
          "identificativoDominio": "90000000001",
          "importoTotaleDaVersare": "700000000.23",
          "responseEnum": "OK"
        }
      """
      When Browse the payment response url
      And Login as registered user
      And Select add payment method
      And Select onus credit card
      And the high amount message is displayed