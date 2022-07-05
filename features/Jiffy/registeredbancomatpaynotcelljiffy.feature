Feature: BancomatPay Payment with cell no jiffy as registered user
  Scenario: BancomatPay Payment with cell no jiffy is not allowed as registered user
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And Select add payment method
    And Select Altri metodi 
    And Select Bancomat Pay 
    And Insert a not valid jiffy telephone number
    Then telephone number must be requested again