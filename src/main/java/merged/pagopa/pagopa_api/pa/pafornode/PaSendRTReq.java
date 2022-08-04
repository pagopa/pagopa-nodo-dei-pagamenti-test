
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * 
 * The `paSendRT` request contains :
 * - `idPA` : alphanumeric field containing the tax code of the structure sending the payment request.
 * - `idBrokerPA` : identification of subject that operates as an intermediary for the PA.
 * - `idStation` : identification of the station of the PA into pagoPa system.
 * - `receipt` : the payment receipt (_see below to details_)
 * 
 *       
 * 
 * <p>Classe Java per paSendRTReq complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="paSendRTReq"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="idPA" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="idBrokerPA" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="idStation" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="receipt" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctReceipt"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paSendRTReq", propOrder = {
    "idPA",
    "idBrokerPA",
    "idStation",
    "receipt"
})
public class PaSendRTReq {

    @XmlElement(required = true)
    protected String idPA;
    @XmlElement(required = true)
    protected String idBrokerPA;
    @XmlElement(required = true)
    protected String idStation;
    @XmlElement(required = true)
    protected CtReceipt receipt;

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
     * Recupera il valore della proprietà receipt.
     * 
     * @return
     *     possible object is
     *     {@link CtReceipt }
     *     
     */
    public CtReceipt getReceipt() {
        return receipt;
    }

    /**
     * Imposta il valore della proprietà receipt.
     * 
     * @param value
     *     allowed object is
     *     {@link CtReceipt }
     *     
     */
    public void setReceipt(CtReceipt value) {
        this.receipt = value;
    }

}
