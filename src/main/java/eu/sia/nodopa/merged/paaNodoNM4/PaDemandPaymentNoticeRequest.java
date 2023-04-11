
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for paDemandPaymentNoticeRequest complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="paDemandPaymentNoticeRequest"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="idPA" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="idBrokerPA" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="idStation" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
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
     * Gets the value of the idPA property.
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
     * Sets the value of the idPA property.
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
     * Gets the value of the idBrokerPA property.
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
     * Sets the value of the idBrokerPA property.
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
     * Gets the value of the idStation property.
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
     * Sets the value of the idStation property.
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
     * Gets the value of the idServizio property.
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
     * Sets the value of the idServizio property.
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
     * Gets the value of the datiSpecificiServizioRequest property.
     * 
     * @return
     *     possible object is
     *     byte[]
     */
    public byte[] getDatiSpecificiServizioRequest() {
        return datiSpecificiServizioRequest;
    }

    /**
     * Sets the value of the datiSpecificiServizioRequest property.
     * 
     * @param value
     *     allowed object is
     *     byte[]
     */
    public void setDatiSpecificiServizioRequest(byte[] value) {
        this.datiSpecificiServizioRequest = value;
    }

}
