
package rt.gov.telematici.pagamenti.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * &lt;p&gt;Java class for paaInviaRTRisposta complex type.
 * 
 * &lt;p&gt;The following schema fragment specifies the expected content contained within this class.
 * 
 * &lt;pre&gt;
 * &amp;lt;complexType name="paaInviaRTRisposta"&amp;gt;
 *   &amp;lt;complexContent&amp;gt;
 *     &amp;lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&amp;gt;
 *       &amp;lt;sequence&amp;gt;
 *         &amp;lt;element name="paaInviaRTRisposta" type="{http://ws.pagamenti.telematici.gov/}esitoPaaInviaRT"/&amp;gt;
 *       &amp;lt;/sequence&amp;gt;
 *     &amp;lt;/restriction&amp;gt;
 *   &amp;lt;/complexContent&amp;gt;
 * &amp;lt;/complexType&amp;gt;
 * &lt;/pre&gt;
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paaInviaRTRisposta", propOrder = {
    "paaInviaRTRisposta"
})
public class PaaInviaRTRisposta {

    @XmlElement(required = true)
    protected EsitoPaaInviaRT paaInviaRTRisposta;

    /**
     * Gets the value of the paaInviaRTRisposta property.
     * 
     * @return
     *     possible object is
     *     {@link EsitoPaaInviaRT }
     *     
     */
    public EsitoPaaInviaRT getPaaInviaRTRisposta() {
        return paaInviaRTRisposta;
    }

    /**
     * Sets the value of the paaInviaRTRisposta property.
     * 
     * @param value
     *     allowed object is
     *     {@link EsitoPaaInviaRT }
     *     
     */
    public void setPaaInviaRTRisposta(EsitoPaaInviaRT value) {
        this.paaInviaRTRisposta = value;
    }

}
