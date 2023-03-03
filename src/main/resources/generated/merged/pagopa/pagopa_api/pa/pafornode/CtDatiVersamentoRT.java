
package merged.pagopa.pagopa_api.pa.pafornode;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per ctDatiVersamentoRT complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctDatiVersamentoRT"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="codiceEsitoPagamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stCodiceEsitoPagamento"/&gt;
 *         &lt;element name="importoTotalePagato" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImporto"/&gt;
 *         &lt;element name="identificativoUnivocoVersamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&gt;
 *         &lt;element name="CodiceContestoPagamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&gt;
 *         &lt;element name="datiSingoloPagamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctDatiSingoloPagamentoRT" maxOccurs="5" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctDatiVersamentoRT", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "codiceEsitoPagamento",
    "importoTotalePagato",
    "identificativoUnivocoVersamento",
    "codiceContestoPagamento",
    "datiSingoloPagamento"
})
public class CtDatiVersamentoRT {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String codiceEsitoPagamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected BigDecimal importoTotalePagato;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String identificativoUnivocoVersamento;
    @XmlElement(name = "CodiceContestoPagamento", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String codiceContestoPagamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected List<CtDatiSingoloPagamentoRT> datiSingoloPagamento;

    /**
     * Recupera il valore della proprieta codiceEsitoPagamento.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCodiceEsitoPagamento() {
        return codiceEsitoPagamento;
    }

    /**
     * Imposta il valore della proprieta codiceEsitoPagamento.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCodiceEsitoPagamento(String value) {
        this.codiceEsitoPagamento = value;
    }

    /**
     * Recupera il valore della proprieta importoTotalePagato.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getImportoTotalePagato() {
        return importoTotalePagato;
    }

    /**
     * Imposta il valore della proprieta importoTotalePagato.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setImportoTotalePagato(BigDecimal value) {
        this.importoTotalePagato = value;
    }

    /**
     * Recupera il valore della proprieta identificativoUnivocoVersamento.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoUnivocoVersamento() {
        return identificativoUnivocoVersamento;
    }

    /**
     * Imposta il valore della proprieta identificativoUnivocoVersamento.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoUnivocoVersamento(String value) {
        this.identificativoUnivocoVersamento = value;
    }

    /**
     * Recupera il valore della proprieta codiceContestoPagamento.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCodiceContestoPagamento() {
        return codiceContestoPagamento;
    }

    /**
     * Imposta il valore della proprieta codiceContestoPagamento.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCodiceContestoPagamento(String value) {
        this.codiceContestoPagamento = value;
    }

    /**
     * Gets the value of the datiSingoloPagamento property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the datiSingoloPagamento property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getDatiSingoloPagamento().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link CtDatiSingoloPagamentoRT }
     * 
     * 
     */
    public List<CtDatiSingoloPagamentoRT> getDatiSingoloPagamento() {
        if (datiSingoloPagamento == null) {
            datiSingoloPagamento = new ArrayList<CtDatiSingoloPagamentoRT>();
        }
        return this.datiSingoloPagamento;
    }

}
