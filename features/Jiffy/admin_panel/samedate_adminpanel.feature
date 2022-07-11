Feature: Check the correct date in trx

  Scenario: Login on SPID with a registred user
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    Then Check login is successful
    And Check historical payments

    Scenario: Check the correct date in trx on Admin Panel
    Given the Login on SPID with a registred user scenario executed successfully
    And access to Admin Panel with Admin
    When search a user's codice fiscale
    Then click on view transactions
    And Check the date is correct
    

