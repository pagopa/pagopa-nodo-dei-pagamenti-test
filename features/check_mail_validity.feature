Feature: Check mail validity

  Background:
    Given Payment generated with mock
    When Browse the payment response url

  Scenario: Error with wrong mail.
    And Enter with wrong_mail mail
    Then Check wrong mail message

  Scenario: Error with not valid mail.
    And Enter with mail_not_valid mail
    Then Check not valid mail message

  Scenario: Landing on privacy page when you enter your email.
    And Enter with mail mail
    Then Check privacy page landing

  Scenario: Login with mail with uppercase characters.
    And Enter with mail with uppercase characters
    Then Login successfully as guest



