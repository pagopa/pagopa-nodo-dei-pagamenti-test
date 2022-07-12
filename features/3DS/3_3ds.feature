Feature: guest_payment_3DS2.0
  Scenario: check for result step0 MethodURL on 3DS2.0
    Given Payment generated with mock
    When Browse the payment response url
    And enter with the mail
    And Select 3ds credit card
    And Confirm payment
    Then close the page

   Scenario: DB checks
    Given the check for result step0 MethodURL on 3DS2.0 scenario executed successfully
    And db connection opened
    And Check resultCode in METHOD_RESPONSE_3DS2 is 25
    And Check threeDSMethodUrl in METHOD_RESPONSE_3DS2 is Empty
    Then close db connection


