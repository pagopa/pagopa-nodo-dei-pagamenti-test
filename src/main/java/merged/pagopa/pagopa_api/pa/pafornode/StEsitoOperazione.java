
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per stEsitoOperazione.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * <p>
 * <pre>
 * &lt;simpleType name="stEsitoOperazione"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;length value="2"/&gt;
 *     &lt;enumeration value="OK"/&gt;
 *     &lt;enumeration value="KO"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "stEsitoOperazione", namespace = "http://ws.pagamenti.telematici.gov/")
@XmlEnum
public enum StEsitoOperazione {

    OK,
    KO;

    public String value() {
        return name();
    }

    public static StEsitoOperazione fromValue(String v) {
        return valueOf(v);
    }

}
