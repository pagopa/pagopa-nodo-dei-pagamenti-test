
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
 * The `paVerifyPaymentNotice` request contains :
 * - `idPA` : alphanumeric field containing the tax code of the structure sending the payment request.
 * - `idBrokerPA` : identification of subject that operates as an intermediary for the PA.
 * - `idStation` : identification of the station of the PA into pagoPa system.
 * - `qrCode` : is the union of `fiscalCode` and `noticeNumber`
 * - `amount` : amount of the payment
 * - `paymentNote` : details description of the payment
 * - `transferType` : _specific only for POSTE Italiane_
 * - `dueDate` : indicates the expiration payment date according to the ISO 8601 format `[YYYY]-[MM]-[DD]`.
 *       
 * 
 * <p>Classe Java per paGetPaymentReq complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="paGetPaymentReq"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="idPA" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="idBrokerPA" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="idStation" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="qrCode" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctQrCode"/&gt;
 *         &lt;element name="amount" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stAmount" minOccurs="0"/&gt;
 *         &lt;element name="paymentNote" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText210" minOccurs="0"/&gt;
 *         &lt;element name="transferType" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stTransferType" minOccurs="0"/&gt;
 *         &lt;element name="dueDate" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stISODate" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paGetPaymentReq", propOrder = {
    "idPA",
    "idBrokerPA",
    "idStation",
    "qrCode",
    "amount",
    "paymentNote",
    "transferType",
    "dueDate"
})
public class PaGetPaymentReq {

    @XmlElement(required = true)
    protected String idPA;
    @XmlElement(required = true)
    protected String idBrokerPA;
    @XmlElement(required = true)
    protected String idStation;
    @XmlElement(required = true)
    protected CtQrCode qrCode;
    protected BigDecimal amount;
    protected String paymentNote;
    @XmlSchemaType(name = "string")
    protected StTransferType transferType;
    @XmlSchemaType(name = "date")
    protected XMLGregorianCalendar dueDate;

    /**
     * Recupera il valore della proprietà idPA.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdPA() {
        return idPA;
    }

    /**
     * Imposta il valore della proprietà idPA.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdPA(String value) {
        this.idPA = value;
    }

    /**
     * Recupera il valore della proprietà idBrokerPA.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdBrokerPA() {
        return idBrokerPA;
    }

    /**
     * Imposta il valore della proprietà idBrokerPA.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdBrokerPA(String value) {
        this.idBrokerPA = value;
    }

    /**
     * Recupera il valore della proprietà idStation.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdStation() {
        return idStation;
    }

    /**
     * Imposta il valore della proprietà idStation.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdStation(String value) {
        this.idStation = value;
    }

    /**
     * Recupera il valore della proprietà qrCode.
     * 
     * @return
     *     possible object is
     *     {@link CtQrCode }
     *     
     */
    public CtQrCode getQrCode() {
        return qrCode;
    }

    /**
     * Imposta il valore della proprietà qrCode.
     * 
     * @param value
     *     allowed object is
     *     {@link CtQrCode }
     *     
     */
    public void setQrCode(CtQrCode value) {
        this.qrCode = value;
    }

    /**
     * Recupera il valore della proprietà amount.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getAmount() {
        return amount;
    }

    /**
     * Imposta il valore della proprietà amount.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setAmount(BigDecimal value) {
        this.amount = value;
    }

    /**
     * Recupera il valore della proprietà paymentNote.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPaymentNote() {
        return paymentNote;
    }

    /**
     * Imposta il valore della proprietà paymentNote.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPaymentNote(String value) {
        this.paymentNote = value;
    }

    /**
     * Recupera il valore della proprietà transferType.
     * 
     * @return
     *     possible object is
     *     {@link StTransferType }
     *     
     */
    public StTransferType getTransferType() {
        return transferType;
    }

    /**
     * Imposta il valore della proprietà transferType.
     * 
     * @param value
     *     allowed object is
     *     {@link StTransferType }
     *     
     */
    public void setTransferType(StTransferType value) {
        this.transferType = value;
    }

    /**
     * Recupera il valore della proprietà dueDate.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getDueDate() {
        return dueDate;
    }

    /**
     * Imposta il valore della proprietà dueDate.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setDueDate(XMLGregorianCalendar value) {
        this.dueDate = value;
    }

}
