
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ctEsitoChiediNumeroAvviso complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ctEsitoChiediNumeroAvviso"&gt;
 *   &lt;complexContent&gt;
 *     &lt;extension base="{http://ws.pagamenti.telematici.gov/}ctRisposta"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="esito" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="numeroAvviso" type="{http://ws.pagamenti.telematici.gov/}ctNumeroAvviso" minOccurs="0"/&gt;
 *         &lt;element name="datiPagamentoPA" type="{http://ws.pagamenti.telematici.gov/}ctDatiPagamentoPA" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/extension&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctEsitoChiediNumeroAvviso", namespace = "http://ws.pagamenti.telematici.gov/", propOrder = {
    "esito",
    "numeroAvviso",
    "datiPagamentoPA"
})
public class CtEsitoChiediNumeroAvviso
    extends CtRisposta
{

    @XmlElement(required = true)
    protected String esito;
    protected CtNumeroAvviso numeroAvviso;
    protected CtDatiPagamentoPA datiPagamentoPA;

    /**
     * Gets the value of the esito property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEsito() {
        return esito;
    }

    /**
     * Sets the value of the esito property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEsito(String value) {
        this.esito = value;
    }

    /**
     * Gets the value of the numeroAvviso property.
     * 
     * @return
     *     possible object is
     *     {@link CtNumeroAvviso }
     *     
     */
    public CtNumeroAvviso getNumeroAvviso() {
        return numeroAvviso;
    }

    /**
     * Sets the value of the numeroAvviso property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtNumeroAvviso }
     *     
     */
    public void setNumeroAvviso(CtNumeroAvviso value) {
        this.numeroAvviso = value;
    }

    /**
     * Gets the value of the datiPagamentoPA property.
     * 
     * @return
     *     possible object is
     *     {@link CtDatiPagamentoPA }
     *     
     */
    public CtDatiPagamentoPA getDatiPagamentoPA() {
        return datiPagamentoPA;
    }

    /**
     * Sets the value of the datiPagamentoPA property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtDatiPagamentoPA }
     *     
     */
    public void setDatiPagamentoPA(CtDatiPagamentoPA value) {
        this.datiPagamentoPA = value;
    }

}
