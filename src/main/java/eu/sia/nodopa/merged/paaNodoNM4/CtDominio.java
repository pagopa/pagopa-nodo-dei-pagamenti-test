
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ctDominio complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ctDominio"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="identificativoDominio" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&gt;
 *         &lt;element name="identificativoStazioneRichiedente" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctDominio", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "identificativoDominio",
    "identificativoStazioneRichiedente"
})
public class CtDominio {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String identificativoDominio;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String identificativoStazioneRichiedente;

    /**
     * Gets the value of the identificativoDominio property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoDominio() {
        return identificativoDominio;
    }

    /**
     * Sets the value of the identificativoDominio property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoDominio(String value) {
        this.identificativoDominio = value;
    }

    /**
     * Gets the value of the identificativoStazioneRichiedente property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoStazioneRichiedente() {
        return identificativoStazioneRichiedente;
    }

    /**
     * Sets the value of the identificativoStazioneRichiedente property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoStazioneRichiedente(String value) {
        this.identificativoStazioneRichiedente = value;
    }

}
