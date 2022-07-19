Feature:
  Scenario: Not valid phone
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select Altri metodi
    And Select Bancomat Pay
    And Insert a not valid jiffy telephone number
    Then Error message is shown