
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Classe Java per ctPeriodoRiferimento complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctPeriodoRiferimento"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="annoDA" type="{http://www.w3.org/2001/XMLSchema}gYear"/&gt;
 *         &lt;element name="annoA" type="{http://www.w3.org/2001/XMLSchema}gYear"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctPeriodoRiferimento", namespace = "http://ws.pagamenti.telematici.gov/", propOrder = {
    "annoDA",
    "annoA"
})
public class CtPeriodoRiferimento {

    @XmlElement(namespace = "http://ws.pagamenti.telematici.gov/", required = true)
    @XmlSchemaType(name = "gYear")
    protected XMLGregorianCalendar annoDA;
    @XmlElement(namespace = "http://ws.pagamenti.telematici.gov/", required = true)
    @XmlSchemaType(name = "gYear")
    protected XMLGregorianCalendar annoA;

    /**
     * Recupera il valore della proprieta annoDA.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getAnnoDA() {
        return annoDA;
    }

    /**
     * Imposta il valore della proprieta annoDA.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setAnnoDA(XMLGregorianCalendar value) {
        this.annoDA = value;
    }

    /**
     * Recupera il valore della proprieta annoA.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getAnnoA() {
        return annoA;
    }

    /**
     * Imposta il valore della proprieta annoA.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setAnnoA(XMLGregorianCalendar value) {
        this.annoA = value;
    }

}
