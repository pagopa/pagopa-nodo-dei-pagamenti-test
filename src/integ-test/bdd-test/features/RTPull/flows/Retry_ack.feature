Feature: RTPull flows

    Background:
        Given systems up
        #And generic update through the query param_update_generic_where_condition of the table CANALI the parameter PROTOCOLLO = 'HTTP', with where condition ID_CANALE like '6000%' AND ID_CANALE <> '#canaleRtPull#' under macro update_query on db nodo_cfg
        #And refresh job PSP triggered after 10 seconds
        #And wait 10 seconds for expiration
        And MB generation
            """
            <?xml version="1.0" encoding="UTF-8"?>
                <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
                <PSP>
                    <CodiceFiscale>12345678901</CodiceFiscale>
                    <Denominazione>40000000001</Denominazione>
                </PSP>
                <IUBD>#iubd#</IUBD>
                <OraAcquisto>2015-02-06T15:00:44.659+01:00</OraAcquisto>
                <Importo>10.00</Importo>
                <TipoBollo>01</TipoBollo>
                <ImprontaDocumento>
                    <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
                    <ns2:DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</ns2:DigestValue>
                </ImprontaDocumento>
                <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
                    <SignedInfo>
                        <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
                        <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />
                        <Reference URI="">
                            <Transforms>
                                <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
                            </Transforms>
                            <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
                            <DigestValue>IzdMHSaGk1GC71oRUrJPXY+5MMgwpEbHQSgRXASVwLM=</DigestValue>
                        </Reference>
                    </SignedInfo>
                    <SignatureValue>tSO5SByNpadbzbPvUn5T99ajU4hHdqJLVyr4u8P8WSB5xc9K7Szmw/fo5SYXYaPS6A/DzPlchM95 fgFMZ3VYByqtA+Vc7WgX8aIOEVOrM6eXqx8+kc4g/jgm/9EQyUmXGP+RBvx2Sg0uim04aDdB7Ffd UIi6Q5vjjna1rhNvZIkBEjCV++f+wbL9qpFLt8E2N+bOq9Y0wcTUBHiICrxXvDBDUj1X7Ckbu0/Y KVRJck6cE5rpoQB6DjxdEn5DEUgmzR/UZEwtA1BK3cVRiOsaszx8bXEIwGHe4fvvzxJOHIqgL4ct jj1DoI5m2xGoobQ3rG6Pf3HEwFXLw9x83OykDA==</SignatureValue>
                    <KeyInfo Id="keyinfo">
                        <X509Data>
                            <X509Certificate>MIIDjDCCAnSgAwIBAgICBXIwDQYJKoZIhvcNAQEFBQAwNTELMAkGA1UEBhMCSVQxDjAMBgNVBAoT BVNvZ2VpMRYwFAYDVQQDEw1DQSBTb2dlaSBUZXN0MB4XDTE1MDIwMzE2MDc1MFoXDTIxMDIwMzE2 MDYyOFowSTELMAkGA1UEBhMCSVQxDzANBgNVBAoTBmlkUHNwMTEMMAoGA1UECxMDUFNQMRswGQYD VQQDExIxMjM0NTY3ODkwMSBpZFBzcDEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC9 CxOezioe/5q+h3J7ISvBhAKgATU2DGjzocFNGIczcqPNFlaEMi8zMacO4y9Hx3O9I/4dujCytQnE zZoPaXVndJcEVhoZi5jSWkykADdTZqX+lxNfhGJqsasioVN2ri5IZiTFy22tBDPiJ/z1NrbATRtK pFRuEuPEBm61nt1IMdYOp0+WihWFbzVsB/+0Xde7qpcLkKExPB3NigVYAgGgo/z8Z89FtF9sxgRC AEKCADDZLTCujM/MANhYv7tYCoe81NIYYkOInAfGErv+YnH7RIyVwqkbNhMXavsAgv1Ucd9JUUAV Tw6EzIomsUNqBwtyixSKoHqf/OUnR+Gpuk2NAgMBAAGjgZEwgY4wDgYDVR0PAQH/BAQDAgZAMF0G A1UdIwRWMFSAFFfDfM0VomETCms+4cZJ7E5DH8OHoTmkNzA1MQswCQYDVQQGEwJJVDEOMAwGA1UE ChMFU29nZWkxFjAUBgNVBAMTDUNBIFNvZ2VpIFRlc3SCAQEwHQYDVR0OBBYEFDHd+flzQA5NQALK ZMSdqpr6TF7VMA0GCSqGSIb3DQEBBQUAA4IBAQAIZZpADkFaFF7Up2+xuGkC14CqYBPCQlDqqo// u8pJ/77cQ18jquqoQInw0vEpX3ttRjISlrsHHUT/HAB7I3A9VJwbQ2ezZHOndUBKeBJ5kBYCsTAj LKUc3iakteoaTwQUUqOvUaRqoiZg9W7aBdigzFWq7thYSi1zzegqvQTtvzGqU/Duem7ky1SGe/3D NxpeeU3JGqKxpi2LNg6riVXOuu9mjkIzrT0OkGjcdY+8uF8Ik+wCprjXtsYywHaPWV6gVsj+O8UQ x1ylrl3ssRecQotVzhWdBEV7EvX3gOL3Njs2XMSqCV57wxlKls3yoAcPzHDD5z0cZrTBqT4ln9rK</X509Certificate>
                            <X509CRL>MIIwAzCCLusCAQEwDQYJKoZIhvcNAQEFBQAwNTELMAkGA1UEBhMCSVQxDjAMBgNVBAoTBVNvZ2Vp MRYwFAYDVQQDEw1DQSBTb2dlaSBUZXN0Fw0xNTAyMDUyMzAxMDlaFw0xNTAyMDYyMzA1MDlaMIIu TjA6AgEIFw0xMzA1MjgxMjE5MzhaMCYwGAYDVR0YBBEYDzIwMTMwNTI4MTIxOTAwWjAKBgNVHRUE AwoBBDATAgIApBcNMTMwNjEzMTUwMjIxWjATAgIBJxcNMTMwNzI1MTA0NzQwWjATAgIBJhcNMTMw NzI1MTA0NzUyWjA7AgIBJRcNMTMwOTI1MTQ1NjA3WjAmMBgGA1UdGAQRGA8yMDEzMDkyNTE0NTYw MFowCgYDVR0VBAMKAQQwOwICATQXDTEzMDkyNTE0NTYwOVowJjAYBgNVHRgEERgPMjAxMzA5MjUx NDU2MDBaMAoGA1UdFQQDCgEEMDsCAgE1Fw0xMzA5MjYwOTA2MDFaMCYwGAYDVR0YBBEYDzIwMTMw OTI2MDkwNjAwWjAKBgNVHRUEAwoBBDA7AgIBNhcNMTMwOTI2MDkyOTQ1WjAmMBgGA1UdGAQRGA8y MDEzMDkyNjA5MzAwMFowCgYDVR0VBAMKAQQwOwICATcXDTEzMDkyNjA5Mjk0N1owJjAYBgNVHRgE ERgPMjAxMzA5MjYwOTMwMDBaMAoGA1UdFQQDCgEEMDsCAgE4Fw0xMzA5MjYwOTQ1MjFaMCYwGAYD VR0YBBEYDzIwMTMwOTI2MDk0NjAwWjAKBgNVHRUEAwoBBDA7AgIBORcNMTMwOTI2MTIwNjIxWjAm MBgGA1UdGAQRGA8yMDEzMDkyNjEyMDYwMFowCgYDVR0VBAMKAQQwOwICAToXDTEzMDkyNjEzMTkw NVowJjAYBgNVHRgEERgPMjAxMzA5MjYxMzE5MDBaMAoGA1UdFQQDCgEEMDsCAgE7Fw0xMzA5MjYx MzMzNDdaMCYwGAYDVR0YBBEYDzIwMTMwOTI2MTMzNDAwWjAKBgNVHRUEAwoBBDA7AgIBbBcNMTMx MDA3MTIzOTM4WjAmMBgGA1UdGAQRGA8yMDEzMTAwNzEyMzkwMFowCgYDVR0VBAMKAQQwLwICAbMX DTEzMTAzMTEyMjEwMlowGjAYBgNVHRgEERgPMjAxMzEwMzExMjIxMDBaMC8CAgGyFw0xMzEwMzEx MjIxMjJaMBowGAYDVR0YBBEYDzIwMTMxMDMxMTIyMTAwWjATAgIBtBcNMTMxMDMxMTUwMDUxWjAT AgIBtRcNMTMxMDMxMTUwMDU5WjATAgIBthcNMTMxMDMxMTUwMzAxWjA7AgIDaRcNMTQwNTIwMTY0 NTQ5WjAmMBgGA1UdGAQRGA8yMDE0MDUyMDE2NDYwMFowCgYDVR0VBAMKAQQwOwICA1MXDTEzMTIy MzEzNTYwN1owJjAYBgNVHRgEERgPMjAxMzEyMjMxMzU2MDBaMAoGA1UdFQQDCgEEMBMCAgPGFw0x NDA2MDkxMzE2NDZaMDsCAgNqFw0xNDA1MjAxNjQ1NTFaMCYwGAYDVR0YBBEYDzIwMTQwNTIwMTY0 NjAwWjAKBgNVHRUEAwoBBDA7AgIEfhcNMTQxMDEzMTUwMDA3WjAmMBgGA1UdGAQRGA8yMDE0MTAx MzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBH8XDTE0MTAxMzE1MDAyMVowJjAYBgNVHRgEERgPMjAx NDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSBFw0xNDEwMTMxNTAwMjJaMCYwGAYDVR0YBBEY DzIwMTQxMDEzMTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIEgBcNMTQxMDEzMTUwMDI1WjAmMBgGA1Ud GAQRGA8yMDE0MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBIMXDTE0MTAxMzE1MDAyNlowJjAY BgNVHRgEERgPMjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSCFw0xNDEwMTMxNTAwMjda MCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIEhRcNMTQxMDEzMTUw MDI4WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBIQXDTE0MTAx MzE1MDAzMVowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSGFw0x NDEwMTMxNTAwMzJaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIE hxcNMTQxMDEzMTUwMDMzWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQw OwICBIkXDTE0MTAxMzE1MDAzNFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQD CgEEMDsCAgSNFw0xNDEwMTMxNTAwMzdaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMTAwWjAKBgNV HRUEAwoBBDA7AgIEixcNMTQxMDEzMTUwMDM4WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1MDEwMFow CgYDVR0VBAMKAQQwOwICBIoXDTE0MTAxMzE1MDAzOVowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTAx MDBaMAoGA1UdFQQDCgEEMDsCAgSIFw0xNDEwMTMxNTAwNDFaMCYwGAYDVR0YBBEYDzIwMTQxMDEz MTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIEjBcNMTQxMDEzMTUwMDQzWjAmMBgGA1UdGAQRGA8yMDE0 MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBI4XDTE0MTAxMzE1MDA0NFowJjAYBgNVHRgEERgP MjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSRFw0xNDEwMTMxNTAwNDVaMCYwGAYDVR0Y BBEYDzIwMTQxMDEzMTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIEjxcNMTQxMDEzMTUwMDQ3WjAmMBgG A1UdGAQRGA8yMDE0MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBJUXDTE0MTAxMzE1MDA0OFow JjAYBgNVHRgEERgPMjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSTFw0xNDEwMTMxNTAw NDlaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMjAwWjAKBgNVHRUEAwoBBDA7AgIElBcNMTQxMDEz MTUwMDUxWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1MDIwMFowCgYDVR0VBAMKAQQwOwICBJAXDTE0 MTAxMzE1MDA1M1owJjAYBgNVHRgEERgPMjAxNDEwMTMxNTAyMDBaMAoGA1UdFQQDCgEEMDsCAgSS Fw0xNDEwMTMxNTAwNTVaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMjAwWjAKBgNVHRUEAwoBBDA7 AgIElhcNMTQxMDEzMTU0MTI1WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIwMFowCgYDVR0VBAMK AQQwOwICBJcXDTE0MTAxMzE1NDEyNlowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQyMDBaMAoGA1Ud FQQDCgEEMDsCAgSYFw0xNDEwMTMxNTQxMjZaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAK BgNVHRUEAwoBBDA7AgIEnBcNMTQxMDEzMTU0MTI3WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIw MFowCgYDVR0VBAMKAQQwOwICBK4XDTE0MTAxMzE1NDEzMFowJjAYBgNVHRgEERgPMjAxNDEwMTMx NTQyMDBaMAoGA1UdFQQDCgEEMDsCAgSvFw0xNDEwMTMxNTQxMzBaMCYwGAYDVR0YBBEYDzIwMTQx MDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEsRcNMTQxMDEzMTU0MTMxWjAmMBgGA1UdGAQRGA8y MDE0MTAxMzE1NDIwMFowCgYDVR0VBAMKAQQwOwICBLMXDTE0MTAxMzE1NDEzMlowJjAYBgNVHRgE ERgPMjAxNDEwMTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsCAgSbFw0xNDEwMTMxNTQxMzVaMCYwGAYD VR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEmhcNMTQxMDEzMTU0MTM2WjAm MBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIwMFowCgYDVR0VBAMKAQQwOwICBJkXDTE0MTAxMzE1NDEz N1owJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsCAgSdFw0xNDEwMTMx NTQxMzhaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEtBcNMTQx MDEzMTU0MTQwWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIwMFowCgYDVR0VBAMKAQQwOwICBLAX DTE0MTAxMzE1NDE0MFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsC AgSyFw0xNDEwMTMxNTQxNDJaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoB BDA7AgIEtRcNMTQxMDEzMTU0MTQzWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIwMFowCgYDVR0V BAMKAQQwOwICBJ4XDTE0MTAxMzE1NDE0NFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQyMDBaMAoG A1UdFQQDCgEEMDsCAgSfFw0xNDEwMTMxNTQxNDRaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAw WjAKBgNVHRUEAwoBBDA7AgIEoBcNMTQxMDEzMTU0MTQ3WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1 NDIwMFowCgYDVR0VBAMKAQQwOwICBKMXDTE0MTAxMzE1NDE0OFowJjAYBgNVHRgEERgPMjAxNDEw MTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsCAgS4Fw0xNDEwMTMxNTQxNTBaMCYwGAYDVR0YBBEYDzIw MTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEthcNMTQxMDEzMTU0MTUwWjAmMBgGA1UdGAQR GA8yMDE0MTAxMzE1NDIwMFowCgYDVR0VBAMKAQQwOwICBLcXDTE0MTAxMzE1NDE1MVowJjAYBgNV HRgEERgPMjAxNDEwMTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsCAgS6Fw0xNDEwMTMxNTQxNTJaMCYw GAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEohcNMTQxMDEzMTU0MTU1 WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQwOwICBKEXDTE0MTAxMzE1 NDE1NlowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEEMDsCAgSkFw0xNDEw MTMxNTQxNTZaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUEAwoBBDA7AgIEphcN MTQxMDEzMTU0MTU3WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQwOwIC BLkXDTE0MTAxMzE1NDIwMFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEE MDsCAgS7Fw0xNDEwMTMxNTQyMDBaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUE AwoBBDA7AgIEvRcNMTQxMDEzMTU0MjAxWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYD VR0VBAMKAQQwOwICBLwXDTE0MTAxMzE1NDIwMlowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBa MAoGA1UdFQQDCgEEMDsCAgSoFw0xNDEwMTMxNTQyMDRaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0 MzAwWjAKBgNVHRUEAwoBBDA7AgIEqhcNMTQxMDEzMTU0MjA2WjAmMBgGA1UdGAQRGA8yMDE0MTAx MzE1NDMwMFowCgYDVR0VBAMKAQQwOwICBKUXDTE0MTAxMzE1NDIwNlowJjAYBgNVHRgEERgPMjAx NDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEEMDsCAgSnFw0xNDEwMTMxNTQyMDhaMCYwGAYDVR0YBBEY DzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUEAwoBBDA7AgIEwRcNMTQxMDEzMTU0MjA4WjAmMBgGA1Ud GAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQwOwICBL8XDTE0MTAxMzE1NDIxMFowJjAY BgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEEMDsCAgS+Fw0xNDEwMTMxNTQyMTFa MCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUEAwoBBDA7AgIEwxcNMTQxMDEzMTU0 MjEyWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQwOwICBKkXDTE0MTAx MzE1NDIxM1owJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEEMDsCAgSrFw0x NDEwMTMxNTQyMTRaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUEAwoBBDA7AgIE wBcNMTQxMDEzMTU0MjE1WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQw OwICBK0XDTE0MTAxMzE1NDIxNlowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQD CgEEMDsCAgTCFw0xNDEwMTMxNTQyMThaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNV HRUEAwoBBDA7AgIExRcNMTQxMDEzMTU0MjE4WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFow CgYDVR0VBAMKAQQwOwICBKwXDTE0MTAxMzE1NDIyMFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQz MDBaMAoGA1UdFQQDCgEEMDsCAgTEFw0xNDEwMTMxNTQyMjFaMCYwGAYDVR0YBBEYDzIwMTQxMDEz MTU0MzAwWjAKBgNVHRUEAwoBBDAhAgIEyRcNMTQxMDI5MTMxMDM5WjAMMAoGA1UdFQQDCgEGMBMC AgTMFw0xNDExMDUxNDM3NTlaMBMCAgTNFw0xNDExMDUxNDM4MDZaMBMCAgTOFw0xNDExMDUxNDM4 MTFaMBMCAgTPFw0xNDExMDUxNDM4MTdaMDsCAgGHFw0xNDExMjQxMzI4MTVaMCYwGAYDVR0YBBEY DzIwMTQxMTI0MTMyOTAwWjAKBgNVHRUEAwoBBDA7AgIE5BcNMTQxMTI0MTMyODE3WjAmMBgGA1Ud GAQRGA8yMDE0MTEyNDEzMjkwMFowCgYDVR0VBAMKAQQwOwICBOYXDTE0MTEyNTE2MTM0N1owJjAY BgNVHRgEERgPMjAxNDExMjUxNjE1MDBaMAoGA1UdFQQDCgEEMDsCAgTnFw0xNDExMjUxNjIxMjla MCYwGAYDVR0YBBEYDzIwMTQxMTI1MTYyMjAwWjAKBgNVHRUEAwoBBDA7AgIE6BcNMTQxMTI2MDgy ODUxWjAmMBgGA1UdGAQRGA8yMDE0MTEyNjA4MzAwMFowCgYDVR0VBAMKAQQwOwICBQwXDTE1MDEy NzExMzAyNVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMwMDBaMAoGA1UdFQQDCgEEMDsCAgUNFw0x NTAxMjcxMTMwMjdaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMDAwWjAKBgNVHRUEAwoBBDA7AgIF JBcNMTUwMTI3MTEzMDI5WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzAwMFowCgYDVR0VBAMKAQQw OwICBQ8XDTE1MDEyNzExMzAzMVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMwMDBaMAoGA1UdFQQD CgEEMDsCAgUlFw0xNTAxMjcxMTMwMzVaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMDAwWjAKBgNV HRUEAwoBBDA7AgIFDhcNMTUwMTI3MTEzMDM3WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzAwMFow CgYDVR0VBAMKAQQwOwICBSgXDTE1MDEyNzExMzAzOVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMw MDBaMAoGA1UdFQQDCgEEMDsCAgUQFw0xNTAxMjcxMTMwNDFaMCYwGAYDVR0YBBEYDzIwMTUwMTI3 MTEzMTAwWjAKBgNVHRUEAwoBBDA7AgIFJxcNMTUwMTI3MTEzMDQzWjAmMBgGA1UdGAQRGA8yMDE1 MDEyNzExMzEwMFowCgYDVR0VBAMKAQQwOwICBREXDTE1MDEyNzExMzA0NVowJjAYBgNVHRgEERgP MjAxNTAxMjcxMTMxMDBaMAoGA1UdFQQDCgEEMDsCAgUmFw0xNTAxMjcxMTMwNDdaMCYwGAYDVR0Y BBEYDzIwMTUwMTI3MTEzMTAwWjAKBgNVHRUEAwoBBDA7AgIFEhcNMTUwMTI3MTEzMDUxWjAmMBgG A1UdGAQRGA8yMDE1MDEyNzExMzEwMFowCgYDVR0VBAMKAQQwOwICBSkXDTE1MDEyNzExMzA1M1ow JjAYBgNVHRgEERgPMjAxNTAxMjcxMTMxMDBaMAoGA1UdFQQDCgEEMDsCAgUTFw0xNTAxMjcxMTMw NTVaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMTAwWjAKBgNVHRUEAwoBBDA7AgIFKhcNMTUwMTI3 MTEzMDU3WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzEwMFowCgYDVR0VBAMKAQQwOwICBRQXDTE1 MDEyNzExMzA1OVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMxMDBaMAoGA1UdFQQDCgEEMDsCAgUr Fw0xNTAxMjcxMTMxMDNaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMTAwWjAKBgNVHRUEAwoBBDA7 AgIFFRcNMTUwMTI3MTEzMTA1WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzEwMFowCgYDVR0VBAMK AQQwOwICBSwXDTE1MDEyNzExMzEwN1owJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMxMDBaMAoGA1Ud FQQDCgEEMDsCAgUWFw0xNTAxMjcxMTMxMDlaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMTAwWjAK BgNVHRUEAwoBBDA7AgIFLRcNMTUwMTI3MTEzMTExWjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzEw 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</X509CRL>
                        </X509Data>
                    </KeyInfo>
                </Signature>
            </marcaDaBollo>
            """
        And RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_2_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>idMsgRichiesta</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
            <pay_i:identificativoUnivocoVersante>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoVersante>
            <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
            <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
            <pay_i:civicoVersante>11</pay_i:civicoVersante>
            <pay_i:capVersante>00186</pay_i:capVersante>
            <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
            <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
            <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
            <pay_i:identificativoUnivocoPagatore>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoPagatore>
            <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
            <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
            <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
            <pay_i:capPagatore>00186</pay_i:capPagatore>
            <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
            <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
            <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            </pay_i:soggettoPagatore>
            <pay_i:enteBeneficiario>
            <pay_i:identificativoUnivocoBeneficiario>
            <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoBeneficiario>
            <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
            <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
            <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
            <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
            <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
            <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
            <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
            <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
            <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
            <pay_i:dataEsecuzionePagamento>2016-09-16</pay_i:dataEsecuzionePagamento>
            <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>#iuv#</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT45R0760103200000000001016</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:ibanAppoggio>IT45R0760103200000000001016</pay_i:ibanAppoggio>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            <pay_i:datiMarcaBolloDigitale>
            <pay_i:tipoBollo>01</pay_i:tipoBollo>
            <pay_i:hashDocumento>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</pay_i:hashDocumento>
            <pay_i:provinciaResidenza>MI</pay_i:provinciaResidenza>
            </pay_i:datiMarcaBolloDigitale>
            </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
            </pay_i:RPT>
            """
        And RT generation
            """
            <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRicevuta>TR0001_20120302-10:37:52.0264-F098</pay_i:identificativoMessaggioRicevuta>
            <pay_i:dataOraMessaggioRicevuta>2012-03-02T10:37:52</pay_i:dataOraMessaggioRicevuta>
            <pay_i:riferimentoMessaggioRichiesta>TR0001_20120302-10:37:52.0264-F098</pay_i:riferimentoMessaggioRichiesta>
            <pay_i:riferimentoDataRichiesta>2012-01-26</pay_i:riferimentoDataRichiesta>
            <pay_i:istitutoAttestante>
            <pay_i:identificativoUnivocoAttestante>
            <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>istitutoAttestan</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoAttestante>
            <pay_i:denominazioneAttestante>DenominazioneAttestante</pay_i:denominazioneAttestante>
            <pay_i:codiceUnitOperAttestante>CodiceUOA</pay_i:codiceUnitOperAttestante>
            <pay_i:denomUnitOperAttestante>DenomUnitOperAttestante</pay_i:denomUnitOperAttestante>
            <pay_i:indirizzoAttestante>IndirizzoAttestante</pay_i:indirizzoAttestante>
            <pay_i:civicoAttestante>11</pay_i:civicoAttestante>
            <pay_i:capAttestante>11111</pay_i:capAttestante>
            <pay_i:localitaAttestante>LocalitaAttestante</pay_i:localitaAttestante>
            <pay_i:provinciaAttestante>ProvinciaAttestante</pay_i:provinciaAttestante>
            <pay_i:nazioneAttestante>IT</pay_i:nazioneAttestante>
            </pay_i:istitutoAttestante>
            <pay_i:enteBeneficiario>
            <pay_i:identificativoUnivocoBeneficiario>
            <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoBeneficiario>
            <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
            <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
            <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
            <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
            <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
            <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
            <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
            <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
            <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:soggettoVersante>
            <pay_i:identificativoUnivocoVersante>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501F</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoVersante>
            <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
            <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
            <pay_i:civicoVersante>11</pay_i:civicoVersante>
            <pay_i:capVersante>00186</pay_i:capVersante>
            <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
            <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
            <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
            <pay_i:identificativoUnivocoPagatore>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoPagatore>
            <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
            <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
            <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
            <pay_i:capPagatore>00186</pay_i:capPagatore>
            <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
            <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
            <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:datiPagamento>
            <pay_i:codiceEsitoPagamento>0</pay_i:codiceEsitoPagamento>
            <pay_i:importoTotalePagato>10.00</pay_i:importoTotalePagato>
            <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:CodiceContestoPagamento>CCD01</pay_i:CodiceContestoPagamento>
            <pay_i:datiSingoloPagamento>
            <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
            <pay_i:esitoSingoloPagamento>Pagamento effettuato</pay_i:esitoSingoloPagamento>
            <pay_i:dataEsitoSingoloPagamento>2012-03-02</pay_i:dataEsitoSingoloPagamento>
            <pay_i:identificativoUnivocoRiscossione>$iuv</pay_i:identificativoUnivocoRiscossione>
            <pay_i:causaleVersamento>pagamento fotocopie pratica RT</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            <pay_i:allegatoRicevuta>
            <pay_i:tipoAllegatoRicevuta>BD</pay_i:tipoAllegatoRicevuta>
            <pay_i:testoAllegato>$bollo</pay_i:testoAllegato>
            </pay_i:allegatoRicevuta>
            </pay_i:datiSingoloPagamento>
            </pay_i:datiPagamento>
            </pay_i:RT>
            """
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#id_broker_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canaleRtPull_sec#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML pspInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspInviaRPTResponse>
            <pspInviaRPTResponse>
            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
            <identificativoCarrello>$nodoInviaRPT.identificativoUnivocoVersamento</identificativoCarrello>
            <parametriPagamentoImmediato>idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento</parametriPagamentoImmediato>
            </pspInviaRPTResponse>
            </ws:pspInviaRPTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML pspChiediListaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspChiediListaRTResponse>
            <pspChiediListaRTResponse>
            <elementoListaRTResponse>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            </elementoListaRTResponse>
            </pspChiediListaRTResponse>
            </ws:pspChiediListaRTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML pspChiediRT
            """
            <soapenv:Envelope
            xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspChiediRTResponse>
            <pspChiediRTResponse>
            <rt>$rtAttachment</rt>
            </pspChiediRTResponse>
            </ws:pspChiediRTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paaInviaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaInviaRTRisposta>
            <paaInviaRTRisposta>
            <esito>OK</esito>
            </paaInviaRTRisposta>
            </ws:paaInviaRTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    #clean pspRetryAckNegative queue
    Scenario: Execute pspRetryAckNegative job
        Given nodo-dei-pagamenti has config parameter scheduler.pspRetryAckNegativePollerMaxRetry set to 1
        When job pspRetryAckNegative triggered after 5 seconds
        Then wait 5 seconds for expiration


    #Retry ACK timeout step1
    Scenario: Execute nodoInviaRPT_timeout
        Given the Execute pspRetryAckNegative job scenario executed successfully
        And nodo-dei-pagamenti has config parameter scheduler.jobName_pspRetryAckNegative.enabled set to false
        And initial XML pspInviaAckRT
            """
            <soapenv:Envelope
            xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspInviaAckRTResponse>
            <pspInviaAckRTResponse>
            <esito>timeout</esito>
            </pspInviaAckRTResponse>
            </ws:pspInviaAckRTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaAckRT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 5 seconds
        Then check esito is OK of nodoInviaRPT response
        And wait 10 seconds for expiration

    @runnable
    #Retry ACK timeout step2
    Scenario: Retry ack timeout
        Given the Execute nodoInviaRPT_timeout scenario executed successfully 
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaAckRT
        And nodo-dei-pagamenti has config parameter scheduler.jobName_pspRetryAckNegative.enabled set to true

        When job pspRetryAckNegative triggered after 5 seconds
        Then wait 10 seconds for expiration
        And execution query getSchedulerPspRetryAckNegativePollerMaxRetry to get value on the table CONFIGURATION_KEYS, with the columns CONFIG_VALUE under macro RTPull with db name nodo_cfg
        And through the query getSchedulerPspRetryAckNegativePollerMaxRetry retrieve param schedulerPspRetryAckNegativePollerMaxRetry at position 0 and save it under the key schedulerPspRetryAckNegativePollerMaxRetry
        And replace ccp content with $nodoInviaRPT.codiceContestoPagamento content
        And execution query by_iuv_and_ccp to get value on the table RETRY_PSP_ACK, with the columns RETRY under macro RTPull with db name nodo_online
        And through the query by_iuv_and_ccp retrieve param retry at position 0 and save it under the key retry
        And check value $schedulerPspRetryAckNegativePollerMaxRetry is equal to value $retry
        #And generic update through the query param_update_generic_where_condition of the table CANALI the parameter PROTOCOLLO = 'HTTPS', with where condition ID_CANALE like '6000%' under macro update_query on db nodo_cfg
        #And refresh job PSP triggered after 10 seconds
        #And wait 10 seconds for expiration
        And restore initial configurations

    #Retry ACK system error step1
    Scenario: Execute nodoInviaRPT_systemError
        Given the Execute pspRetryAckNegative job scenario executed successfully
        And nodo-dei-pagamenti has config parameter scheduler.jobName_pspRetryAckNegative.enabled set to false
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And initial XML pspInviaAckRT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:pspInviaAckRTResponse>
                <pspInviaAckRTResponse>
                    <fault>
                    <faultCode>CANALE_SYSTEM_ERROR</faultCode>
                    <faultString>system error</faultString>
                    <id>wrapper</id>
                    </fault>
                    <esito>KO</esito>
                </pspInviaAckRTResponse>
            </ws:pspInviaAckRTResponse>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaAckRT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 5 seconds
        Then check esito is OK of nodoInviaRPT response
        And wait 10 seconds for expiration

    @runnable
    #Retry ACK system error step2
    Scenario: Retry ack system error
        Given the Execute nodoInviaRPT_systemError scenario executed successfully
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaAckRT
        And nodo-dei-pagamenti has config parameter scheduler.jobName_pspRetryAckNegative.enabled set to true
        When job pspRetryAckNegative triggered after 5 seconds
        Then wait 10 seconds for expiration
        And execution query getSchedulerPspRetryAckNegativePollerMaxRetry to get value on the table CONFIGURATION_KEYS, with the columns CONFIG_VALUE under macro RTPull with db name nodo_cfg
        And through the query getSchedulerPspRetryAckNegativePollerMaxRetry retrieve param schedulerPspRetryAckNegativePollerMaxRetry at position 0 and save it under the key schedulerPspRetryAckNegativePollerMaxRetry
        And replace ccp content with $nodoInviaRPT.codiceContestoPagamento content
        And execution query by_iuv_and_ccp to get value on the table RETRY_PSP_ACK, with the columns RETRY under macro RTPull with db name nodo_online
        And through the query by_iuv_and_ccp retrieve param retry at position 0 and save it under the key retry
        And check value $schedulerPspRetryAckNegativePollerMaxRetry is equal to value $retry
        #And generic update through the query param_update_generic_where_condition of the table CANALI the parameter PROTOCOLLO = 'HTTPS', with where condition ID_CANALE like '6000%' under macro update_query on db nodo_cfg
        #And refresh job PSP triggered after 10 seconds
        #And wait 10 seconds for expiration
        And restore initial configurations


    #Retry ACK malformed step1
    Scenario: Execute nodoInviaRPT_malformed
        Given the Execute pspRetryAckNegative job scenario executed successfully
        And nodo-dei-pagamenti has config parameter scheduler.jobName_pspRetryAckNegative.enabled set to false
        And initial XML pspInviaAckRT
            """
            <soapenv:Envelope
            xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspInviaAckRTResponse>
            <pspInviaAckRTResponse>
            </pspInviaAckRTResponse>
            </ws:pspInviaAckRTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaAckRT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 5 seconds
        Then check esito is OK of nodoInviaRPT response
        And wait 10 seconds for expiration

    @runnable
    #Retry ACK malformed step2
    Scenario: Retry ack malformed
        Given the Execute nodoInviaRPT_malformed scenario executed successfully 
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaAckRT
        And nodo-dei-pagamenti has config parameter scheduler.jobName_pspRetryAckNegative.enabled set to true
        When job pspRetryAckNegative triggered after 5 seconds
        Then wait 10 seconds for expiration
        And execution query getSchedulerPspRetryAckNegativePollerMaxRetry to get value on the table CONFIGURATION_KEYS, with the columns CONFIG_VALUE under macro RTPull with db name nodo_cfg
        And through the query getSchedulerPspRetryAckNegativePollerMaxRetry retrieve param schedulerPspRetryAckNegativePollerMaxRetry at position 0 and save it under the key schedulerPspRetryAckNegativePollerMaxRetry
        And replace ccp content with $nodoInviaRPT.codiceContestoPagamento content
        And execution query by_iuv_and_ccp to get value on the table RETRY_PSP_ACK, with the columns RETRY under macro RTPull with db name nodo_online
        And through the query by_iuv_and_ccp retrieve param retry at position 0 and save it under the key retry
        And check value $schedulerPspRetryAckNegativePollerMaxRetry is equal to value $retry
        #And generic update through the query param_update_generic_where_condition of the table CANALI the parameter PROTOCOLLO = 'HTTPS', with where condition ID_CANALE like '6000%' under macro update_query on db nodo_cfg
        #And refresh job PSP triggered after 10 seconds
        #And wait 10 seconds for expiration
        And restore initial configurations


    #Retry ACK syntax KO step1
    Scenario: Execute nodoInviaRPT_synKO
        Given the Execute pspRetryAckNegative job scenario executed successfully
        And nodo-dei-pagamenti has config parameter scheduler.jobName_pspRetryAckNegative.enabled set to false
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And initial XML pspInviaAckRT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:pspInviaAckRTResponse>
                <pspInviaAckRTResponse>
                    <fault>
                    <faultCode>CANALE_SINTASSI_XSD</faultCode>
                    <faultString>Errore di sintassi</faultString>
                    <id>#psp#</id>
                    <description>?</description>
                    </fault>
                    <esito>KO</esito>
                </pspInviaAckRTResponse>
            </ws:pspInviaAckRTResponse>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaAckRT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 5 seconds
        Then check esito is OK of nodoInviaRPT response
        And wait 15 seconds for expiration

    @runnable
    #Retry ACK syntax KO step2
    Scenario: Retry ack syntax KO
        Given the Execute nodoInviaRPT_synKO scenario executed successfully
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaAckRT
        And nodo-dei-pagamenti has config parameter scheduler.jobName_pspRetryAckNegative.enabled set to true
        When job pspRetryAckNegative triggered after 5 seconds
        Then wait 15 seconds for expiration
        And execution query getSchedulerPspRetryAckNegativePollerMaxRetry to get value on the table CONFIGURATION_KEYS, with the columns CONFIG_VALUE under macro RTPull with db name nodo_cfg
        And through the query getSchedulerPspRetryAckNegativePollerMaxRetry retrieve param schedulerPspRetryAckNegativePollerMaxRetry at position 0 and save it under the key schedulerPspRetryAckNegativePollerMaxRetry
        And replace ccp content with $nodoInviaRPT.codiceContestoPagamento content
        And execution query by_iuv_and_ccp to get value on the table RETRY_PSP_ACK, with the columns RETRY under macro RTPull with db name nodo_online
        And through the query by_iuv_and_ccp retrieve param retry at position 0 and save it under the key retry
        And check value $schedulerPspRetryAckNegativePollerMaxRetry is equal to value $retry
        #And generic update through the query param_update_generic_where_condition of the table CANALI the parameter PROTOCOLLO = 'HTTPS', with where condition ID_CANALE like '6000%' under macro update_query on db nodo_cfg
        #And refresh job PSP triggered after 10 seconds
        #And wait 10 seconds for expiration
        And restore initial configurations
    