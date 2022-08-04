
package nodo.gov.telematici.pagamenti.ws;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for tipoElencoFlussiRendicontazione complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="tipoElencoFlussiRendicontazione"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="totRestituiti" type="{http://www.w3.org/2001/XMLSchema}int"/&gt;
 *         &lt;element name="idRendicontazione" type="{http://ws.pagamenti.telematici.gov/}tipoIdRendicontazione" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "tipoElencoFlussiRendicontazione", propOrder = {
    "totRestituiti",
    "idRendicontazione"
})
public class TipoElencoFlussiRendicontazione {

    protected int totRestituiti;
    @XmlElement(nillable = true)
    protected List<TipoIdRendicontazione> idRendicontazione;

    /**
     * Gets the value of the totRestituiti property.
     * 
     */
    public int getTotRestituiti() {
        return totRestituiti;
    }

    /**
     * Sets the value of the totRestituiti property.
     * 
     */
    public void setTotRestituiti(int value) {
        this.totRestituiti = value;
    }

    /**
     * Gets the value of the idRendicontazione property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the idRendicontazione property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getIdRendicontazione().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link TipoIdRendicontazione }
     * 
     * 
     */
    public List<TipoIdRendicontazione> getIdRendicontazione() {
        if (idRendicontazione == null) {
            idRendicontazione = new ArrayList<TipoIdRendicontazione>();
        }
        return this.idRendicontazione;
    }

}
