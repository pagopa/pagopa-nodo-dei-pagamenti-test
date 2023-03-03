
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per stAmountOption.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * <p>
 * <pre>
 * &lt;simpleType name="stAmountOption"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;enumeration value="EQ"/&gt;
 *     &lt;enumeration value="LS"/&gt;
 *     &lt;enumeration value="GT"/&gt;
 *     &lt;enumeration value="ANY"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "stAmountOption")
@XmlEnum
public enum StAmountOption {

    EQ,
    LS,
    GT,
    ANY;

    public String value() {
        return name();
    }

    public static StAmountOption fromValue(String v) {
        return valueOf(v);
    }

}
