Feature: 3
  Scenario: 3
    Given db connection opened
    And payment generated with mock
    When Browse the payment response url
    And enter with the mail
    And Select 3ds credit card
    And Confirm payment
    Then close the page
    And sleep 5 s
    And Check resultCode in METHOD_RESPONSE_3DS2 is 25
    And Check threeDSMethodUrl in METHOD_RESPONSE_3DS2 is Empty
    And close db connection




