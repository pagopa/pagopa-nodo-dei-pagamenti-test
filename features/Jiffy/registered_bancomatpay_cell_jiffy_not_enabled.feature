Feature: BancomatPay Payment with cell jiffy disabled as registered user
  Scenario: BancomatPay Payment with cell jiffy disabled is not allowed as registered user
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And Select add payment method
    And Select Altri metodi 
    And Select Bancomat Pay 
    And Insert a disabled jiffy telephone number
    Then telephone number must be requested again