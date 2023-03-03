
package merged.pagopa.pagopa_api.pa.pafornode;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per paaTipoDatiPagamentoPA complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="paaTipoDatiPagamentoPA"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="importoSingoloVersamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImporto"/&gt;
 *         &lt;element name="ibanAccredito" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stIBANIdentifier"/&gt;
 *         &lt;element name="bicAccredito" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stBICIdentifier" minOccurs="0"/&gt;
 *         &lt;element name="enteBeneficiario" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctEnteBeneficiario" minOccurs="0"/&gt;
 *         &lt;element name="credenzialiPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;choice&gt;
 *           &lt;element name="causaleVersamento" type="{http://ws.pagamenti.telematici.gov/}stCausaleVersamento"/&gt;
 *           &lt;element name="spezzoniCausaleVersamento" type="{http://ws.pagamenti.telematici.gov/}ctSpezzoniCausaleVersamento"/&gt;
 *         &lt;/choice&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paaTipoDatiPagamentoPA", namespace = "http://ws.pagamenti.telematici.gov/", propOrder = {
    "importoSingoloVersamento",
    "ibanAccredito",
    "bicAccredito",
    "enteBeneficiario",
    "credenzialiPagatore",
    "causaleVersamento",
    "spezzoniCausaleVersamento"
})
public class PaaTipoDatiPagamentoPA {

    @XmlElement(required = true)
    protected BigDecimal importoSingoloVersamento;
    @XmlElement(required = true)
    protected String ibanAccredito;
    protected String bicAccredito;
    protected CtEnteBeneficiario enteBeneficiario;
    protected String credenzialiPagatore;
    protected String causaleVersamento;
    protected CtSpezzoniCausaleVersamento spezzoniCausaleVersamento;

    /**
     * Recupera il valore della proprieta importoSingoloVersamento.
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
     * Imposta il valore della proprieta importoSingoloVersamento.
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
     * Recupera il valore della proprieta ibanAccredito.
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
     * Imposta il valore della proprieta ibanAccredito.
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
     * Recupera il valore della proprieta bicAccredito.
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
     * Imposta il valore della proprieta bicAccredito.
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
     * Recupera il valore della proprieta enteBeneficiario.
     * 
     * @return
     *     possible object is
     *     {@link CtEnteBeneficiario }
     *     
     */
    public CtEnteBeneficiario getEnteBeneficiario() {
        return enteBeneficiario;
    }

    /**
     * Imposta il valore della proprieta enteBeneficiario.
     * 
     * @param value
     *     allowed object is
     *     {@link CtEnteBeneficiario }
     *     
     */
    public void setEnteBeneficiario(CtEnteBeneficiario value) {
        this.enteBeneficiario = value;
    }

    /**
     * Recupera il valore della proprieta credenzialiPagatore.
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
     * Imposta il valore della proprieta credenzialiPagatore.
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
     * Recupera il valore della proprieta causaleVersamento.
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
     * Imposta il valore della proprieta causaleVersamento.
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
     * Recupera il valore della proprieta spezzoniCausaleVersamento.
     * 
     * @return
     *     possible object is
     *     {@link CtSpezzoniCausaleVersamento }
     *     
     */
    public CtSpezzoniCausaleVersamento getSpezzoniCausaleVersamento() {
        return spezzoniCausaleVersamento;
    }

    /**
     * Imposta il valore della proprieta spezzoniCausaleVersamento.
     * 
     * @param value
     *     allowed object is
     *     {@link CtSpezzoniCausaleVersamento }
     *     
     */
    public void setSpezzoniCausaleVersamento(CtSpezzoniCausaleVersamento value) {
        this.spezzoniCausaleVersamento = value;
    }

}
