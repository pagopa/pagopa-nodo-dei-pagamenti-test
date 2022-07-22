Feature: Payment with conto as registered user
  Scenario: Payment with conto goes to success as registered user
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And select add payment method
    And select conto
    And select mod2 bp ila from bank accounts list
    Then Payment is made successfully
    #And mail sent successfully