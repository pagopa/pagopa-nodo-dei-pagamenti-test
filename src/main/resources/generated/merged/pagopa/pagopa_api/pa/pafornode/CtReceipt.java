
package merged.pagopa.pagopa_api.pa.pafornode;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Classe Java per ctReceipt complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctReceipt"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="receiptId" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="noticeNumber" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stNoticeNumber"/&gt;
 *         &lt;element name="fiscalCode" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stFiscalCodePA"/&gt;
 *         &lt;element name="outcome" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stOutcome"/&gt;
 *         &lt;element name="creditorReferenceId" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="paymentAmount" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stAmount"/&gt;
 *         &lt;element name="description" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText140"/&gt;
 *         &lt;element name="companyName" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText140"/&gt;
 *         &lt;element name="officeName" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText140" minOccurs="0"/&gt;
 *         &lt;element name="debtor" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctSubject"/&gt;
 *         &lt;element name="transferList" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctTransferListPA"/&gt;
 *         &lt;element name="idPSP" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="pspFiscalCode" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText70" minOccurs="0"/&gt;
 *         &lt;element name="pspPartitaIVA" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText20" minOccurs="0"/&gt;
 *         &lt;element name="PSPCompanyName" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText70"/&gt;
 *         &lt;element name="idChannel" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="channelDescription" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="payer" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctSubject" minOccurs="0"/&gt;
 *         &lt;element name="paymentMethod" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="fee" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stAmount" minOccurs="0"/&gt;
 *         &lt;element name="paymentDateTime" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stISODateTime" minOccurs="0"/&gt;
 *         &lt;element name="applicationDate" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stISODate" minOccurs="0"/&gt;
 *         &lt;element name="transferDate" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stISODate" minOccurs="0"/&gt;
 *         &lt;element name="metadata" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}ctMetadata" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctReceipt", propOrder = {
    "receiptId",
    "noticeNumber",
    "fiscalCode",
    "outcome",
    "creditorReferenceId",
    "paymentAmount",
    "description",
    "companyName",
    "officeName",
    "debtor",
    "transferList",
    "idPSP",
    "pspFiscalCode",
    "pspPartitaIVA",
    "pspCompanyName",
    "idChannel",
    "channelDescription",
    "payer",
    "paymentMethod",
    "fee",
    "paymentDateTime",
    "applicationDate",
    "transferDate",
    "metadata"
})
public class CtReceipt {

    @XmlElement(required = true)
    protected String receiptId;
    @XmlElement(required = true)
    protected String noticeNumber;
    @XmlElement(required = true)
    protected String fiscalCode;
    @XmlElement(required = true)
    @XmlSchemaType(name = "string")
    protected StOutcome outcome;
    @XmlElement(required = true)
    protected String creditorReferenceId;
    @XmlElement(required = true)
    protected BigDecimal paymentAmount;
    @XmlElement(required = true)
    protected String description;
    @XmlElement(required = true)
    protected String companyName;
    protected String officeName;
    @XmlElement(required = true)
    protected CtSubject debtor;
    @XmlElement(required = true)
    protected CtTransferListPA transferList;
    @XmlElement(required = true)
    protected String idPSP;
    protected String pspFiscalCode;
    protected String pspPartitaIVA;
    @XmlElement(name = "PSPCompanyName", required = true)
    protected String pspCompanyName;
    @XmlElement(required = true)
    protected String idChannel;
    @XmlElement(required = true)
    protected String channelDescription;
    protected CtSubject payer;
    protected String paymentMethod;
    protected BigDecimal fee;
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar paymentDateTime;
    @XmlSchemaType(name = "date")
    protected XMLGregorianCalendar applicationDate;
    @XmlSchemaType(name = "date")
    protected XMLGregorianCalendar transferDate;
    protected CtMetadata metadata;

    /**
     * Recupera il valore della proprieta receiptId.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getReceiptId() {
        return receiptId;
    }

    /**
     * Imposta il valore della proprieta receiptId.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setReceiptId(String value) {
        this.receiptId = value;
    }

    /**
     * Recupera il valore della proprieta noticeNumber.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNoticeNumber() {
        return noticeNumber;
    }

    /**
     * Imposta il valore della proprieta noticeNumber.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNoticeNumber(String value) {
        this.noticeNumber = value;
    }

    /**
     * Recupera il valore della proprieta fiscalCode.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFiscalCode() {
        return fiscalCode;
    }

    /**
     * Imposta il valore della proprieta fiscalCode.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFiscalCode(String value) {
        this.fiscalCode = value;
    }

    /**
     * Recupera il valore della proprieta outcome.
     * 
     * @return
     *     possible object is
     *     {@link StOutcome }
     *     
     */
    public StOutcome getOutcome() {
        return outcome;
    }

    /**
     * Imposta il valore della proprieta outcome.
     * 
     * @param value
     *     allowed object is
     *     {@link StOutcome }
     *     
     */
    public void setOutcome(StOutcome value) {
        this.outcome = value;
    }

