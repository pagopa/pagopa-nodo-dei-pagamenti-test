
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ctRisposta complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ctRisposta"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="fault" type="{http://ws.pagamenti.telematici.gov/}ctFaultBean" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctRisposta", namespace = "http://ws.pagamenti.telematici.gov/", propOrder = {
    "fault"
})
@XmlSeeAlso({
    CtEsitoChiediNumeroAvviso.class
})
public class CtRisposta {

    protected CtFaultBean2 fault;

    /**
     * Gets the value of the fault property.
     * 
     * @return
     *     possible object is
     *     {@link CtFaultBean2 }
     *     
     */
    public CtFaultBean2 getFault() {
        return fault;
    }

    /**
     * Sets the value of the fault property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtFaultBean2 }
     *     
     */
    public void setFault(CtFaultBean2 value) {
        this.fault = value;
    }

}
