
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per ctDatiMarcaBolloDigitale complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctDatiMarcaBolloDigitale"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="tipoBollo" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stTipoBollo"/&gt;
 *         &lt;element name="hashDocumento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stBase64Binary70"/&gt;
 *         &lt;element name="provinciaResidenza" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stNazioneProvincia"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctDatiMarcaBolloDigitale", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "tipoBollo",
    "hashDocumento",
    "provinciaResidenza"
})
public class CtDatiMarcaBolloDigitale {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String tipoBollo;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected byte[] hashDocumento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String provinciaResidenza;

    /**
     * Recupera il valore della proprieta tipoBollo.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTipoBollo() {
        return tipoBollo;
    }

    /**
     * Imposta il valore della proprieta tipoBollo.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTipoBollo(String value) {
        this.tipoBollo = value;
    }

    /**
     * Recupera il valore della proprieta hashDocumento.
     * 
     * @return
     *     possible object is
     *     byte[]
     */
    public byte[] getHashDocumento() {
        return hashDocumento;
    }

    /**
     * Imposta il valore della proprieta hashDocumento.
     * 
     * @param value
     *     allowed object is
     *     byte[]
     */
    public void setHashDocumento(byte[] value) {
        this.hashDocumento = value;
    }

    /**
     * Recupera il valore della proprieta provinciaResidenza.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getProvinciaResidenza() {
        return provinciaResidenza;
    }

    /**
     * Imposta il valore della proprieta provinciaResidenza.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setProvinciaResidenza(String value) {
        this.provinciaResidenza = value;
    }

}
