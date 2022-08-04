
package generazioneAvvisi.ws;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElements;
import javax.xml.bind.annotation.XmlType;


/**
 * &lt;p&gt;Java class for ctSpezzoniCausaleVersamento complex type.
 * 
 * &lt;p&gt;The following schema fragment specifies the expected content contained within this class.
 * 
 * &lt;pre&gt;
 * &amp;lt;complexType name="ctSpezzoniCausaleVersamento"&amp;gt;
 *   &amp;lt;complexContent&amp;gt;
 *     &amp;lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&amp;gt;
 *       &amp;lt;sequence maxOccurs="6"&amp;gt;
 *         &amp;lt;choice&amp;gt;
 *           &amp;lt;element name="spezzoneCausaleVersamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&amp;gt;
 *           &amp;lt;element name="spezzoneStrutturatoCausaleVersamento" type="{http://ws.pagamenti.telematici.gov/}ctSpezzoneStrutturatoCausaleVersamento"/&amp;gt;
 *         &amp;lt;/choice&amp;gt;
 *       &amp;lt;/sequence&amp;gt;
 *     &amp;lt;/restriction&amp;gt;
 *   &amp;lt;/complexContent&amp;gt;
 * &amp;lt;/complexType&amp;gt;
 * &lt;/pre&gt;
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctSpezzoniCausaleVersamento", propOrder = {
    "spezzoneCausaleVersamentoOrSpezzoneStrutturatoCausaleVersamento"
})
public class CtSpezzoniCausaleVersamento {

    @XmlElements({
        @XmlElement(name = "spezzoneCausaleVersamento", type = String.class),
        @XmlElement(name = "spezzoneStrutturatoCausaleVersamento", type = CtSpezzoneStrutturatoCausaleVersamento.class)
    })
    protected List<Object> spezzoneCausaleVersamentoOrSpezzoneStrutturatoCausaleVersamento;

    /**
     * Gets the value of the spezzoneCausaleVersamentoOrSpezzoneStrutturatoCausaleVersamento property.
     * 
     * &lt;p&gt;
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a &lt;CODE&gt;set&lt;/CODE&gt; method for the spezzoneCausaleVersamentoOrSpezzoneStrutturatoCausaleVersamento property.
     * 
     * &lt;p&gt;
     * For example, to add a new item, do as follows:
     * &lt;pre&gt;
     *    getSpezzoneCausaleVersamentoOrSpezzoneStrutturatoCausaleVersamento().add(newItem);
     * &lt;/pre&gt;
     * 
     * 
     * &lt;p&gt;
     * Objects of the following type(s) are allowed in the list
     * {@link String }
     * {@link CtSpezzoneStrutturatoCausaleVersamento }
     * 
     * 
     */
    public List<Object> getSpezzoneCausaleVersamentoOrSpezzoneStrutturatoCausaleVersamento() {
        if (spezzoneCausaleVersamentoOrSpezzoneStrutturatoCausaleVersamento == null) {
            spezzoneCausaleVersamentoOrSpezzoneStrutturatoCausaleVersamento = new ArrayList<Object>();
        }
        return this.spezzoneCausaleVersamentoOrSpezzoneStrutturatoCausaleVersamento;
    }

}