    /**
     * Recupera il valore della proprieta creditorReferenceId.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCreditorReferenceId() {
        return creditorReferenceId;
    }

    /**
     * Imposta il valore della proprieta creditorReferenceId.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCreditorReferenceId(String value) {
        this.creditorReferenceId = value;
    }

    /**
     * Recupera il valore della proprieta paymentAmount.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getPaymentAmount() {
        return paymentAmount;
    }

    /**
     * Imposta il valore della proprieta paymentAmount.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setPaymentAmount(BigDecimal value) {
        this.paymentAmount = value;
    }

    /**
     * Recupera il valore della proprieta description.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDescription() {
        return description;
    }

    /**
     * Imposta il valore della proprieta description.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDescription(String value) {
        this.description = value;
    }

    /**
     * Recupera il valore della proprieta companyName.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCompanyName() {
        return companyName;
    }

    /**
     * Imposta il valore della proprieta companyName.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCompanyName(String value) {
        this.companyName = value;
    }

    /**
     * Recupera il valore della proprieta officeName.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOfficeName() {
        return officeName;
    }

    /**
     * Imposta il valore della proprieta officeName.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOfficeName(String value) {
        this.officeName = value;
    }

    /**
     * Recupera il valore della proprieta debtor.
     * 
     * @return
     *     possible object is
     *     {@link CtSubject }
     *     
     */
    public CtSubject getDebtor() {
        return debtor;
    }

    /**
     * Imposta il valore della proprieta debtor.
     * 
     * @param value
     *     allowed object is
     *     {@link CtSubject }
     *     
     */
    public void setDebtor(CtSubject value) {
        this.debtor = value;
    }

    /**
     * Recupera il valore della proprieta transferList.
     * 
     * @return
     *     possible object is
     *     {@link CtTransferListPA }
     *     
     */
    public CtTransferListPA getTransferList() {
        return transferList;
    }

    /**
     * Imposta il valore della proprieta transferList.
     * 
     * @param value
     *     allowed object is
     *     {@link CtTransferListPA }
     *     
     */
    public void setTransferList(CtTransferListPA value) {
        this.transferList = value;
    }

    /**
     * Recupera il valore della proprieta idPSP.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdPSP() {
        return idPSP;
    }

    /**
     * Imposta il valore della proprieta idPSP.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdPSP(String value) {
        this.idPSP = value;
    }

    /**
     * Recupera il valore della proprieta pspFiscalCode.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPspFiscalCode() {
        return pspFiscalCode;
    }

    /**
     * Imposta il valore della proprieta pspFiscalCode.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPspFiscalCode(String value) {
        this.pspFiscalCode = value;
    }

    /**
     * Recupera il valore della proprieta pspPartitaIVA.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPspPartitaIVA() {
        return pspPartitaIVA;
    }

    /**
     * Imposta il valore della proprieta pspPartitaIVA.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPspPartitaIVA(String value) {
        this.pspPartitaIVA = value;
    }

    /**
     * Recupera il valore della proprieta pspCompanyName.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPSPCompanyName() {
        return pspCompanyName;
    }

    /**
     * Imposta il valore della proprieta pspCompanyName.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPSPCompanyName(String value) {
        this.pspCompanyName = value;
    }

    /**
     * Recupera il valore della proprieta idChannel.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdChannel() {
        return idChannel;
    }

    /**
     * Imposta il valore della proprieta idChannel.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdChannel(String value) {
        this.idChannel = value;
    }

    /**
     * Recupera il valore della proprieta channelDescription.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getChannelDescription() {
        return channelDescription;
    }

    /**
     * Imposta il valore della proprieta channelDescription.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setChannelDescription(String value) {
        this.channelDescription = value;
    }

    /**
     * Recupera il valore della proprieta payer.
     * 
     * @return
     *     possible object is
     *     {@link CtSubject }
     *     
     */
    public CtSubject getPayer() {
        return payer;
    }

    /**
     * Imposta il valore della proprieta payer.
     * 
     * @param value
     *     allowed object is
     *     {@link CtSubject }
     *     
     */
    public void setPayer(CtSubject value) {
        this.payer = value;
    }

    /**
     * Recupera il valore della proprieta paymentMethod.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPaymentMethod() {
        return paymentMethod;
    }

    /**
     * Imposta il valore della proprieta paymentMethod.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPaymentMethod(String value) {
        this.paymentMethod = value;
    }

    /**
     * Recupera il valore della proprieta fee.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getFee() {
        return fee;
    }

    /**
     * Imposta il valore della proprieta fee.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setFee(BigDecimal value) {
        this.fee = value;
    }

    /**
     * Recupera il valore della proprieta paymentDateTime.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getPaymentDateTime() {
        return paymentDateTime;
    }

    /**
     * Imposta il valore della proprieta paymentDateTime.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setPaymentDateTime(XMLGregorianCalendar value) {
        this.paymentDateTime = value;
    }

    /**
     * Recupera il valore della proprieta applicationDate.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getApplicationDate() {
        return applicationDate;
    }

    /**
     * Imposta il valore della proprieta applicationDate.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setApplicationDate(XMLGregorianCalendar value) {
        this.applicationDate = value;
    }

    /**
     * Recupera il valore della proprieta transferDate.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getTransferDate() {
        return transferDate;
    }

    /**
     * Imposta il valore della proprieta transferDate.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setTransferDate(XMLGregorianCalendar value) {
        this.transferDate = value;
    }

    /**
     * Recupera il valore della proprieta metadata.
     * 
     * @return
     *     possible object is
     *     {@link CtMetadata }
     *     
     */
    public CtMetadata getMetadata() {
        return metadata;
    }

    /**
     * Imposta il valore della proprieta metadata.
     * 
     * @param value
     *     allowed object is
     *     {@link CtMetadata }
     *     
     */
    public void setMetadata(CtMetadata value) {
        this.metadata = value;
    }

}
