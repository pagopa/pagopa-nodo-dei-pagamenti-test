Feature: Change payment manager
    
    Background:
        Given Payment generated with mock
        When Browse the payment response url
    
    Scenario: Check that modify payment manager is available
        When Enter with the mail
        And Select onus credit card
        Then check change payment manager

    Scenario: Check that modify payment manager is not available with amex
        When Enter with the mail
        And Select amex credit card
        Then check not change payment manager

    Scenario: Check that modify payment manager is not available with amex for a registred user
        When Login as registered user
        And Select amex card from the list
        Then check not change payment manager

    Scenario: Check that modify payment manager is available for registered users with favorite card
        When Login as registered user
        And Select favorite card from the list
        Then check change payment manager

    Scenario: Check that modify payment manager is available for registred users
        When Login as registered user
        And Select a card from the list
        Then check change payment manager