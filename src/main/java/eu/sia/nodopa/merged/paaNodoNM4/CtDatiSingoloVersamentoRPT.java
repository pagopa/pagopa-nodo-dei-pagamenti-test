
package eu.sia.nodopa.merged.paaNodoNM4;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ctDatiSingoloVersamentoRPT complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ctDatiSingoloVersamentoRPT"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="importoSingoloVersamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImportoDiversoDaZero"/&gt;
 *         &lt;element name="commissioneCaricoPA" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImportoDiversoDaZero" minOccurs="0"/&gt;
 *         &lt;element name="ibanAccredito" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stIBANIdentifier" minOccurs="0"/&gt;
 *         &lt;element name="bicAccredito" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stBICIdentifier" minOccurs="0"/&gt;
 *         &lt;element name="ibanAppoggio" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stIBANIdentifier" minOccurs="0"/&gt;
 *         &lt;element name="bicAppoggio" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stBICIdentifier" minOccurs="0"/&gt;
 *         &lt;element name="credenzialiPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="causaleVersamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText140"/&gt;
 *         &lt;element name="datiSpecificiRiscossione" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stDatiSpecificiRiscossione"/&gt;
 *         &lt;element name="datiMarcaBolloDigitale" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctDatiMarcaBolloDigitale" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctDatiSingoloVersamentoRPT", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "importoSingoloVersamento",
    "commissioneCaricoPA",
    "ibanAccredito",
    "bicAccredito",
    "ibanAppoggio",
    "bicAppoggio",
    "credenzialiPagatore",
    "causaleVersamento",
    "datiSpecificiRiscossione",
    "datiMarcaBolloDigitale"
})
public class CtDatiSingoloVersamentoRPT {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected BigDecimal importoSingoloVersamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected BigDecimal commissioneCaricoPA;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String ibanAccredito;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String bicAccredito;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String ibanAppoggio;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String bicAppoggio;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String credenzialiPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String causaleVersamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String datiSpecificiRiscossione;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected CtDatiMarcaBolloDigitale datiMarcaBolloDigitale;

    /**
     * Gets the value of the importoSingoloVersamento property.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getImportoSingoloVersamento() {
        return importoSingoloVersamento;
    }

    /**
     * Sets the value of the importoSingoloVersamento property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setImportoSingoloVersamento(BigDecimal value) {
        this.importoSingoloVersamento = value;
    }

    /**
     * Gets the value of the commissioneCaricoPA property.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getCommissioneCaricoPA() {
        return commissioneCaricoPA;
    }

    /**
     * Sets the value of the commissioneCaricoPA property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setCommissioneCaricoPA(BigDecimal value) {
        this.commissioneCaricoPA = value;
    }

    /**
     * Gets the value of the ibanAccredito property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIbanAccredito() {
        return ibanAccredito;
    }

    /**
     * Sets the value of the ibanAccredito property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIbanAccredito(String value) {
        this.ibanAccredito = value;
    }

    /**
     * Gets the value of the bicAccredito property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getBicAccredito() {
        return bicAccredito;
    }

    /**
     * Sets the value of the bicAccredito property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setBicAccredito(String value) {
        this.bicAccredito = value;
    }

    /**
     * Gets the value of the ibanAppoggio property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIbanAppoggio() {
        return ibanAppoggio;
    }

    /**
     * Sets the value of the ibanAppoggio property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIbanAppoggio(String value) {
        this.ibanAppoggio = value;
    }

    /**
     * Gets the value of the bicAppoggio property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getBicAppoggio() {
        return bicAppoggio;
    }

    /**
     * Sets the value of the bicAppoggio property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setBicAppoggio(String value) {
        this.bicAppoggio = value;
    }

    /**
     * Gets the value of the credenzialiPagatore property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCredenzialiPagatore() {
        return credenzialiPagatore;
    }

    /**
     * Sets the value of the credenzialiPagatore property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCredenzialiPagatore(String value) {
        this.credenzialiPagatore = value;
    }

    /**
     * Gets the value of the causaleVersamento property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausaleVersamento() {
        return causaleVersamento;
    }

    /**
     * Sets the value of the causaleVersamento property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausaleVersamento(String value) {
        this.causaleVersamento = value;
    }

    /**
     * Gets the value of the datiSpecificiRiscossione property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDatiSpecificiRiscossione() {
        return datiSpecificiRiscossione;
    }

    /**
     * Sets the value of the datiSpecificiRiscossione property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDatiSpecificiRiscossione(String value) {
        this.datiSpecificiRiscossione = value;
    }

    /**
     * Gets the value of the datiMarcaBolloDigitale property.
     * 
     * @return
     *     possible object is
     *     {@link CtDatiMarcaBolloDigitale }
     *     
     */
    public CtDatiMarcaBolloDigitale getDatiMarcaBolloDigitale() {
        return datiMarcaBolloDigitale;
    }

    /**
     * Sets the value of the datiMarcaBolloDigitale property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtDatiMarcaBolloDigitale }
     *     
     */
    public void setDatiMarcaBolloDigitale(CtDatiMarcaBolloDigitale value) {
        this.datiMarcaBolloDigitale = value;
    }

}
