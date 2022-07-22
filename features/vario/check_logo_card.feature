Feature: Logo card onus

  Background:
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
 
  Scenario: Not visible Logo for card not onus
    And Select not onus credit card
    Then circuit logo is not visible

  Scenario: Visible Logo for card onus
    And Select onus credit card
    Then circuit logo is visible