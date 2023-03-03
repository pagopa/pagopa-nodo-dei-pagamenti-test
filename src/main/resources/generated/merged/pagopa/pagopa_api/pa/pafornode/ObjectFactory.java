
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the merged.pagopa.pagopa_api.pa.pafornode package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _PaVerifyPaymentNoticeReq_QNAME = new QName("http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", "paVerifyPaymentNoticeReq");
    private final static QName _PaVerifyPaymentNoticeRes_QNAME = new QName("http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", "paVerifyPaymentNoticeRes");
    private final static QName _PaGetPaymentReq_QNAME = new QName("http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", "paGetPaymentReq");
    private final static QName _PaGetPaymentRes_QNAME = new QName("http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", "paGetPaymentRes");
    private final static QName _PaSendRTReq_QNAME = new QName("http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", "paSendRTReq");
    private final static QName _PaSendRTRes_QNAME = new QName("http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", "paSendRTRes");
    private final static QName _PaDemandPaymentNoticeRequest_QNAME = new QName("http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", "paDemandPaymentNoticeRequest");
    private final static QName _PaDemandPaymentNoticeResponse_QNAME = new QName("http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", "paDemandPaymentNoticeResponse");
    private final static QName _PaGetPaymentV2Request_QNAME = new QName("http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", "paGetPaymentV2Request");
    private final static QName _PaGetPaymentV2Response_QNAME = new QName("http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", "paGetPaymentV2Response");
    private final static QName _PaSendRTV2Request_QNAME = new QName("http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", "paSendRTV2Request");
    private final static QName _PaSendRTV2Response_QNAME = new QName("http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", "paSendRTV2Response");
    private final static QName _PaaVerificaRPT_QNAME = new QName("http://ws.pagamenti.telematici.gov/", "paaVerificaRPT");
    private final static QName _PaaVerificaRPTRisposta_QNAME = new QName("http://ws.pagamenti.telematici.gov/", "paaVerificaRPTRisposta");
    private final static QName _PaaAttivaRPT_QNAME = new QName("http://ws.pagamenti.telematici.gov/", "paaAttivaRPT");
    private final static QName _PaaAttivaRPTRisposta_QNAME = new QName("http://ws.pagamenti.telematici.gov/", "paaAttivaRPTRisposta");
    private final static QName _RPT_QNAME = new QName("http://www.digitpa.gov.it/schemas/2011/Pagamenti/", "RPT");
    private final static QName _RT_QNAME = new QName("http://www.digitpa.gov.it/schemas/2011/Pagamenti/", "RT");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: merged.pagopa.pagopa_api.pa.pafornode
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link PaVerifyPaymentNoticeReq }
     * 
     */
    public PaVerifyPaymentNoticeReq createPaVerifyPaymentNoticeReq() {
        return new PaVerifyPaymentNoticeReq();
    }

    /**
     * Create an instance of {@link PaVerifyPaymentNoticeRes }
     * 
     */
    public PaVerifyPaymentNoticeRes createPaVerifyPaymentNoticeRes() {
        return new PaVerifyPaymentNoticeRes();
    }

    /**
     * Create an instance of {@link PaGetPaymentReq }
     * 
     */
    public PaGetPaymentReq createPaGetPaymentReq() {
        return new PaGetPaymentReq();
    }

    /**
     * Create an instance of {@link PaGetPaymentRes }
     * 
     */
    public PaGetPaymentRes createPaGetPaymentRes() {
        return new PaGetPaymentRes();
    }

    /**
     * Create an instance of {@link PaSendRTReq }
     * 
     */
    public PaSendRTReq createPaSendRTReq() {
        return new PaSendRTReq();
    }

    /**
     * Create an instance of {@link PaSendRTRes }
     * 
     */
    public PaSendRTRes createPaSendRTRes() {
        return new PaSendRTRes();
    }

    /**
     * Create an instance of {@link PaDemandPaymentNoticeRequest }
     * 
     */
    public PaDemandPaymentNoticeRequest createPaDemandPaymentNoticeRequest() {
        return new PaDemandPaymentNoticeRequest();
    }

    /**
     * Create an instance of {@link PaDemandPaymentNoticeResponse }
     * 
     */
    public PaDemandPaymentNoticeResponse createPaDemandPaymentNoticeResponse() {
        return new PaDemandPaymentNoticeResponse();
    }

    /**
     * Create an instance of {@link PaGetPaymentV2Request }
     * 
     */
    public PaGetPaymentV2Request createPaGetPaymentV2Request() {
        return new PaGetPaymentV2Request();
    }

    /**
     * Create an instance of {@link PaGetPaymentV2Response }
     * 
     */
    public PaGetPaymentV2Response createPaGetPaymentV2Response() {
        return new PaGetPaymentV2Response();
    }

    /**
     * Create an instance of {@link PaSendRTV2Request }
     * 
     */
    public PaSendRTV2Request createPaSendRTV2Request() {
        return new PaSendRTV2Request();
    }

    /**
     * Create an instance of {@link PaSendRTV2Response }
     * 
     */
    public PaSendRTV2Response createPaSendRTV2Response() {
        return new PaSendRTV2Response();
    }

    /**
     * Create an instance of {@link CtEntityUniqueIdentifier }
     * 
     */
    public CtEntityUniqueIdentifier createCtEntityUniqueIdentifier() {
        return new CtEntityUniqueIdentifier();
    }

    /**
     * Create an instance of {@link CtPaymentOptionDescriptionPA }
     * 
     */
    public CtPaymentOptionDescriptionPA createCtPaymentOptionDescriptionPA() {
        return new CtPaymentOptionDescriptionPA();
    }

    /**
     * Create an instance of {@link CtPaymentOptionsDescriptionListPA }
     * 
     */
    public CtPaymentOptionsDescriptionListPA createCtPaymentOptionsDescriptionListPA() {
        return new CtPaymentOptionsDescriptionListPA();
    }

    /**
     * Create an instance of {@link CtTransferPA }
     * 
     */
    public CtTransferPA createCtTransferPA() {
        return new CtTransferPA();
    }

    /**
     * Create an instance of {@link CtTransferListPA }
     * 
     */
    public CtTransferListPA createCtTransferListPA() {
        return new CtTransferListPA();
    }

    /**
     * Create an instance of {@link CtQrCode }
     * 
     */
    public CtQrCode createCtQrCode() {
        return new CtQrCode();
    }

    /**
     * Create an instance of {@link CtSubject }
     * 
     */
    public CtSubject createCtSubject() {
        return new CtSubject();
    }

    /**
     * Create an instance of {@link CtPaymentPA }
     * 
     */
    public CtPaymentPA createCtPaymentPA() {
        return new CtPaymentPA();
    }

    /**
     * Create an instance of {@link CtReceipt }
     * 
     */
    public CtReceipt createCtReceipt() {
        return new CtReceipt();
    }

    /**
     * Create an instance of {@link CtReceiptV2 }
     * 
     */
    public CtReceiptV2 createCtReceiptV2() {
        return new CtReceiptV2();
    }

    /**
     * Create an instance of {@link CtTransferPAV2 }
     * 
     */
    public CtTransferPAV2 createCtTransferPAV2() {
        return new CtTransferPAV2();
    }

    /**
     * Create an instance of {@link CtTransferPAReceiptV2 }
     * 
     */
    public CtTransferPAReceiptV2 createCtTransferPAReceiptV2() {
        return new CtTransferPAReceiptV2();
    }

    /**
     * Create an instance of {@link CtTransferListPAReceiptV2 }
     * 
     */
    public CtTransferListPAReceiptV2 createCtTransferListPAReceiptV2() {
        return new CtTransferListPAReceiptV2();
    }

    /**
     * Create an instance of {@link CtTransferListPAV2 }
     * 
     */
    public CtTransferListPAV2 createCtTransferListPAV2() {
        return new CtTransferListPAV2();
    }

    /**
     * Create an instance of {@link CtPaymentPAV2 }
     * 
     */
    public CtPaymentPAV2 createCtPaymentPAV2() {
        return new CtPaymentPAV2();
    }

    /**
     * Create an instance of {@link CtRichiestaMarcaDaBollo }
     * 
     */
    public CtRichiestaMarcaDaBollo createCtRichiestaMarcaDaBollo() {
        return new CtRichiestaMarcaDaBollo();
    }

    /**
     * Create an instance of {@link CtMapEntry }
     * 
     */
    public CtMapEntry createCtMapEntry() {
        return new CtMapEntry();
    }

    /**
     * Create an instance of {@link CtMetadata }
     * 
     */
    public CtMetadata createCtMetadata() {
        return new CtMetadata();
    }

    /**
     * Create an instance of {@link CtFaultBean }
     * 
     */
    public CtFaultBean createCtFaultBean() {
        return new CtFaultBean();
    }

    /**
     * Create an instance of {@link CtResponse }
     * 
     */
    public CtResponse createCtResponse() {
        return new CtResponse();
    }

    /**
     * Create an instance of {@link CtRisposta }
     * 
     */
    public CtRisposta createCtRisposta() {
        return new CtRisposta();
    }

    /**
     * Create an instance of {@link PaaVerificaRPT }
     * 
     */
    public PaaVerificaRPT createPaaVerificaRPT() {
        return new PaaVerificaRPT();
    }

    /**
     * Create an instance of {@link PaaVerificaRPTRisposta }
     * 
     */
    public PaaVerificaRPTRisposta createPaaVerificaRPTRisposta() {
        return new PaaVerificaRPTRisposta();
    }

    /**
     * Create an instance of {@link PaaAttivaRPT }
     * 
     */
    public PaaAttivaRPT createPaaAttivaRPT() {
        return new PaaAttivaRPT();
    }

    /**
     * Create an instance of {@link PaaAttivaRPTRisposta }
     * 
     */
    public PaaAttivaRPTRisposta createPaaAttivaRPTRisposta() {
        return new PaaAttivaRPTRisposta();
    }

    /**
     * Create an instance of {@link CtPeriodoRiferimento }
     * 
     */
    public CtPeriodoRiferimento createCtPeriodoRiferimento() {
        return new CtPeriodoRiferimento();
    }

    /**
     * Create an instance of {@link CtSpezzoniCausaleVersamento }
     * 
     */
    public CtSpezzoniCausaleVersamento createCtSpezzoniCausaleVersamento() {
        return new CtSpezzoniCausaleVersamento();
    }

    /**
     * Create an instance of {@link CtSpezzoneStrutturatoCausaleVersamento }
     * 
     */
    public CtSpezzoneStrutturatoCausaleVersamento createCtSpezzoneStrutturatoCausaleVersamento() {
        return new CtSpezzoneStrutturatoCausaleVersamento();
    }

    /**
     * Create an instance of {@link PaaTipoDatiPagamentoPA }
     * 
     */
    public PaaTipoDatiPagamentoPA createPaaTipoDatiPagamentoPA() {
        return new PaaTipoDatiPagamentoPA();
    }

    /**
     * Create an instance of {@link PaaTipoDatiPagamentoPSP }
     * 
     */
    public PaaTipoDatiPagamentoPSP createPaaTipoDatiPagamentoPSP() {
        return new PaaTipoDatiPagamentoPSP();
    }

    /**
     * Create an instance of {@link EsitoVerificaRPT }
     * 
     */
    public EsitoVerificaRPT createEsitoVerificaRPT() {
        return new EsitoVerificaRPT();
    }

    /**
     * Create an instance of {@link EsitoAttivaRPT }
     * 
     */
    public EsitoAttivaRPT createEsitoAttivaRPT() {
        return new EsitoAttivaRPT();
    }

    /**
     * Create an instance of {@link Risposta }
     * 
     */
    public Risposta createRisposta() {
        return new Risposta();
    }

    /**
     * Create an instance of {@link FaultBean }
     * 
     */
    public FaultBean createFaultBean() {
        return new FaultBean();
    }

    /**
     * Create an instance of {@link CtRichiestaPagamentoTelematico }
     * 
     */
    public CtRichiestaPagamentoTelematico createCtRichiestaPagamentoTelematico() {
        return new CtRichiestaPagamentoTelematico();
    }

    /**
     * Create an instance of {@link CtRicevutaTelematica }
     * 
     */
    public CtRicevutaTelematica createCtRicevutaTelematica() {
        return new CtRicevutaTelematica();
    }

    /**
     * Create an instance of {@link CtDominio }
     * 
     */
    public CtDominio createCtDominio() {
        return new CtDominio();
    }

    /**
     * Create an instance of {@link CtDatiMarcaBolloDigitale }
     * 
     */
    public CtDatiMarcaBolloDigitale createCtDatiMarcaBolloDigitale() {
        return new CtDatiMarcaBolloDigitale();
    }

    /**
     * Create an instance of {@link CtAllegatoRicevuta }
     * 
     */
    public CtAllegatoRicevuta createCtAllegatoRicevuta() {
        return new CtAllegatoRicevuta();
    }

    /**
     * Create an instance of {@link CtIdentificativoUnivoco }
     * 
     */
    public CtIdentificativoUnivoco createCtIdentificativoUnivoco() {
        return new CtIdentificativoUnivoco();
    }

    /**
     * Create an instance of {@link CtIdentificativoUnivocoPersonaFG }
     * 
     */
    public CtIdentificativoUnivocoPersonaFG createCtIdentificativoUnivocoPersonaFG() {
        return new CtIdentificativoUnivocoPersonaFG();
    }

    /**
     * Create an instance of {@link CtIdentificativoUnivocoPersonaG }
     * 
     */
    public CtIdentificativoUnivocoPersonaG createCtIdentificativoUnivocoPersonaG() {
        return new CtIdentificativoUnivocoPersonaG();
    }

    /**
     * Create an instance of {@link CtSoggettoVersante }
     * 
     */
    public CtSoggettoVersante createCtSoggettoVersante() {
        return new CtSoggettoVersante();
    }

    /**
     * Create an instance of {@link CtSoggettoPagatore }
     * 
     */
    public CtSoggettoPagatore createCtSoggettoPagatore() {
        return new CtSoggettoPagatore();
    }

    /**
     * Create an instance of {@link CtEnteBeneficiario }
     * 
     */
    public CtEnteBeneficiario createCtEnteBeneficiario() {
        return new CtEnteBeneficiario();
    }

    /**
     * Create an instance of {@link CtIstitutoAttestante }
     * 
     */
    public CtIstitutoAttestante createCtIstitutoAttestante() {
        return new CtIstitutoAttestante();
    }

    /**
     * Create an instance of {@link CtDatiSingoloVersamentoRPT }
     * 
     */
    public CtDatiSingoloVersamentoRPT createCtDatiSingoloVersamentoRPT() {
        return new CtDatiSingoloVersamentoRPT();
    }

    /**
     * Create an instance of {@link CtDatiVersamentoRPT }
     * 
     */
    public CtDatiVersamentoRPT createCtDatiVersamentoRPT() {
        return new CtDatiVersamentoRPT();
    }

    /**
     * Create an instance of {@link CtDatiSingoloPagamentoRT }
     * 
     */
    public CtDatiSingoloPagamentoRT createCtDatiSingoloPagamentoRT() {
        return new CtDatiSingoloPagamentoRT();
    }

    /**
     * Create an instance of {@link CtDatiVersamentoRT }
     * 
     */
    public CtDatiVersamentoRT createCtDatiVersamentoRT() {
        return new CtDatiVersamentoRT();
    }

    /**
     * Create an instance of {@link IntestazionePPT }
     * 
     */
    public IntestazionePPT createIntestazionePPT() {
        return new IntestazionePPT();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaVerifyPaymentNoticeReq }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paVerifyPaymentNoticeReq")
    public JAXBElement<PaVerifyPaymentNoticeReq> createPaVerifyPaymentNoticeReq(PaVerifyPaymentNoticeReq value) {
        return new JAXBElement<PaVerifyPaymentNoticeReq>(_PaVerifyPaymentNoticeReq_QNAME, PaVerifyPaymentNoticeReq.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaVerifyPaymentNoticeRes }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paVerifyPaymentNoticeRes")
    public JAXBElement<PaVerifyPaymentNoticeRes> createPaVerifyPaymentNoticeRes(PaVerifyPaymentNoticeRes value) {
        return new JAXBElement<PaVerifyPaymentNoticeRes>(_PaVerifyPaymentNoticeRes_QNAME, PaVerifyPaymentNoticeRes.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaGetPaymentReq }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paGetPaymentReq")
    public JAXBElement<PaGetPaymentReq> createPaGetPaymentReq(PaGetPaymentReq value) {
        return new JAXBElement<PaGetPaymentReq>(_PaGetPaymentReq_QNAME, PaGetPaymentReq.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaGetPaymentRes }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paGetPaymentRes")
    public JAXBElement<PaGetPaymentRes> createPaGetPaymentRes(PaGetPaymentRes value) {
        return new JAXBElement<PaGetPaymentRes>(_PaGetPaymentRes_QNAME, PaGetPaymentRes.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaSendRTReq }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paSendRTReq")
    public JAXBElement<PaSendRTReq> createPaSendRTReq(PaSendRTReq value) {
        return new JAXBElement<PaSendRTReq>(_PaSendRTReq_QNAME, PaSendRTReq.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaSendRTRes }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paSendRTRes")
    public JAXBElement<PaSendRTRes> createPaSendRTRes(PaSendRTRes value) {
        return new JAXBElement<PaSendRTRes>(_PaSendRTRes_QNAME, PaSendRTRes.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaDemandPaymentNoticeRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paDemandPaymentNoticeRequest")
    public JAXBElement<PaDemandPaymentNoticeRequest> createPaDemandPaymentNoticeRequest(PaDemandPaymentNoticeRequest value) {
        return new JAXBElement<PaDemandPaymentNoticeRequest>(_PaDemandPaymentNoticeRequest_QNAME, PaDemandPaymentNoticeRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaDemandPaymentNoticeResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paDemandPaymentNoticeResponse")
    public JAXBElement<PaDemandPaymentNoticeResponse> createPaDemandPaymentNoticeResponse(PaDemandPaymentNoticeResponse value) {
        return new JAXBElement<PaDemandPaymentNoticeResponse>(_PaDemandPaymentNoticeResponse_QNAME, PaDemandPaymentNoticeResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaGetPaymentV2Request }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paGetPaymentV2Request")
    public JAXBElement<PaGetPaymentV2Request> createPaGetPaymentV2Request(PaGetPaymentV2Request value) {
        return new JAXBElement<PaGetPaymentV2Request>(_PaGetPaymentV2Request_QNAME, PaGetPaymentV2Request.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaGetPaymentV2Response }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paGetPaymentV2Response")
    public JAXBElement<PaGetPaymentV2Response> createPaGetPaymentV2Response(PaGetPaymentV2Response value) {
        return new JAXBElement<PaGetPaymentV2Response>(_PaGetPaymentV2Response_QNAME, PaGetPaymentV2Response.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaSendRTV2Request }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paSendRTV2Request")
    public JAXBElement<PaSendRTV2Request> createPaSendRTV2Request(PaSendRTV2Request value) {
        return new JAXBElement<PaSendRTV2Request>(_PaSendRTV2Request_QNAME, PaSendRTV2Request.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaSendRTV2Response }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paSendRTV2Response")
    public JAXBElement<PaSendRTV2Response> createPaSendRTV2Response(PaSendRTV2Response value) {
        return new JAXBElement<PaSendRTV2Response>(_PaSendRTV2Response_QNAME, PaSendRTV2Response.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaaVerificaRPT }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ws.pagamenti.telematici.gov/", name = "paaVerificaRPT")
    public JAXBElement<PaaVerificaRPT> createPaaVerificaRPT(PaaVerificaRPT value) {
        return new JAXBElement<PaaVerificaRPT>(_PaaVerificaRPT_QNAME, PaaVerificaRPT.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaaVerificaRPTRisposta }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ws.pagamenti.telematici.gov/", name = "paaVerificaRPTRisposta")
    public JAXBElement<PaaVerificaRPTRisposta> createPaaVerificaRPTRisposta(PaaVerificaRPTRisposta value) {
        return new JAXBElement<PaaVerificaRPTRisposta>(_PaaVerificaRPTRisposta_QNAME, PaaVerificaRPTRisposta.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaaAttivaRPT }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ws.pagamenti.telematici.gov/", name = "paaAttivaRPT")
    public JAXBElement<PaaAttivaRPT> createPaaAttivaRPT(PaaAttivaRPT value) {
        return new JAXBElement<PaaAttivaRPT>(_PaaAttivaRPT_QNAME, PaaAttivaRPT.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaaAttivaRPTRisposta }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ws.pagamenti.telematici.gov/", name = "paaAttivaRPTRisposta")
    public JAXBElement<PaaAttivaRPTRisposta> createPaaAttivaRPTRisposta(PaaAttivaRPTRisposta value) {
        return new JAXBElement<PaaAttivaRPTRisposta>(_PaaAttivaRPTRisposta_QNAME, PaaAttivaRPTRisposta.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CtRichiestaPagamentoTelematico }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", name = "RPT")
    public JAXBElement<CtRichiestaPagamentoTelematico> createRPT(CtRichiestaPagamentoTelematico value) {
        return new JAXBElement<CtRichiestaPagamentoTelematico>(_RPT_QNAME, CtRichiestaPagamentoTelematico.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CtRicevutaTelematica }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", name = "RT")
    public JAXBElement<CtRicevutaTelematica> createRT(CtRicevutaTelematica value) {
        return new JAXBElement<CtRicevutaTelematica>(_RT_QNAME, CtRicevutaTelematica.class, null, value);
    }

}
