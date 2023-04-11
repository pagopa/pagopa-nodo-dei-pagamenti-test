
package eu.sia.nodopa.merged.paaNodoNM4;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Java class for ctDatiSingoloPagamentoRT complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ctDatiSingoloPagamentoRT"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="singoloImportoPagato" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImporto"/&gt;
 *         &lt;element name="esitoSingoloPagamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="dataEsitoSingoloPagamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stISODate"/&gt;
 *         &lt;element name="identificativoUnivocoRiscossione" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&gt;
 *         &lt;element name="causaleVersamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText140"/&gt;
 *         &lt;element name="datiSpecificiRiscossione" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stDatiSpecificiRiscossione"/&gt;
 *         &lt;element name="commissioniApplicatePSP" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImporto" minOccurs="0"/&gt;
 *         &lt;element name="commissioniApplicatePA" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImportoDiversoDaZero" minOccurs="0"/&gt;
 *         &lt;element name="allegatoRicevuta" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctAllegatoRicevuta" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctDatiSingoloPagamentoRT", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "singoloImportoPagato",
    "esitoSingoloPagamento",
    "dataEsitoSingoloPagamento",
    "identificativoUnivocoRiscossione",
    "causaleVersamento",
    "datiSpecificiRiscossione",
    "commissioniApplicatePSP",
    "commissioniApplicatePA",
    "allegatoRicevuta"
})
public class CtDatiSingoloPagamentoRT {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected BigDecimal singoloImportoPagato;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String esitoSingoloPagamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    @XmlSchemaType(name = "date")
    protected XMLGregorianCalendar dataEsitoSingoloPagamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String identificativoUnivocoRiscossione;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String causaleVersamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String datiSpecificiRiscossione;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected BigDecimal commissioniApplicatePSP;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected BigDecimal commissioniApplicatePA;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected CtAllegatoRicevuta allegatoRicevuta;

    /**
     * Gets the value of the singoloImportoPagato property.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getSingoloImportoPagato() {
        return singoloImportoPagato;
    }

    /**
     * Sets the value of the singoloImportoPagato property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setSingoloImportoPagato(BigDecimal value) {
        this.singoloImportoPagato = value;
    }

    /**
     * Gets the value of the esitoSingoloPagamento property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEsitoSingoloPagamento() {
        return esitoSingoloPagamento;
    }

    /**
     * Sets the value of the esitoSingoloPagamento property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEsitoSingoloPagamento(String value) {
        this.esitoSingoloPagamento = value;
    }

    /**
     * Gets the value of the dataEsitoSingoloPagamento property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getDataEsitoSingoloPagamento() {
        return dataEsitoSingoloPagamento;
    }

    /**
     * Sets the value of the dataEsitoSingoloPagamento property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setDataEsitoSingoloPagamento(XMLGregorianCalendar value) {
        this.dataEsitoSingoloPagamento = value;
    }

    /**
     * Gets the value of the identificativoUnivocoRiscossione property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoUnivocoRiscossione() {
        return identificativoUnivocoRiscossione;
    }

    /**
     * Sets the value of the identificativoUnivocoRiscossione property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoUnivocoRiscossione(String value) {
        this.identificativoUnivocoRiscossione = value;
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
     * Gets the value of the commissioniApplicatePSP property.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getCommissioniApplicatePSP() {
        return commissioniApplicatePSP;
    }

    /**
     * Sets the value of the commissioniApplicatePSP property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setCommissioniApplicatePSP(BigDecimal value) {
        this.commissioniApplicatePSP = value;
    }

    /**
     * Gets the value of the commissioniApplicatePA property.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getCommissioniApplicatePA() {
        return commissioniApplicatePA;
    }

    /**
     * Sets the value of the commissioniApplicatePA property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setCommissioniApplicatePA(BigDecimal value) {
        this.commissioniApplicatePA = value;
    }

    /**
     * Gets the value of the allegatoRicevuta property.
     * 
     * @return
     *     possible object is
     *     {@link CtAllegatoRicevuta }
     *     
     */
    public CtAllegatoRicevuta getAllegatoRicevuta() {
        return allegatoRicevuta;
    }

    /**
     * Sets the value of the allegatoRicevuta property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtAllegatoRicevuta }
     *     
     */
    public void setAllegatoRicevuta(CtAllegatoRicevuta value) {
        this.allegatoRicevuta = value;
    }

}
