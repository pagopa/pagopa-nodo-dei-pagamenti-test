
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for paaChiediNumeroAvviso complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="paaChiediNumeroAvviso"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="identificativoPSP" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&gt;
 *         &lt;element name="datiSpecificiServizio" type="{http://www.w3.org/2001/XMLSchema}base64Binary"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paaChiediNumeroAvviso", namespace = "http://ws.pagamenti.telematici.gov/", propOrder = {
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
