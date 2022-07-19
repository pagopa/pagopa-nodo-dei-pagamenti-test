Feature: BancomatPay Payment change number telephone
  Scenario: BancomatPay Payment on wisp with change number telephone as registered user.
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And Select add payment method
    And Select Altri metodi 
    And Select Bancomat Pay 
    And Insert a valid jiffy telephone number
    Then psp is displayed
    And Insert a valid jiffy telephone number
    Then psp is displayed