
package generazioneAvvisi.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * &lt;p&gt;Java class for paaChiediNumeroAvviso complex type.
 * 
 * &lt;p&gt;The following schema fragment specifies the expected content contained within this class.
 * 
 * &lt;pre&gt;
 * &amp;lt;complexType name="paaChiediNumeroAvviso"&amp;gt;
 *   &amp;lt;complexContent&amp;gt;
 *     &amp;lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&amp;gt;
 *       &amp;lt;sequence&amp;gt;
 *         &amp;lt;element name="identificativoPSP" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&amp;gt;
 *         &amp;lt;element name="datiSpecificiServizio" type="{http://www.w3.org/2001/XMLSchema}base64Binary"/&amp;gt;
 *       &amp;lt;/sequence&amp;gt;
 *     &amp;lt;/restriction&amp;gt;
 *   &amp;lt;/complexContent&amp;gt;
 * &amp;lt;/complexType&amp;gt;
 * &lt;/pre&gt;
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paaChiediNumeroAvviso", propOrder = {
    "identificativoPSP",
    "datiSpecificiServizio"
})
public class PaaChiediNumeroAvviso {

    @XmlElement(required = true)
    protected String identificativoPSP;
    @XmlElement(required = true)
    protected byte[] datiSpecificiServizio;

    /**
     * Gets the value of the identificativoPSP property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoPSP() {
        return identificativoPSP;
    }

    /**
     * Sets the value of the identificativoPSP property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoPSP(String value) {
        this.identificativoPSP = value;
    }

    /**
     * Gets the value of the datiSpecificiServizio property.
     * 
     * @return
     *     possible object is
     *     byte[]
     */
    public byte[] getDatiSpecificiServizio() {
        return datiSpecificiServizio;
    }

    /**
     * Sets the value of the datiSpecificiServizio property.
     * 
     * @param value
     *     allowed object is
     *     byte[]
     */
    public void setDatiSpecificiServizio(byte[] value) {
        this.datiSpecificiServizio = value;
    }

}
