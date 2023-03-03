
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per ctSoggettoPagatore complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctSoggettoPagatore"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="identificativoUnivocoPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctIdentificativoUnivocoPersonaFG"/&gt;
 *         &lt;element name="anagraficaPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText70"/&gt;
 *         &lt;element name="indirizzoPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText70" minOccurs="0"/&gt;
 *         &lt;element name="civicoPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText16" minOccurs="0"/&gt;
 *         &lt;element name="capPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText16" minOccurs="0"/&gt;
 *         &lt;element name="localitaPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="provinciaPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="nazionePagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stNazioneProvincia" minOccurs="0"/&gt;
 *         &lt;element name="e-mailPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stEMail" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctSoggettoPagatore", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "identificativoUnivocoPagatore",
    "anagraficaPagatore",
    "indirizzoPagatore",
    "civicoPagatore",
    "capPagatore",
    "localitaPagatore",
    "provinciaPagatore",
    "nazionePagatore",
    "eMailPagatore"
})
public class CtSoggettoPagatore {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtIdentificativoUnivocoPersonaFG identificativoUnivocoPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String anagraficaPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String indirizzoPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String civicoPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String capPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String localitaPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String provinciaPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String nazionePagatore;
    @XmlElement(name = "e-mailPagatore", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String eMailPagatore;

    /**
     * Recupera il valore della proprieta identificativoUnivocoPagatore.
     * 
     * @return
     *     possible object is
     *     {@link CtIdentificativoUnivocoPersonaFG }
     *     
     */
    public CtIdentificativoUnivocoPersonaFG getIdentificativoUnivocoPagatore() {
        return identificativoUnivocoPagatore;
    }

    /**
     * Imposta il valore della proprieta identificativoUnivocoPagatore.
     * 
     * @param value
     *     allowed object is
     *     {@link CtIdentificativoUnivocoPersonaFG }
     *     
     */
    public void setIdentificativoUnivocoPagatore(CtIdentificativoUnivocoPersonaFG value) {
        this.identificativoUnivocoPagatore = value;
    }

    /**
     * Recupera il valore della proprieta anagraficaPagatore.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAnagraficaPagatore() {
        return anagraficaPagatore;
    }

    /**
     * Imposta il valore della proprieta anagraficaPagatore.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAnagraficaPagatore(String value) {
        this.anagraficaPagatore = value;
    }

    /**
     * Recupera il valore della proprieta indirizzoPagatore.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIndirizzoPagatore() {
        return indirizzoPagatore;
    }

    /**
     * Imposta il valore della proprieta indirizzoPagatore.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIndirizzoPagatore(String value) {
        this.indirizzoPagatore = value;
    }

    /**
     * Recupera il valore della proprieta civicoPagatore.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCivicoPagatore() {
        return civicoPagatore;
    }

    /**
     * Imposta il valore della proprieta civicoPagatore.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCivicoPagatore(String value) {
        this.civicoPagatore = value;
    }

    /**
     * Recupera il valore della proprieta capPagatore.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCapPagatore() {
        return capPagatore;
    }

    /**
     * Imposta il valore della proprieta capPagatore.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCapPagatore(String value) {
        this.capPagatore = value;
    }

    /**
     * Recupera il valore della proprieta localitaPagatore.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLocalitaPagatore() {
        return localitaPagatore;
    }

    /**
     * Imposta il valore della proprieta localitaPagatore.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLocalitaPagatore(String value) {
        this.localitaPagatore = value;
    }

    /**
     * Recupera il valore della proprieta provinciaPagatore.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getProvinciaPagatore() {
        return provinciaPagatore;
    }

    /**
     * Imposta il valore della proprieta provinciaPagatore.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setProvinciaPagatore(String value) {
        this.provinciaPagatore = value;
    }

    /**
     * Recupera il valore della proprieta nazionePagatore.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNazionePagatore() {
        return nazionePagatore;
    }

    /**
     * Imposta il valore della proprieta nazionePagatore.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNazionePagatore(String value) {
        this.nazionePagatore = value;
    }

    /**
     * Recupera il valore della proprieta eMailPagatore.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEMailPagatore() {
        return eMailPagatore;
    }

    /**
     * Imposta il valore della proprieta eMailPagatore.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEMailPagatore(String value) {
        this.eMailPagatore = value;
    }

}
