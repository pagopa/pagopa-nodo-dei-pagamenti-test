Feature: Display username on Admin panel 

  Scenario: Display a username_not_equal_email user's username on Admin panel 
    Given access to Admin Panel with Admin
    When search a username_not_equal_email user's Codice Fiscale 
    Then the user is displayed
    And username is displayed 
    And username is not equal to mail

    
  Scenario: Display a username_equal_email user's username on Admin panel 
    Given access to Admin Panel with Admin
    When search a username_equal_email user's Codice Fiscale 
    Then the user is displayed
    And username is displayed 
    And username is equal to mail
    