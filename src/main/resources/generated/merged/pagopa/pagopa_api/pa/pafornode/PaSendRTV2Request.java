
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per paSendRTV2Request complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="paSendRTV2Request"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="idPA" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="idBrokerPA" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="idStation" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="receipt" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctReceiptV2"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paSendRTV2Request", propOrder = {
    "idPA",
    "idBrokerPA",
    "idStation",
    "receipt"
})
public class PaSendRTV2Request {

    @XmlElement(required = true)
    protected String idPA;
    @XmlElement(required = true)
    protected String idBrokerPA;
    @XmlElement(required = true)
    protected String idStation;
    @XmlElement(required = true)
    protected CtReceiptV2 receipt;

    /**
     * Recupera il valore della proprieta idPA.
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
     * Imposta il valore della proprieta idPA.
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
     * Recupera il valore della proprieta idBrokerPA.
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
     * Imposta il valore della proprieta idBrokerPA.
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
     * Recupera il valore della proprieta idStation.
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
     * Imposta il valore della proprieta idStation.
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
     * Recupera il valore della proprieta receipt.
     * 
     * @return
     *     possible object is
     *     {@link CtReceiptV2 }
     *     
     */
    public CtReceiptV2 getReceipt() {
        return receipt;
    }

    /**
     * Imposta il valore della proprieta receipt.
     * 
     * @param value
     *     allowed object is
     *     {@link CtReceiptV2 }
     *     
     */
    public void setReceipt(CtReceiptV2 value) {
        this.receipt = value;
    }

}
