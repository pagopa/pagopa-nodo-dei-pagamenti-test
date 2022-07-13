Feature:
  Scenario: 11 as guest
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select onus credit card
    And Cancel payment


  Scenario: 11 as registered user
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And select add payment method
    And Select onus credit card
    And Cancel payment from burger menu