
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * 
 * Its a response to `paVerifyPaymentNoticeReq` and contains :
 * 
 * - `outcome` and _optional_ `fault` (_see below to details_)
 * - `paymentList` : the list of all available payment options (_see below to details_)
 * - `paymentDescription` : 
 * 
 * If the Public Administration is configured as _OLD_ (i.e. still uses the old primitives) this field must be set with the data `nodeTipoDatiPagamentoPA` of the` nodeVerificaRPTRanspond` specifically:
 * - `causaleVersamento`: represents the extended description of the reason for the payment, or
 * - `spezzoniCausaleVersamento`: structure available to Public Administration to specify the payment reasons.
 * 
 * The size of the current field is such as to allow the concatenation of the old information previously described.
 * 
 * - `fiscalCodePA` : Tax code of the public administration
 * - `companyName` : Public Administration full name
 * - `officeName` : Public Administration Department Name
 *     
 * 
 * <p>Classe Java per paVerifyPaymentNoticeRes complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="paVerifyPaymentNoticeRes"&gt;
 *   &lt;complexContent&gt;
 *     &lt;extension base="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctResponse"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="paymentList" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctPaymentOptionsDescriptionListPA" minOccurs="0"/&gt;
 *         &lt;element name="paymentDescription" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText140" minOccurs="0"/&gt;
 *         &lt;element name="fiscalCodePA" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stFiscalCodePA" minOccurs="0"/&gt;
 *         &lt;element name="companyName" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText140" minOccurs="0"/&gt;
 *         &lt;element name="officeName" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText140" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/extension&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paVerifyPaymentNoticeRes", propOrder = {
    "paymentList",
    "paymentDescription",
    "fiscalCodePA",
    "companyName",
    "officeName"
})
public class PaVerifyPaymentNoticeRes
    extends CtResponse
{

    protected CtPaymentOptionsDescriptionListPA paymentList;
    protected String paymentDescription;
    protected String fiscalCodePA;
    protected String companyName;
    protected String officeName;

    /**
     * Recupera il valore della proprietà paymentList.
     * 
     * @return
     *     possible object is
     *     {@link CtPaymentOptionsDescriptionListPA }
     *     
     */
    public CtPaymentOptionsDescriptionListPA getPaymentList() {
        return paymentList;
    }

    /**
     * Imposta il valore della proprietà paymentList.
     * 
     * @param value
     *     allowed object is
     *     {@link CtPaymentOptionsDescriptionListPA }
     *     
     */
    public void setPaymentList(CtPaymentOptionsDescriptionListPA value) {
        this.paymentList = value;
    }

    /**
     * Recupera il valore della proprietà paymentDescription.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPaymentDescription() {
        return paymentDescription;
    }

    /**
     * Imposta il valore della proprietà paymentDescription.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPaymentDescription(String value) {
        this.paymentDescription = value;
    }

    /**
     * Recupera il valore della proprietà fiscalCodePA.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFiscalCodePA() {
        return fiscalCodePA;
    }

    /**
     * Imposta il valore della proprietà fiscalCodePA.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFiscalCodePA(String value) {
        this.fiscalCodePA = value;
    }

    /**
     * Recupera il valore della proprietà companyName.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCompanyName() {
        return companyName;
    }

    /**
     * Imposta il valore della proprietà companyName.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCompanyName(String value) {
        this.companyName = value;
    }

    /**
     * Recupera il valore della proprietà officeName.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOfficeName() {
        return officeName;
    }

    /**
     * Imposta il valore della proprietà officeName.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOfficeName(String value) {
        this.officeName = value;
    }

}
