
package nodo.gov.telematici.pagamenti.ws;

import javax.activation.DataHandler;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlMimeType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for nodoChiediQuadraturaPARisposta complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="nodoChiediQuadraturaPARisposta"&gt;
 *   &lt;complexContent&gt;
 *     &lt;extension base="{http://ws.pagamenti.telematici.gov/}risposta"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="xmlQuadratura" type="{http://www.w3.org/2001/XMLSchema}base64Binary" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/extension&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "nodoChiediQuadraturaPARisposta", propOrder = {
    "xmlQuadratura"
})
public class NodoChiediQuadraturaPARisposta
    extends Risposta
{

    @XmlMimeType("application/octet-stream")
    protected DataHandler xmlQuadratura;

    /**
     * Gets the value of the xmlQuadratura property.
     * 
     * @return
     *     possible object is
     *     {@link DataHandler }
     *     
     */
    public DataHandler getXmlQuadratura() {
        return xmlQuadratura;
    }

    /**
     * Sets the value of the xmlQuadratura property.
     * 
     * @param value
     *     allowed object is
     *     {@link DataHandler }
     *     
     */
    public void setXmlQuadratura(DataHandler value) {
        this.xmlQuadratura = value;
    }

}
