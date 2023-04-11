
package merged.pagopa.pagopa_api.pa.pafornode;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per ctSpezzoneStrutturatoCausaleVersamento complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctSpezzoneStrutturatoCausaleVersamento"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="causaleSpezzone" type="{http://ws.pagamenti.telematici.gov/}stText25"/&gt;
 *         &lt;element name="importoSpezzone" type="{http://ws.pagamenti.telematici.gov/}stImporto"/&gt;
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
     * Recupera il valore della proprieta causaleSpezzone.
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
     * Imposta il valore della proprieta causaleSpezzone.
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
     * Recupera il valore della proprieta importoSpezzone.
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
     * Imposta il valore della proprieta importoSpezzone.
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
