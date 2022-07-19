Feature: BancomatPay Payment on wisp as registered user
  Scenario: BancomatPay Payment on wisp goes to success as registered user.
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    Then Select add payment method
    And Select Altri metodi
    And Select Bancomat Pay
    And Insert a valid jiffy telephone number
    And choose continue jiffy
    Then Payment is made successfully jiffy