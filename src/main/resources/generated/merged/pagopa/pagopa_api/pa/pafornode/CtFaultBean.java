
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per ctFaultBean complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctFaultBean"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="faultCode" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stFaultCode"/&gt;
 *         &lt;element name="faultString" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="id" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="description" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="serial" type="{http://www.w3.org/2001/XMLSchema}int" minOccurs="0"/&gt;
 *         &lt;element name="originalFaultCode" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="originalFaultString" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="originalDescription" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctFaultBean", namespace = "http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/", propOrder = {
    "faultCode",
    "faultString",
    "id",
    "description",
    "serial",
    "originalFaultCode",
    "originalFaultString",
    "originalDescription"
})
public class CtFaultBean {

    @XmlElement(required = true)
    protected String faultCode;
    @XmlElement(required = true)
    protected String faultString;
    @XmlElement(required = true)
    protected String id;
    protected String description;
    protected Integer serial;
    protected String originalFaultCode;
    protected String originalFaultString;
    protected String originalDescription;

    /**
     * Recupera il valore della proprieta faultCode.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFaultCode() {
        return faultCode;
    }

    /**
     * Imposta il valore della proprieta faultCode.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFaultCode(String value) {
        this.faultCode = value;
    }

    /**
     * Recupera il valore della proprieta faultString.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFaultString() {
        return faultString;
    }

    /**
     * Imposta il valore della proprieta faultString.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFaultString(String value) {
        this.faultString = value;
    }

    /**
     * Recupera il valore della proprieta id.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getId() {
        return id;
    }

    /**
     * Imposta il valore della proprieta id.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setId(String value) {
        this.id = value;
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
     * Recupera il valore della proprieta serial.
     * 
     * @return
     *     possible object is
     *     {@link Integer }
     *     
     */
    public Integer getSerial() {
        return serial;
    }

    /**
     * Imposta il valore della proprieta serial.
     * 
     * @param value
     *     allowed object is
     *     {@link Integer }
     *     
     */
    public void setSerial(Integer value) {
        this.serial = value;
    }

    /**
     * Recupera il valore della proprieta originalFaultCode.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOriginalFaultCode() {
        return originalFaultCode;
    }

    /**
     * Imposta il valore della proprieta originalFaultCode.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOriginalFaultCode(String value) {
        this.originalFaultCode = value;
    }

    /**
     * Recupera il valore della proprieta originalFaultString.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOriginalFaultString() {
        return originalFaultString;
    }

    /**
     * Imposta il valore della proprieta originalFaultString.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOriginalFaultString(String value) {
        this.originalFaultString = value;
    }

    /**
     * Recupera il valore della proprieta originalDescription.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOriginalDescription() {
        return originalDescription;
    }

    /**
     * Imposta il valore della proprieta originalDescription.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOriginalDescription(String value) {
        this.originalDescription = value;
    }

}
