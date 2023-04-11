
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for stTransferType.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <pre>
 * &lt;simpleType name="stTransferType"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;enumeration value="POSTAL"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "stTransferType")
@XmlEnum
public enum StTransferType {

    POSTAL;

    public String value() {
        return name();
    }

    public static StTransferType fromValue(String v) {
        return valueOf(v);
    }

}
