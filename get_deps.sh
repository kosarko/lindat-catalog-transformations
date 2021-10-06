#!/usr/bin/env bash
function terms {
	cat <<EOF
ISO 639-3 Code Tables Terms of Use
The ISO 639-3 code set may be downloaded and incorporated into software products, web-based systems, digital devices, etc., either commercial or non-commercial, provided that:

attribution is given www.iso639-3.sil.org as the source of the codes;
the identifiers of the code set are not modified or extended except as may be privately agreed using the Private Use Area (range qaa to qtz), and then such extensions shall not be distributed publicly;
the product, system, or device does not provide a means to redistribute the code set.
Expansions to the information provided by the standard (e.g., population data, names in other languages, geographic coordinates, etc.) may be made and distributed as long as such added information is clearly identified as not being part of the standard itself. The ISO 639-3 website is the only authorized distribution site for the ISO 639-3 code tables.

For any questions about whether a particular use is covered by these guidelines, contact the Registration Authority at ISO639-3@sil.org.
EOF
}

terms
curl -s "https://iso639-3.sil.org/sites/iso639-3/files/downloads/iso-639-3.tab" | tail -n +2 | awk -F'\t' -vRS='\r?\n' 'BEGIN{print "<languages>"} END{print "</languages>"} {print "<language><id>" $1 "</id><Part2B>" $2 "</Part2B><Part2T>" $3 "</Part2T><Part1>" $4 "</Part1><Ref_Name>" $7 "</Ref_Name></language>"}' | xmllint --format - > iso-639-3.xml

mvn dependency:get -Dartifact=net.sf.saxon:Saxon-HE:LATEST -Ddest=.
