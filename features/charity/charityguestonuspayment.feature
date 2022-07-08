Feature: Charity Payment with card not onus
  Scenario: Charity Payment on wisp with card not onus as guest user.
    Given Payment generated with mock charity
    When Browse the payment response url
    And Enter with the mail
    And Select onus credit card
    Then the corresponding psp is displayed