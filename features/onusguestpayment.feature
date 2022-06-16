Feature: Payment with onus as guest
  Scenario: Payment with onus as guest goes successfully
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select onus credit card
    And Confirm payment
    Then Payment is made successfully