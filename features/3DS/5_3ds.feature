Feature: 5
  Scenario: 5
    Given db connection opened
    And Payment generated with mock
    When Browse the payment response url
    And enter with the mail
    And Select 3ds credit card
    And Confirm payment
    And close the page
    And sleep 10 s
    Then Check resultCode in METHOD_RESPONSE_3DS2 is 25
    And Check threeDSMethodUrl in METHOD_RESPONSE_3DS2 is Empty
    And close db connection


