
package nodo.gov.telematici.pagamenti.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for nodoChiediSceltaWISPRisposta complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="nodoChiediSceltaWISPRisposta"&gt;
 *   &lt;complexContent&gt;
 *     &lt;extension base="{http://ws.pagamenti.telematici.gov/}risposta"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="effettuazioneScelta" type="{http://ws.pagamenti.telematici.gov/}stEffettuazioneScelta" minOccurs="0"/&gt;
 *         &lt;element name="identificativoPSP" type="{http://ws.pagamenti.telematici.gov/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="identificativoIntermediarioPSP" type="{http://ws.pagamenti.telematici.gov/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="identificativoCanale" type="{http://ws.pagamenti.telematici.gov/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="tipoVersamento" type="{http://ws.pagamenti.telematici.gov/}stTipoVersamento" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/extension&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "nodoChiediSceltaWISPRisposta", propOrder = {
    "effettuazioneScelta",
    "identificativoPSP",
    "identificativoIntermediarioPSP",
    "identificativoCanale",
    "tipoVersamento"
})
public class NodoChiediSceltaWISPRisposta
    extends Risposta
{

    @XmlSchemaType(name = "string")
    protected StEffettuazioneScelta effettuazioneScelta;
    protected String identificativoPSP;
    protected String identificativoIntermediarioPSP;
    protected String identificativoCanale;
    @XmlSchemaType(name = "string")
    protected StTipoVersamento tipoVersamento;

    /**
     * Gets the value of the effettuazioneScelta property.
     * 
     * @return
     *     possible object is
     *     {@link StEffettuazioneScelta }
     *     
     */
    public StEffettuazioneScelta getEffettuazioneScelta() {
        return effettuazioneScelta;
    }

    /**
     * Sets the value of the effettuazioneScelta property.
     * 
     * @param value
     *     allowed object is
     *     {@link StEffettuazioneScelta }
     *     
     */
    public void setEffettuazioneScelta(StEffettuazioneScelta value) {
        this.effettuazioneScelta = value;
    }

    /**
     * Gets the value of the identificativoPSP property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoPSP() {
        return identificativoPSP;
    }

    /**
     * Sets the value of the identificativoPSP property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoPSP(String value) {
        this.identificativoPSP = value;
    }

    /**
     * Gets the value of the identificativoIntermediarioPSP property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoIntermediarioPSP() {
        return identificativoIntermediarioPSP;
    }

    /**
     * Sets the value of the identificativoIntermediarioPSP property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoIntermediarioPSP(String value) {
        this.identificativoIntermediarioPSP = value;
    }

    /**
     * Gets the value of the identificativoCanale property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoCanale() {
        return identificativoCanale;
    }

    /**
     * Sets the value of the identificativoCanale property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoCanale(String value) {
        this.identificativoCanale = value;
    }

    /**
     * Gets the value of the tipoVersamento property.
     * 
     * @return
     *     possible object is
     *     {@link StTipoVersamento }
     *     
     */
    public StTipoVersamento getTipoVersamento() {
        return tipoVersamento;
    }

    /**
     * Sets the value of the tipoVersamento property.
     * 
     * @param value
     *     allowed object is
     *     {@link StTipoVersamento }
     *     
     */
    public void setTipoVersamento(StTipoVersamento value) {
        this.tipoVersamento = value;
    }

}
