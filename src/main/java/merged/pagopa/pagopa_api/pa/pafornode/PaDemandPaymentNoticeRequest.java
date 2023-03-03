
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per paDemandPaymentNoticeRequest complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="paDemandPaymentNoticeRequest"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="idPA" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="idBrokerPA" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="idStation" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="idServizio" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stIdentificativoServizio"/&gt;
 *         &lt;element name="datiSpecificiServizioRequest" type="{http://www.w3.org/2001/XMLSchema}base64Binary"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paDemandPaymentNoticeRequest", propOrder = {
    "idPA",
    "idBrokerPA",
    "idStation",
    "idServizio",
    "datiSpecificiServizioRequest"
})
public class PaDemandPaymentNoticeRequest {

    @XmlElement(required = true)
    protected String idPA;
    @XmlElement(required = true)
    protected String idBrokerPA;
    @XmlElement(required = true)
    protected String idStation;
    @XmlElement(required = true)
    protected String idServizio;
    @XmlElement(required = true)
    protected byte[] datiSpecificiServizioRequest;

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
     * Recupera il valore della proprieta idServizio.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdServizio() {
        return idServizio;
    }

    /**
     * Imposta il valore della proprieta idServizio.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdServizio(String value) {
        this.idServizio = value;
    }

    /**
     * Recupera il valore della proprieta datiSpecificiServizioRequest.
     * 
     * @return
     *     possible object is
     *     byte[]
     */
    public byte[] getDatiSpecificiServizioRequest() {
        return datiSpecificiServizioRequest;
    }

    /**
     * Imposta il valore della proprieta datiSpecificiServizioRequest.
     * 
     * @param value
     *     allowed object is
     *     byte[]
     */
    public void setDatiSpecificiServizioRequest(byte[] value) {
        this.datiSpecificiServizioRequest = value;
    }

}
