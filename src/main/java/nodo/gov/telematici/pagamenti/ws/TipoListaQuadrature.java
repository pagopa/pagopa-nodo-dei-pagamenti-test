
package nodo.gov.telematici.pagamenti.ws;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for tipoListaQuadrature complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="tipoListaQuadrature"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="totRestituiti" type="{http://www.w3.org/2001/XMLSchema}int"/&gt;
 *         &lt;element name="idQuadratura" type="{http://ws.pagamenti.telematici.gov/}tipoIdQuadratura" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "tipoListaQuadrature", propOrder = {
    "totRestituiti",
    "idQuadratura"
})
public class TipoListaQuadrature {

    protected int totRestituiti;
    @XmlElement(nillable = true)
    protected List<TipoIdQuadratura> idQuadratura;

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
     * Gets the value of the idQuadratura property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the idQuadratura property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getIdQuadratura().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link TipoIdQuadratura }
     * 
     * 
     */
    public List<TipoIdQuadratura> getIdQuadratura() {
        if (idQuadratura == null) {
            idQuadratura = new ArrayList<TipoIdQuadratura>();
        }
        return this.idQuadratura;
    }

}
