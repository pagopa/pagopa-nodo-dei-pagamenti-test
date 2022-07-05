Feature: Payment with conto as registered user
  Scenario: Payment with conto goes to success as registered user
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And Select conto after login
    Then sleep 1000 s
    #And Confirm payment
    #Then Payment is made successfully
    #And mail sent successfully