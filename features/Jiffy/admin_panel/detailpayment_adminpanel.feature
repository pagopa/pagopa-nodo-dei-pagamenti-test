Feature: Search on Admin panel
    Scenario: Search detail of transaction on Admin panel
    Given access to Admin Panel with Admin
    When search payment
    Then payment detail is displayed
