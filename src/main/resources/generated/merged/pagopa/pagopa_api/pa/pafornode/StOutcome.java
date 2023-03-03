
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per stOutcome.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * <p>
 * <pre>
 * &lt;simpleType name="stOutcome"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;enumeration value="OK"/&gt;
 *     &lt;enumeration value="KO"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "stOutcome", namespace = "http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/")
@XmlEnum
public enum StOutcome {

    OK,
    KO;

    public String value() {
        return name();
    }

    public static StOutcome fromValue(String v) {
        return valueOf(v);
    }

}
