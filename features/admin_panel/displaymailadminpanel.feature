Feature: Display mail on Admin panel   
  Scenario: Display a SPID user's mail on Admin panel 
    Given access to Admin Panel with Admin
    When  search fiscal code of registered user 
    Then mail is displayed 
    


    