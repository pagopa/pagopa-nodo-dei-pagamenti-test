
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per stTipoVersamento.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * <p>
 * <pre>
 * &lt;simpleType name="stTipoVersamento"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;enumeration value="BBT"/&gt;
 *     &lt;enumeration value="BP"/&gt;
 *     &lt;enumeration value="AD"/&gt;
 *     &lt;enumeration value="CP"/&gt;
 *     &lt;enumeration value="PO"/&gt;
 *     &lt;enumeration value="OBEP"/&gt;
 *     &lt;enumeration value="OTH"/&gt;
 *     &lt;enumeration value="JIF"/&gt;
 *     &lt;enumeration value="MYBK"/&gt;
 *     &lt;enumeration value="PPAL"/&gt;
 *     &lt;maxLength value="4"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "stTipoVersamento", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
@XmlEnum
public enum StTipoVersamento {

    BBT,
    BP,
    AD,
    CP,
    PO,
    OBEP,
    OTH,
    JIF,
    MYBK,
    PPAL;

    public String value() {
        return name();
    }

    public static StTipoVersamento fromValue(String v) {
        return valueOf(v);
    }

}
