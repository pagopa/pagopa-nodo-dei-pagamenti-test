
package generazioneAvvisi.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * &lt;p&gt;Java class for ctNumeroAvviso complex type.
 * 
 * &lt;p&gt;The following schema fragment specifies the expected content contained within this class.
 * 
 * &lt;pre&gt;
 * &amp;lt;complexType name="ctNumeroAvviso"&amp;gt;
 *   &amp;lt;complexContent&amp;gt;
 *     &amp;lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&amp;gt;
 *       &amp;lt;sequence&amp;gt;
 *         &amp;lt;element name="auxDigit" type="{http://ws.pagamenti.telematici.gov/}stAuxDigit"/&amp;gt;
 *         &amp;lt;element name="applicationCode" type="{http://ws.pagamenti.telematici.gov/}stApplicationCode" minOccurs="0"/&amp;gt;
 *         &amp;lt;element name="IUV" type="{http://ws.pagamenti.telematici.gov/}stCodIUV"/&amp;gt;
 *       &amp;lt;/sequence&amp;gt;
 *     &amp;lt;/restriction&amp;gt;
 *   &amp;lt;/complexContent&amp;gt;
 * &amp;lt;/complexType&amp;gt;
 * &lt;/pre&gt;
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctNumeroAvviso", propOrder = {
    "auxDigit",
    "applicationCode",
    "iuv"
})
public class CtNumeroAvviso {

    @XmlElement(required = true)
    protected String auxDigit;
    protected String applicationCode;
    @XmlElement(name = "IUV", required = true)
    protected String iuv;

    /**
     * Gets the value of the auxDigit property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAuxDigit() {
        return auxDigit;
    }

    /**
     * Sets the value of the auxDigit property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAuxDigit(String value) {
        this.auxDigit = value;
    }

    /**
     * Gets the value of the applicationCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getApplicationCode() {
        return applicationCode;
    }

    /**
     * Sets the value of the applicationCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setApplicationCode(String value) {
        this.applicationCode = value;
    }

    /**
     * Gets the value of the iuv property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIUV() {
        return iuv;
    }

    /**
     * Sets the value of the iuv property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIUV(String value) {
        this.iuv = value;
    }

}
