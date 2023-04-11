
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ctAllegatoRicevuta complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ctAllegatoRicevuta"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="tipoAllegatoRicevuta" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stTipoAllegatoRicevuta"/&gt;
 *         &lt;element name="testoAllegato" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stBase64"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctAllegatoRicevuta", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "tipoAllegatoRicevuta",
    "testoAllegato"
})
public class CtAllegatoRicevuta {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    @XmlSchemaType(name = "string")
    protected StTipoAllegatoRicevuta tipoAllegatoRicevuta;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected byte[] testoAllegato;

    /**
     * Gets the value of the tipoAllegatoRicevuta property.
     * 
     * @return
     *     possible object is
     *     {@link StTipoAllegatoRicevuta }
     *     
     */
    public StTipoAllegatoRicevuta getTipoAllegatoRicevuta() {
        return tipoAllegatoRicevuta;
    }

    /**
     * Sets the value of the tipoAllegatoRicevuta property.
     * 
     * @param value
     *     allowed object is
     *     {@link StTipoAllegatoRicevuta }
     *     
     */
    public void setTipoAllegatoRicevuta(StTipoAllegatoRicevuta value) {
        this.tipoAllegatoRicevuta = value;
    }

    /**
     * Gets the value of the testoAllegato property.
     * 
     * @return
     *     possible object is
     *     byte[]
     */
    public byte[] getTestoAllegato() {
        return testoAllegato;
    }

    /**
     * Sets the value of the testoAllegato property.
     * 
     * @param value
     *     allowed object is
     *     byte[]
     */
    public void setTestoAllegato(byte[] value) {
        this.testoAllegato = value;
    }

}
