Feature:dislpay stato
  
  Scenario: Display a SPID user's stato on Admin panel 
    Given access to Admin Panel with Admin
    When search a user's Codice Fiscale 
    Then the user is displayed
    And field Registered_Spid is displayed
  