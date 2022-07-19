Feature: BancomatPay Payment on wisp as guest
  Scenario: BancomatPay Payment on wisp goes to success as guest.
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select Altri metodi
    And Select Bancomat Pay
    And Insert a valid jiffy telephone number
    And choose continue jiffy
    Then Payment is made successfully jiffy