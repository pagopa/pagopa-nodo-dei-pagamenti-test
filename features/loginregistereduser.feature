Feature: SPID login with registered user

  Scenario: Login on SPID with a registred user
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    Then Check login is successful