Feature: guest_payment_3DS2.0
  Scenario: Scenario Outline name: check for result OK on 3DS2.0
    Given Payment generated with mock
    When Browse the payment response url
    And enter with the mail
    And Select 3ds credit card
    And Confirm payment
    Then close the page


