
package generazioneAvvisi.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * &lt;p&gt;Java class for paaChiediNumeroAvvisoRisposta complex type.
 * 
 * &lt;p&gt;The following schema fragment specifies the expected content contained within this class.
 * 
 * &lt;pre&gt;
 * &amp;lt;complexType name="paaChiediNumeroAvvisoRisposta"&amp;gt;
 *   &amp;lt;complexContent&amp;gt;
 *     &amp;lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&amp;gt;
 *       &amp;lt;sequence&amp;gt;
 *         &amp;lt;element name="paaChiediNumeroAvvisoRisposta" type="{http://ws.pagamenti.telematici.gov/}ctEsitoChiediNumeroAvviso"/&amp;gt;
 *       &amp;lt;/sequence&amp;gt;
 *     &amp;lt;/restriction&amp;gt;
 *   &amp;lt;/complexContent&amp;gt;
 * &amp;lt;/complexType&amp;gt;
 * &lt;/pre&gt;
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paaChiediNumeroAvvisoRisposta", propOrder = {
    "paaChiediNumeroAvvisoRisposta"
})
public class PaaChiediNumeroAvvisoRisposta {

    @XmlElement(required = true)
    protected CtEsitoChiediNumeroAvviso paaChiediNumeroAvvisoRisposta;

    /**
     * Gets the value of the paaChiediNumeroAvvisoRisposta property.
     * 
     * @return
     *     possible object is
     *     {@link CtEsitoChiediNumeroAvviso }
     *     
     */
    public CtEsitoChiediNumeroAvviso getPaaChiediNumeroAvvisoRisposta() {
        return paaChiediNumeroAvvisoRisposta;
    }

    /**
     * Sets the value of the paaChiediNumeroAvvisoRisposta property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtEsitoChiediNumeroAvviso }
     *     
     */
    public void setPaaChiediNumeroAvvisoRisposta(CtEsitoChiediNumeroAvviso value) {
        this.paaChiediNumeroAvvisoRisposta = value;
    }

}
