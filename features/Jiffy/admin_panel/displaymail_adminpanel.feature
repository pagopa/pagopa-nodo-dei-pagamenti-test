Feature: Display mail on Admin panel   
  Scenario: Display a SPID user's mail on Admin panel 
    Given access to Admin Panel with Admin
    When  Search a SPID user's Codice Fiscale
    Then mail is displayed 
    


    