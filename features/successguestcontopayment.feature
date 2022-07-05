Feature: Payment with conto as guest
  Scenario: Payment with conto goes to success as guest
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select conto
    Then Payment is made successfully
