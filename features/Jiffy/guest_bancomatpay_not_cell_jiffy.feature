Feature: BancomatPay Payment with cell no jiffy
  Scenario: BancomatPay Payment with cell no jiffy is not allowed
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select Altri metodi 
    And Select Bancomat Pay
    And Insert a wrong jiffy telephone number
    Then Telephone number must be requested again