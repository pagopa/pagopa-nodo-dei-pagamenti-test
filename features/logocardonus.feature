Feature: Logo card onus
  Scenario: Visible Logo for card onus
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select onus credit card
    Then circuit logo is visible
