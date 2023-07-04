Feature: process tests for nodoChiediTemplateInformativaPSP

    Background:
        Given systems up
@runnable 
    Scenario: Send nodoChiediTemplateInformativaPSP
        Given initial XML nodoChiediTemplateInformativaPSP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediTemplateInformativaPSP>
                    <identificativoPSP>idPsp1</identificativoPSP>
                    <identificativoIntermediarioPSP>70000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>70000000001_04</identificativoCanale>
                    <password>pwdpwdpwd</password>
                </ws:nodoChiediTemplateInformativaPSP>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check xmlTemplateInformativa field exists in nodoChiediTemplateInformativaPSP response
        And check ppt:nodoChiediTemplateInformativaPSPRisposta field exists in nodoChiediTemplateInformativaPSP response
        And check xmlTemplateInformativa is UEQ5NGJXd2dkbVZ5YzJsdmJqMGlNUzR3SWlCbGJtTnZaR2x1WnowaVZWUkdMVGdpSUhOMFlXNWtZV3h2Ym1VOUlubGxjeUkvUGp4cGJtWnZjbTFoZEdsMllWQlRVQ0I0Yld4dWN6cDRjMms5SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpJd01ERXZXRTFNVTJOb1pXMWhMV2x1YzNSaGJtTmxJaUI0YzJrNmMyTm9aVzFoVEc5allYUnBiMjQ5SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpJd01ERXZXRTFNVTJOb1pXMWhMV2x1YzNSaGJtTmxJajQ4YVdSbGJuUnBabWxqWVhScGRtOUdiSFZ6YzI4K1JFRWdRMDlOVUVsTVFWSkZJQ2htYjNKdFlYUnZPaUJiU1VSUVUxQmRYMlJrTFcxdExYbDVlWGtnTFNCbGMyVnRjR2x2T2lCRlUwVk5VRWxQWHpNeExURXlMVEl3TURFcFBDOXBaR1Z1ZEdsbWFXTmhkR2wyYjBac2RYTnpiejQ4YVdSbGJuUnBabWxqWVhScGRtOVFVMUErUkVFZ1EwOU5VRWxNUVZKRlBDOXBaR1Z1ZEdsbWFXTmhkR2wyYjFCVFVENDhjbUZuYVc5dVpWTnZZMmxoYkdVK1JFRWdRMDlOVUVsTVFWSkZQQzl5WVdkcGIyNWxVMjlqYVdGc1pUNDhZMjlrYVdObFFVSkpQams0TnpZMVBDOWpiMlJwWTJWQlFraytQR052WkdsalpVSkpRejVVUWtROEwyTnZaR2xqWlVKSlF6NDhiWGxpWVc1clNVUldVejVEVkRBd01EQTNOVHd2YlhsaVlXNXJTVVJXVXo0OGFXNW1iM0p0WVhScGRtRk5ZWE4wWlhJK1BHUmhkR0ZRZFdKaWJHbGpZWHBwYjI1bFBrUkJJRU5QVFZCSlRFRlNSVHd2WkdGMFlWQjFZbUpzYVdOaGVtbHZibVUrUEdSaGRHRkpibWw2YVc5V1lXeHBaR2wwWVQ1RVFTQkRUMDFRU1V4QlVrVThMMlJoZEdGSmJtbDZhVzlXWVd4cFpHbDBZVDQ4ZFhKc1NXNW1iM0p0WVhwcGIyNXBVRk5RUGtSQklFTlBUVkJKVEVGU1JUd3ZkWEpzU1c1bWIzSnRZWHBwYjI1cFVGTlFQangxY214SmJtWnZjbTFoZEdsMllWQlRVRDVFUVNCRFQwMVFTVXhCVWtVOEwzVnliRWx1Wm05eWJXRjBhWFpoVUZOUVBqeDFjbXhEYjI1MlpXNTZhVzl1YVZCVFVENUVRU0JEVDAxUVNVeEJVa1U4TDNWeWJFTnZiblpsYm5wcGIyNXBVRk5RUGp4emRHOXlibTlRWVdkaGJXVnVkRzgrTUR3dmMzUnZjbTV2VUdGbllXMWxiblJ2UGp4dFlYSmpZVUp2Ykd4dlJHbG5hWFJoYkdVK01Ed3ZiV0Z5WTJGQ2IyeHNiMFJwWjJsMFlXeGxQanhzYjJkdlVGTlFQa1JCSUVOUFRWQkpURUZTUlR3dmJHOW5iMUJUVUQ0OEwybHVabTl5YldGMGFYWmhUV0Z6ZEdWeVBqeHNhWE4wWVVsdVptOXliV0YwYVhaaFJHVjBZV2xzUGp4cGJtWnZjbTFoZEdsMllVUmxkR0ZwYkQ0OGFXUmxiblJwWm1sallYUnBkbTlKYm5SbGNtMWxaR2xoY21sdlBrUkJJRU5QVFZCSlRFRlNSVHd2YVdSbGJuUnBabWxqWVhScGRtOUpiblJsY20xbFpHbGhjbWx2UGp4cFpHVnVkR2xtYVdOaGRHbDJiME5oYm1Gc1pUNUVRU0JEVDAxUVNVeEJVa1U4TDJsa1pXNTBhV1pwWTJGMGFYWnZRMkZ1WVd4bFBqeDBhWEJ2Vm1WeWMyRnRaVzUwYno1Q1FsUThMM1JwY0c5V1pYSnpZVzFsYm5SdlBqeHRiMlJsYkd4dlVHRm5ZVzFsYm5SdlBqQThMMjF2WkdWc2JHOVFZV2RoYldWdWRHOCtQSEJ5YVc5eWFYUmhQa1JCSUVOUFRWQkpURUZTUlR3dmNISnBiM0pwZEdFK1BHTmhibUZzWlVGd2NENUVRU0JEVDAxUVNVeEJVa1U4TDJOaGJtRnNaVUZ3Y0Q0OGFXUmxiblJwWm1sallYcHBiMjVsVTJWeWRtbDZhVzgrUEc1dmJXVlRaWEoyYVhwcGJ6NUVRU0JEVDAxUVNVeEJVa1U4TDI1dmJXVlRaWEoyYVhwcGJ6NDhiRzluYjFObGNuWnBlbWx2UGtSQklFTlBUVkJKVEVGU1JUd3ZiRzluYjFObGNuWnBlbWx2UGp3dmFXUmxiblJwWm1sallYcHBiMjVsVTJWeWRtbDZhVzgrUEd4cGMzUmhTVzVtYjNKdFlYcHBiMjVwVTJWeWRtbDZhVzgrUEdsdVptOXliV0Y2YVc5dWFWTmxjblpwZW1sdlBqeGpiMlJwWTJWTWFXNW5kV0UrU1ZROEwyTnZaR2xqWlV4cGJtZDFZVDQ4WkdWelkzSnBlbWx2Ym1WVFpYSjJhWHBwYno1RVFTQkRUMDFRU1V4QlVrVThMMlJsYzJOeWFYcHBiMjVsVTJWeWRtbDZhVzgrUEd4cGJXbDBZWHBwYjI1cFUyVnlkbWw2YVc4K1JFRWdRMDlOVUVsTVFWSkZQQzlzYVcxcGRHRjZhVzl1YVZObGNuWnBlbWx2UGp4MWNteEpibVp2Y20xaGVtbHZibWxEWVc1aGJHVStSRUVnUTA5TlVFbE1RVkpGUEM5MWNteEpibVp2Y20xaGVtbHZibWxEWVc1aGJHVStQQzlwYm1admNtMWhlbWx2Ym1sVFpYSjJhWHBwYno0OGFXNW1iM0p0WVhwcGIyNXBVMlZ5ZG1sNmFXOCtQR052WkdsalpVeHBibWQxWVQ1SlZEd3ZZMjlrYVdObFRHbHVaM1ZoUGp4a1pYTmpjbWw2YVc5dVpWTmxjblpwZW1sdlBrUkJJRU5QVFZCSlRFRlNSVHd2WkdWelkzSnBlbWx2Ym1WVFpYSjJhWHBwYno0OGJHbHRhWFJoZW1sdmJtbFRaWEoyYVhwcGJ6NUVRU0JEVDAxUVNVeEJVa1U4TDJ4cGJXbDBZWHBwYjI1cFUyVnlkbWw2YVc4K1BIVnliRWx1Wm05eWJXRjZhVzl1YVVOaGJtRnNaVDVFUVNCRFQwMVFTVXhCVWtVOEwzVnliRWx1Wm05eWJXRjZhVzl1YVVOaGJtRnNaVDQ4TDJsdVptOXliV0Y2YVc5dWFWTmxjblpwZW1sdlBqeHBibVp2Y20xaGVtbHZibWxUWlhKMmFYcHBiejQ4WTI5a2FXTmxUR2x1WjNWaFBrbFVQQzlqYjJScFkyVk1hVzVuZFdFK1BHUmxjMk55YVhwcGIyNWxVMlZ5ZG1sNmFXOCtSRUVnUTA5TlVFbE1RVkpGUEM5a1pYTmpjbWw2YVc5dVpWTmxjblpwZW1sdlBqeHNhVzFwZEdGNmFXOXVhVk5sY25acGVtbHZQa1JCSUVOUFRWQkpURUZTUlR3dmJHbHRhWFJoZW1sdmJtbFRaWEoyYVhwcGJ6NDhkWEpzU1c1bWIzSnRZWHBwYjI1cFEyRnVZV3hsUGtSQklFTlBUVkJKVEVGU1JUd3ZkWEpzU1c1bWIzSnRZWHBwYjI1cFEyRnVZV3hsUGp3dmFXNW1iM0p0WVhwcGIyNXBVMlZ5ZG1sNmFXOCtQR2x1Wm05eWJXRjZhVzl1YVZObGNuWnBlbWx2UGp4amIyUnBZMlZNYVc1bmRXRStTVlE4TDJOdlpHbGpaVXhwYm1kMVlUNDhaR1Z6WTNKcGVtbHZibVZUWlhKMmFYcHBiejVFUVNCRFQwMVFTVXhCVWtVOEwyUmxjMk55YVhwcGIyNWxVMlZ5ZG1sNmFXOCtQR3hwYldsMFlYcHBiMjVwVTJWeWRtbDZhVzgrUkVFZ1EwOU5VRWxNUVZKRlBDOXNhVzFwZEdGNmFXOXVhVk5sY25acGVtbHZQangxY214SmJtWnZjbTFoZW1sdmJtbERZVzVoYkdVK1JFRWdRMDlOVUVsTVFWSkZQQzkxY214SmJtWnZjbTFoZW1sdmJtbERZVzVoYkdVK1BDOXBibVp2Y20xaGVtbHZibWxUWlhKMmFYcHBiejQ4YVc1bWIzSnRZWHBwYjI1cFUyVnlkbWw2YVc4K1BHTnZaR2xqWlV4cGJtZDFZVDVKVkR3dlkyOWthV05sVEdsdVozVmhQanhrWlhOamNtbDZhVzl1WlZObGNuWnBlbWx2UGtSQklFTlBUVkJKVEVGU1JUd3ZaR1Z6WTNKcGVtbHZibVZUWlhKMmFYcHBiejQ4YkdsdGFYUmhlbWx2Ym1sVFpYSjJhWHBwYno1RVFTQkRUMDFRU1V4QlVrVThMMnhwYldsMFlYcHBiMjVwVTJWeWRtbDZhVzgrUEhWeWJFbHVabTl5YldGNmFXOXVhVU5oYm1Gc1pUNUVRU0JEVDAxUVNVeEJVa1U4TDNWeWJFbHVabTl5YldGNmFXOXVhVU5oYm1Gc1pUNDhMMmx1Wm05eWJXRjZhVzl1YVZObGNuWnBlbWx2UGp3dmJHbHpkR0ZKYm1admNtMWhlbWx2Ym1sVFpYSjJhWHBwYno0OGJHbHpkR0ZRWVhKdmJHVkRhR2xoZG1VK1BIQmhjbTlzWlVOb2FXRjJaVDVFUVNCRFQwMVFTVXhCVWtVOEwzQmhjbTlzWlVOb2FXRjJaVDQ4Y0dGeWIyeGxRMmhwWVhabFBrUkJJRU5QVFZCSlRFRlNSVHd2Y0dGeWIyeGxRMmhwWVhabFBqeHdZWEp2YkdWRGFHbGhkbVUrUkVFZ1EwOU5VRWxNUVZKRlBDOXdZWEp2YkdWRGFHbGhkbVUrUEM5c2FYTjBZVkJoY205c1pVTm9hV0YyWlQ0OFkyOXpkR2xUWlhKMmFYcHBiejQ4ZEdsd2IwTnZjM1J2VkhKaGJuTmhlbWx2Ym1VK01Ed3ZkR2x3YjBOdmMzUnZWSEpoYm5OaGVtbHZibVUrUEhScGNHOURiMjF0YVhOemFXOXVaVDR3UEM5MGFYQnZRMjl0YldsemMybHZibVUrUEd4cGMzUmhSbUZ6WTJWRGIzTjBiMU5sY25acGVtbHZQanhtWVhOamFXRkRiM04wYjFObGNuWnBlbWx2UGp4cGJYQnZjblJ2VFdGemMybHRiMFpoYzJOcFlUNUVRU0JEVDAxUVNVeEJVa1U4TDJsdGNHOXlkRzlOWVhOemFXMXZSbUZ6WTJsaFBqeGpiM04wYjBacGMzTnZQa1JCSUVOUFRWQkpURUZTUlR3dlkyOXpkRzlHYVhOemJ6NDhMMlpoYzJOcFlVTnZjM1J2VTJWeWRtbDZhVzgrUEdaaGMyTnBZVU52YzNSdlUyVnlkbWw2YVc4K1BHbHRjRzl5ZEc5TllYTnphVzF2Um1GelkybGhQa1JCSUVOUFRWQkpURUZTUlR3dmFXMXdiM0owYjAxaGMzTnBiVzlHWVhOamFXRStQR052YzNSdlJtbHpjMjgrUkVFZ1EwOU5VRWxNUVZKRlBDOWpiM04wYjBacGMzTnZQand2Wm1GelkybGhRMjl6ZEc5VFpYSjJhWHBwYno0OFptRnpZMmxoUTI5emRHOVRaWEoyYVhwcGJ6NDhhVzF3YjNKMGIwMWhjM05wYlc5R1lYTmphV0UrUkVFZ1EwOU5VRWxNUVZKRlBDOXBiWEJ2Y25SdlRXRnpjMmx0YjBaaGMyTnBZVDQ4WTI5emRHOUdhWE56Yno1RVFTQkRUMDFRU1V4QlVrVThMMk52YzNSdlJtbHpjMjgrUEM5bVlYTmphV0ZEYjNOMGIxTmxjblpwZW1sdlBqd3ZiR2x6ZEdGR1lYTmpaVU52YzNSdlUyVnlkbWw2YVc4K1BDOWpiM04wYVZObGNuWnBlbWx2UGp3dmFXNW1iM0p0WVhScGRtRkVaWFJoYVd3K1BDOXNhWE4wWVVsdVptOXliV0YwYVhaaFJHVjBZV2xzUGp3dmFXNW1iM0p0WVhScGRtRlFVMUEr of nodoChiediTemplateInformativaPSP response


@runnable 
    Scenario: Send second nodoChiediTemplateInformativaPSP
        Given initial XML nodoChiediTemplateInformativaPSP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediTemplateInformativaPSP>
                    <identificativoPSP>IDPSPFNZ</identificativoPSP>
                    <identificativoIntermediarioPSP>91000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>91000000001_03</identificativoCanale>
                    <password>pwdpwdpwd</password>
                </ws:nodoChiediTemplateInformativaPSP>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check xmlTemplateInformativa field exists in nodoChiediTemplateInformativaPSP response
        And check ppt:nodoChiediTemplateInformativaPSPRisposta field exists in nodoChiediTemplateInformativaPSP response
        And check fault field not exists in nodoChiediTemplateInformativaPSP response