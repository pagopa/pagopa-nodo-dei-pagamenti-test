
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per stTipoAzioneAggiornamento.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * <p>
 * <pre>
 * &lt;simpleType name="stTipoAzioneAggiornamento"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;length value="1"/&gt;
 *     &lt;enumeration value="A"/&gt;
 *     &lt;enumeration value="D"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "stTipoAzioneAggiornamento", namespace = "http://ws.pagamenti.telematici.gov/")
@XmlEnum
public enum StTipoAzioneAggiornamento {

    A,
    D;

    public String value() {
        return name();
    }

    public static StTipoAzioneAggiornamento fromValue(String v) {
        return valueOf(v);
    }

}
