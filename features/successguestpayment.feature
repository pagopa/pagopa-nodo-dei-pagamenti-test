Feature: Payment on wisp as guest
  Scenario: Payment on wisp goes to success as guest.
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select credit card
    And Confirm payment
    Then Payment is made successfully