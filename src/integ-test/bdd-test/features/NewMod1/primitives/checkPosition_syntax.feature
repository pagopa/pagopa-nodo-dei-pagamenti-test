Feature: syntax checks for checkPosition

    Background:
        Given systems up
        And initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "311#iuv#"
                    }
                ]
            }
            """
    
    # SIN_CPO_01
    Scenario: Invalid positionslist 1
        Given positionslist with None in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid positionslist of checkPosition response

    # SIN_CPO_02
    Scenario: Invalid positionslist 2
        Given positionslist with Empty in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid positionslist of checkPosition response

    # SIN_CPO_03
    Scenario: Invalid fiscalCode 1
        Given fiscalCode with None in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response

    # SIN_CPO_04
    Scenario: Invalid fiscalCode 2
        Given fiscalCode with Empty in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response

    # SIN_CPO_05
    Scenario: Invalid fiscalCode 3
        Given fiscalCode with 1111111111 in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response

    # SIN_CPO_06
    Scenario: Invalid fiscalCode 4
        Given fiscalCode with 111111111111 in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response

    # SIN_CPO_07
    Scenario: Invalid fiscalCode 5
        Given fiscalCode with 1111111111a in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid fiscalCode of checkPosition response

    # SIN_CPO_08
    Scenario: Invalid noticeNumber 1
        Given noticeNumber with None in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid noticeNumber of checkPosition response

    # SIN_CPO_09
    Scenario: Invalid noticeNumber 2
        Given noticeNumber with Empty in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid noticeNumber of checkPosition response

    # SIN_CPO_10
    Scenario: Invalid noticeNumber 3
        Given noticeNumber with 11111111111111111 in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid noticeNumber of checkPosition response

    # SIN_CPO_11
    Scenario: Invalid noticeNumber 4
        Given noticeNumber with 1111111111111111111 in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid noticeNumber of checkPosition response

    # SIN_CPO_12
    Scenario: Invalid noticeNumber 5
        Given noticeNumber with 11111111111111111a in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid noticeNumber of checkPosition response