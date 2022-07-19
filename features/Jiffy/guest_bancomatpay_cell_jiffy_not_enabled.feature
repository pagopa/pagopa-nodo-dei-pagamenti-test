Feature: BancomatPay Payment with cell jiffy disabled
  Scenario: BancomatPay Payment with cell jiffy disabled is not allowed
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select Altri metodi 
    And Select Bancomat Pay
    And Insert a disabled jiffy telephone number
    Then Telephone number must be requested again