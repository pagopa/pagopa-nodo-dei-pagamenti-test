
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for paaChiediNumeroAvvisoRisposta complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="paaChiediNumeroAvvisoRisposta"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="paaChiediNumeroAvvisoRisposta" type="{http://ws.pagamenti.telematici.gov/}ctEsitoChiediNumeroAvviso"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paaChiediNumeroAvvisoRisposta", namespace = "http://ws.pagamenti.telematici.gov/", propOrder = {
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
