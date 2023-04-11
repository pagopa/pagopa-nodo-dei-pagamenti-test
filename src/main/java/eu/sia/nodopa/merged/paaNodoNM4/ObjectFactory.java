
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the eu.sia.nodopa.merged.paaNodoNM4 package. 
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
    private final static QName _RPT_QNAME = new QName("http://www.digitpa.gov.it/schemas/2011/Pagamenti/", "RPT");
    private final static QName _RT_QNAME = new QName("http://www.digitpa.gov.it/schemas/2011/Pagamenti/", "RT");
    private final static QName _PaaChiediNumeroAvviso_QNAME = new QName("http://ws.pagamenti.telematici.gov/", "paaChiediNumeroAvviso");
    private final static QName _PaaChiediNumeroAvvisoRisposta_QNAME = new QName("http://ws.pagamenti.telematici.gov/", "paaChiediNumeroAvvisoRisposta");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: eu.sia.nodopa.merged.paaNodoNM4
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
     * Create an instance of {@link CtEntityUniqueIdentifier }
     * 
     */
    public CtEntityUniqueIdentifier createCtEntityUniqueIdentifier() {
        return new CtEntityUniqueIdentifier();
    }

    /**
     * Create an instance of {@link CtResponse }
     * 
     */
    public CtResponse createCtResponse() {
        return new CtResponse();
    }

    /**
     * Create an instance of {@link CtFaultBean }
     * 
     */
    public CtFaultBean createCtFaultBean() {
        return new CtFaultBean();
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
     * Create an instance of {@link PaaChiediNumeroAvviso }
     * 
     */
    public PaaChiediNumeroAvviso createPaaChiediNumeroAvviso() {
        return new PaaChiediNumeroAvviso();
    }

    /**
     * Create an instance of {@link PaaChiediNumeroAvvisoRisposta }
     * 
     */
    public PaaChiediNumeroAvvisoRisposta createPaaChiediNumeroAvvisoRisposta() {
        return new PaaChiediNumeroAvvisoRisposta();
    }

    /**
     * Create an instance of {@link CtNumeroAvviso }
     * 
     */
    public CtNumeroAvviso createCtNumeroAvviso() {
        return new CtNumeroAvviso();
    }

    /**
     * Create an instance of {@link CtFaultBean2 }
     * 
     */
    public CtFaultBean2 createCtFaultBean2() {
        return new CtFaultBean2();
    }

    /**
     * Create an instance of {@link CtRisposta }
     * 
     */
    public CtRisposta createCtRisposta() {
        return new CtRisposta();
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
     * Create an instance of {@link CtDatiPagamentoPA }
     * 
     */
    public CtDatiPagamentoPA createCtDatiPagamentoPA() {
        return new CtDatiPagamentoPA();
    }

    /**
     * Create an instance of {@link CtEsitoChiediNumeroAvviso }
     * 
     */
    public CtEsitoChiediNumeroAvviso createCtEsitoChiediNumeroAvviso() {
        return new CtEsitoChiediNumeroAvviso();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaVerifyPaymentNoticeReq }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link PaVerifyPaymentNoticeReq }{@code >}
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paVerifyPaymentNoticeReq")
    public JAXBElement<PaVerifyPaymentNoticeReq> createPaVerifyPaymentNoticeReq(PaVerifyPaymentNoticeReq value) {
        return new JAXBElement<PaVerifyPaymentNoticeReq>(_PaVerifyPaymentNoticeReq_QNAME, PaVerifyPaymentNoticeReq.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaVerifyPaymentNoticeRes }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link PaVerifyPaymentNoticeRes }{@code >}
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paVerifyPaymentNoticeRes")
    public JAXBElement<PaVerifyPaymentNoticeRes> createPaVerifyPaymentNoticeRes(PaVerifyPaymentNoticeRes value) {
        return new JAXBElement<PaVerifyPaymentNoticeRes>(_PaVerifyPaymentNoticeRes_QNAME, PaVerifyPaymentNoticeRes.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaGetPaymentReq }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link PaGetPaymentReq }{@code >}
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paGetPaymentReq")
    public JAXBElement<PaGetPaymentReq> createPaGetPaymentReq(PaGetPaymentReq value) {
        return new JAXBElement<PaGetPaymentReq>(_PaGetPaymentReq_QNAME, PaGetPaymentReq.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaGetPaymentRes }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link PaGetPaymentRes }{@code >}
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paGetPaymentRes")
    public JAXBElement<PaGetPaymentRes> createPaGetPaymentRes(PaGetPaymentRes value) {
        return new JAXBElement<PaGetPaymentRes>(_PaGetPaymentRes_QNAME, PaGetPaymentRes.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaSendRTReq }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link PaSendRTReq }{@code >}
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paSendRTReq")
    public JAXBElement<PaSendRTReq> createPaSendRTReq(PaSendRTReq value) {
        return new JAXBElement<PaSendRTReq>(_PaSendRTReq_QNAME, PaSendRTReq.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaSendRTRes }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link PaSendRTRes }{@code >}
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paSendRTRes")
    public JAXBElement<PaSendRTRes> createPaSendRTRes(PaSendRTRes value) {
        return new JAXBElement<PaSendRTRes>(_PaSendRTRes_QNAME, PaSendRTRes.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaDemandPaymentNoticeRequest }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link PaDemandPaymentNoticeRequest }{@code >}
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paDemandPaymentNoticeRequest")
    public JAXBElement<PaDemandPaymentNoticeRequest> createPaDemandPaymentNoticeRequest(PaDemandPaymentNoticeRequest value) {
        return new JAXBElement<PaDemandPaymentNoticeRequest>(_PaDemandPaymentNoticeRequest_QNAME, PaDemandPaymentNoticeRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaDemandPaymentNoticeResponse }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link PaDemandPaymentNoticeResponse }{@code >}
     */
    @XmlElementDecl(namespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", name = "paDemandPaymentNoticeResponse")
    public JAXBElement<PaDemandPaymentNoticeResponse> createPaDemandPaymentNoticeResponse(PaDemandPaymentNoticeResponse value) {
        return new JAXBElement<PaDemandPaymentNoticeResponse>(_PaDemandPaymentNoticeResponse_QNAME, PaDemandPaymentNoticeResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CtRichiestaPagamentoTelematico }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link CtRichiestaPagamentoTelematico }{@code >}
     */
    @XmlElementDecl(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", name = "RPT")
    public JAXBElement<CtRichiestaPagamentoTelematico> createRPT(CtRichiestaPagamentoTelematico value) {
        return new JAXBElement<CtRichiestaPagamentoTelematico>(_RPT_QNAME, CtRichiestaPagamentoTelematico.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CtRicevutaTelematica }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link CtRicevutaTelematica }{@code >}
     */
    @XmlElementDecl(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", name = "RT")
    public JAXBElement<CtRicevutaTelematica> createRT(CtRicevutaTelematica value) {
        return new JAXBElement<CtRicevutaTelematica>(_RT_QNAME, CtRicevutaTelematica.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaaChiediNumeroAvviso }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link PaaChiediNumeroAvviso }{@code >}
     */
    @XmlElementDecl(namespace = "http://ws.pagamenti.telematici.gov/", name = "paaChiediNumeroAvviso")
    public JAXBElement<PaaChiediNumeroAvviso> createPaaChiediNumeroAvviso(PaaChiediNumeroAvviso value) {
        return new JAXBElement<PaaChiediNumeroAvviso>(_PaaChiediNumeroAvviso_QNAME, PaaChiediNumeroAvviso.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaaChiediNumeroAvvisoRisposta }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link PaaChiediNumeroAvvisoRisposta }{@code >}
     */
    @XmlElementDecl(namespace = "http://ws.pagamenti.telematici.gov/", name = "paaChiediNumeroAvvisoRisposta")
    public JAXBElement<PaaChiediNumeroAvvisoRisposta> createPaaChiediNumeroAvvisoRisposta(PaaChiediNumeroAvvisoRisposta value) {
        return new JAXBElement<PaaChiediNumeroAvvisoRisposta>(_PaaChiediNumeroAvvisoRisposta_QNAME, PaaChiediNumeroAvvisoRisposta.class, null, value);
    }

}
