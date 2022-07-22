Feature: SPID login

  Scenario: Different ways of login on SPID
    Given Payment generated with mock
    When Browse the payment response url
    Then Check login with spid ways
    And Check login as guest
