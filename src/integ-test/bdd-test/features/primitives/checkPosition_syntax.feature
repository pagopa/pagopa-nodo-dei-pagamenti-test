Feature: syntax checks for checkPosition

    Background: Given systems up

    # SIN_CPO_01
    Scenario: Invalid positionslist 1
        Given initial json checkPosition
            """
            {}
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check description is Invalid positionslist of checkPosition response
        And check errorCode is 400

    # SIN_CPO_02
    Scenario: Invalid positionslist 2
        Given initial json checkPosition
            """
            {
                "positionslist": []
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check description is Invalid positionslist of checkPosition response
        And check errorCode is 400

    # SIN_CPO_03
    Scenario: Invalid fiscalCode 1
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "noticeNumber": "#notice_number#"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response
        And check errorCode is 400

    # SIN_CPO_04
    Scenario: Invalid fiscalCode 2
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "",
                        "noticeNumber": "#notice_number#"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response
        And check errorCode is 400

    # SIN_CPO_05
    Scenario: Invalid fiscalCode 3
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "1111111111",
                        "noticeNumber": "#notice_number#"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response
        And check errorCode is 400

    # SIN_CPO_06
    Scenario: Invalid fiscalCode 4
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "111111111111",
                        "noticeNumber": "#notice_number#"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response
        And check errorCode is 400

    # SIN_CPO_07
    Scenario: Invalid fiscalCode 5
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "111111111a%",
                        "noticeNumber": "#notice_number#"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response
        And check errorCode is 400

    # SIN_CPO_08
    Scenario: Invalid noticeNumber 1
        Given initial json checkPosition
            """
            {
            "positionslist": [
            {
            "fiscalCode": "#creditor_institution_code#",
            }
            ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response
        And check errorCode is 400

    # SIN_CPO_09
    Scenario: Invalid noticeNumber 2
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": ""
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response
        And check errorCode is 400

    # SIN_CPO_10
    Scenario: Invalid noticeNumber 3
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "11111111111111111"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response
        And check errorCode is 400

    # SIN_CPO_11
    Scenario: Invalid noticeNumber 4
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "1111111111111111111"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response
        And check errorCode is 400

    # SIN_CPO_12
    Scenario: Invalid noticeNumber 5
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "1111111111111111a%"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response
        And check errorCode is 400

# da implementare in step.py:
# @given('initial json {primitive}')
#   ...