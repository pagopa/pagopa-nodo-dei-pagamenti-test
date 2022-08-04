
package generazioneAvvisi.ws;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the rt.gov.telematici.pagamenti.ws package. 
 * &lt;p&gt;An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _PaaChiediNumeroAvviso_QNAME = new QName("http://ws.pagamenti.telematici.gov/", "paaChiediNumeroAvviso");
    private final static QName _PaaChiediNumeroAvvisoRisposta_QNAME = new QName("http://ws.pagamenti.telematici.gov/", "paaChiediNumeroAvvisoRisposta");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: rt.gov.telematici.pagamenti.ws
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link PaaChiediNumeroAvviso }
     * 
     */
    public PaaChiediNumeroAvviso createPaaChiediNumeroAvviso() {
        return new PaaChiediNumeroAvviso();
    }

    /**
     * Create an instance of {@link PaaChiediNumeroAvvisoRisposta }
     * 
     */
    public PaaChiediNumeroAvvisoRisposta createPaaChiediNumeroAvvisoRisposta() {
        return new PaaChiediNumeroAvvisoRisposta();
    }

    /**
     * Create an instance of {@link CtNumeroAvviso }
     * 
     */
    public CtNumeroAvviso createCtNumeroAvviso() {
        return new CtNumeroAvviso();
    }

    /**
     * Create an instance of {@link CtFaultBean }
     * 
     */
    public CtFaultBean createCtFaultBean() {
        return new CtFaultBean();
    }

    /**
     * Create an instance of {@link CtRisposta }
     * 
     */
    public CtRisposta createCtRisposta() {
        return new CtRisposta();
    }

    /**
     * Create an instance of {@link CtSpezzoniCausaleVersamento }
     * 
     */
    public CtSpezzoniCausaleVersamento createCtSpezzoniCausaleVersamento() {
        return new CtSpezzoniCausaleVersamento();
    }

    /**
     * Create an instance of {@link CtSpezzoneStrutturatoCausaleVersamento }
     * 
     */
    public CtSpezzoneStrutturatoCausaleVersamento createCtSpezzoneStrutturatoCausaleVersamento() {
        return new CtSpezzoneStrutturatoCausaleVersamento();
    }

    /**
     * Create an instance of {@link CtDatiPagamentoPA }
     * 
     */
    public CtDatiPagamentoPA createCtDatiPagamentoPA() {
        return new CtDatiPagamentoPA();
    }

    /**
     * Create an instance of {@link CtEsitoChiediNumeroAvviso }
     * 
     */
    public CtEsitoChiediNumeroAvviso createCtEsitoChiediNumeroAvviso() {
        return new CtEsitoChiediNumeroAvviso();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaaChiediNumeroAvviso }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link PaaChiediNumeroAvviso }{@code >}
     */
    @XmlElementDecl(namespace = "http://ws.pagamenti.telematici.gov/", name = "paaChiediNumeroAvviso")
    public JAXBElement<PaaChiediNumeroAvviso> createPaaChiediNumeroAvviso(PaaChiediNumeroAvviso value) {
        return new JAXBElement<PaaChiediNumeroAvviso>(_PaaChiediNumeroAvviso_QNAME, PaaChiediNumeroAvviso.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PaaChiediNumeroAvvisoRisposta }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link PaaChiediNumeroAvvisoRisposta }{@code >}
     */
    @XmlElementDecl(namespace = "http://ws.pagamenti.telematici.gov/", name = "paaChiediNumeroAvvisoRisposta")
    public JAXBElement<PaaChiediNumeroAvvisoRisposta> createPaaChiediNumeroAvvisoRisposta(PaaChiediNumeroAvvisoRisposta value) {
        return new JAXBElement<PaaChiediNumeroAvvisoRisposta>(_PaaChiediNumeroAvvisoRisposta_QNAME, PaaChiediNumeroAvvisoRisposta.class, null, value);
    }

}
