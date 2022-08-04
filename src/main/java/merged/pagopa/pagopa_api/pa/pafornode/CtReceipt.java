
package merged.pagopa.pagopa_api.pa.pafornode;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * 
 *         Its contains all receipt information :
 * 
 * **identifier section**
 * - `outcome` : result of receipt **OK** / **KO**
 * - `receiptId` : unique identifier of receipt (assigned by pagoPa) it contains `paymentToken` present in to `activatePaymentNotice` response 
 * - `noticeNumber` : notice number
 * - `fiscalCode` : Tax code of the public administration
 * 
 * **PA data**
 * - `creditorReferenceId` : **IUV** _Identificativo Univoco Versamento_
 * - `paymentAmount` : amount
 * - `description` : 
 * - `companyName` : Public Administration full name
 * - `officeName` Public Administration Department Name
 * - `debtor` : debtor subject identifier
 * - `transferList` : the list of transfers
 * - `metadata` : info received in to `paGetPaymentRes`
 * 
 * **PSP data**
 * - `idPSP` : PSP Identifier, it has been assigned from pagoPA.
 * - `pspFiscalCode` : PSP' fiscal code
 * - `pspPartitaIVA` : PSP' _Partita IVA_
 * - `PSPCompanyName` : PSP full name
 * - `idChannel` : Channel Identifier, it identifies a payment service category and through which the transaction is carried out.
 * - `channelDescription` : Channel Identifier description
 * - `payer` : who made the payment
 * - `paymentMethod` : Method of the payment , i.e. `cash`, `creditCard`, `bancomat` or `other`
 * - `fee` : PSP's fee applied
 * - `paymentDateTime` : payment execution date by the user
 * - `applicationDate` : application date, payment date on the PSP side
 * - `transferDate` : transfer date
 * 
 *       
 * 
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
 *         &lt;element name="noticeNumber" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stNoticeNumber"/&gt;
 *         &lt;element name="fiscalCode" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stFiscalCodePA"/&gt;
 *         &lt;element name="outcome" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stOutcome"/&gt;
 *         &lt;element name="creditorReferenceId" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="paymentAmount" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stAmount"/&gt;
 *         &lt;element name="description" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText140"/&gt;
 *         &lt;element name="companyName" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText140"/&gt;
 *         &lt;element name="officeName" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText140" minOccurs="0"/&gt;
 *         &lt;element name="debtor" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctSubject"/&gt;
 *         &lt;element name="transferList" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctTransferListPA"/&gt;
 *         &lt;element name="idPSP" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="pspFiscalCode" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText70" minOccurs="0"/&gt;
 *         &lt;element name="pspPartitaIVA" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText20" minOccurs="0"/&gt;
 *         &lt;element name="PSPCompanyName" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="idChannel" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="channelDescription" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="payer" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctSubject" minOccurs="0"/&gt;
 *         &lt;element name="paymentMethod" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35" minOccurs="0"/&gt;
 *         &lt;element name="fee" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stAmount" minOccurs="0"/&gt;
 *         &lt;element name="paymentDateTime" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stISODateTime" minOccurs="0"/&gt;
 *         &lt;element name="applicationDate" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stISODate" minOccurs="0"/&gt;
 *         &lt;element name="transferDate" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stISODate" minOccurs="0"/&gt;
 *         &lt;element name="metadata" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctMetadata" minOccurs="0"/&gt;
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
     * Recupera il valore della proprietà receiptId.
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
     * Imposta il valore della proprietà receiptId.
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
     * Recupera il valore della proprietà noticeNumber.
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
     * Imposta il valore della proprietà noticeNumber.
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
     * Recupera il valore della proprietà fiscalCode.
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
     * Imposta il valore della proprietà fiscalCode.
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
     * Recupera il valore della proprietà outcome.
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
     * Imposta il valore della proprietà outcome.
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
     * Recupera il valore della proprietà creditorReferenceId.
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
     * Imposta il valore della proprietà creditorReferenceId.
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
     * Recupera il valore della proprietà paymentAmount.
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
     * Imposta il valore della proprietà paymentAmount.
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
     * Recupera il valore della proprietà description.
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
     * Imposta il valore della proprietà description.
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
     * Recupera il valore della proprietà companyName.
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
     * Imposta il valore della proprietà companyName.
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
     * Recupera il valore della proprietà officeName.
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
     * Imposta il valore della proprietà officeName.
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
     * Recupera il valore della proprietà debtor.
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
     * Imposta il valore della proprietà debtor.
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
     * Recupera il valore della proprietà transferList.
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
     * Imposta il valore della proprietà transferList.
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
     * Recupera il valore della proprietà idPSP.
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
     * Imposta il valore della proprietà idPSP.
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
     * Recupera il valore della proprietà pspFiscalCode.
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
     * Imposta il valore della proprietà pspFiscalCode.
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
     * Recupera il valore della proprietà pspPartitaIVA.
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
     * Imposta il valore della proprietà pspPartitaIVA.
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
     * Recupera il valore della proprietà pspCompanyName.
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
     * Imposta il valore della proprietà pspCompanyName.
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
     * Recupera il valore della proprietà idChannel.
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
     * Imposta il valore della proprietà idChannel.
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
     * Recupera il valore della proprietà channelDescription.
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
     * Imposta il valore della proprietà channelDescription.
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
     * Recupera il valore della proprietà payer.
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
     * Imposta il valore della proprietà payer.
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
     * Recupera il valore della proprietà paymentMethod.
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
     * Imposta il valore della proprietà paymentMethod.
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
     * Recupera il valore della proprietà fee.
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
     * Imposta il valore della proprietà fee.
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
     * Recupera il valore della proprietà paymentDateTime.
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
     * Imposta il valore della proprietà paymentDateTime.
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
     * Recupera il valore della proprietà applicationDate.
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
     * Imposta il valore della proprietà applicationDate.
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
     * Recupera il valore della proprietà transferDate.
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
     * Imposta il valore della proprietà transferDate.
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
     * Recupera il valore della proprietà metadata.
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
     * Imposta il valore della proprietà metadata.
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
