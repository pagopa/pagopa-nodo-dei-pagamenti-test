
package eu.sia.nodopa.merged.paaNodoNM4;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ctSpezzoneStrutturatoCausaleVersamento complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ctSpezzoneStrutturatoCausaleVersamento"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="causaleSpezzone" type="{http://ws.pagamenti.telematici.gov/}stText25"/&gt;
 *         &lt;element name="importoSpezzone" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImporto"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctSpezzoneStrutturatoCausaleVersamento", namespace = "http://ws.pagamenti.telematici.gov/", propOrder = {
    "causaleSpezzone",
    "importoSpezzone"
})
public class CtSpezzoneStrutturatoCausaleVersamento {

    @XmlElement(required = true)
    protected String causaleSpezzone;
    @XmlElement(required = true)
    protected BigDecimal importoSpezzone;

    /**
     * Gets the value of the causaleSpezzone property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausaleSpezzone() {
        return causaleSpezzone;
    }

    /**
     * Sets the value of the causaleSpezzone property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausaleSpezzone(String value) {
        this.causaleSpezzone = value;
    }

    /**
     * Gets the value of the importoSpezzone property.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getImportoSpezzone() {
        return importoSpezzone;
    }

    /**
     * Sets the value of the importoSpezzone property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setImportoSpezzone(BigDecimal value) {
        this.importoSpezzone = value;
    }

}
