
package merged.pagopa.pagopa_api.pa.pafornode;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * 
 * Structure containing the details of possible tranfer payments.
 * 
 * Currently set at 5 eligible payments per single position.
 * 
 * Where each `transfer` items contains :
 * 
 * - `idTransfer` : index of the list (from `1` to `5`) 
 * - `transferAmount` : amount 
 * - `fiscalCodePA` : Tax code of the public administration
 * - `IBAN` : contains the IBAN of the account to be credited
 * - `remittanceInformation` : reason for payment (_alias_ `causaleVersamento`)
 * - `transferCategory` : contains taxonomic code, composed by `Codice tipo Ente Creditore`+`Progressivo macro area`+`Codice tipologia servizio`+`Motivo Giuridico` ( ex. `0101002IM` ) 
 * | Segment                     | Regex                       |Example |
 * |-----------------------------|-----------------------------|--------|
 * |Codice tipo Ente Creditore   | `\d{2}`                     | 01     |
 * |Progressivo macro area       | `\d{2}`                     | 01     |
 * |Codice tipologia servizio    | `\d{2}`                     | 002    |
 * |Motivo Giuridico             | `\w{2}`                     | IM     |
 * 
 *       
 * 
 * <p>Classe Java per ctTransferListPA complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctTransferListPA"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="transfer" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctTransferPA" maxOccurs="5"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctTransferListPA", propOrder = {
    "transfer"
})
public class CtTransferListPA {

    @XmlElement(required = true)
    protected List<CtTransferPA> transfer;

    /**
     * Gets the value of the transfer property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the transfer property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getTransfer().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link CtTransferPA }
     * 
     * 
     */
    public List<CtTransferPA> getTransfer() {
        if (transfer == null) {
            transfer = new ArrayList<CtTransferPA>();
        }
        return this.transfer;
    }

}
