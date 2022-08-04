
package nodo.gov.telematici.pagamenti.ws;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for tipoListaRPTPendenti complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="tipoListaRPTPendenti"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="totRestituiti" type="{http://www.w3.org/2001/XMLSchema}int"/&gt;
 *         &lt;element name="rptPendente" type="{http://ws.pagamenti.telematici.gov/}tipoRPTPendente" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "tipoListaRPTPendenti", propOrder = {
    "totRestituiti",
    "rptPendente"
})
public class TipoListaRPTPendenti {

    protected int totRestituiti;
    @XmlElement(nillable = true)
    protected List<TipoRPTPendente> rptPendente;

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
     * Gets the value of the rptPendente property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the rptPendente property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getRptPendente().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link TipoRPTPendente }
     * 
     * 
     */
    public List<TipoRPTPendente> getRptPendente() {
        if (rptPendente == null) {
            rptPendente = new ArrayList<TipoRPTPendente>();
        }
        return this.rptPendente;
    }

}
