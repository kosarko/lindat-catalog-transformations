Use the uniq db api as the source for "harvest". The fetching could be moved into the .xq.
The commands below create one huge file and then split it into multiple small ones. These are ready to be processed with dspace2solr.xslt and imported

```
curl "https://uniq.flu.cas.cz/api/v1/manuscripts" > uniq_flu_cas_cz_api_v1_manuscripts.json
curl "https://uniq.flu.cas.cz/api/v1/universals" > uniq_flu_cas_cz_api_v1_universals.json
java -cp Saxon-HE-10.3.jar net.sf.saxon.Query -q:json-to-xml.xq  > my_uniq.xml
mkdir out
cd out/
java -jar Saxon-HE-10.3.jar -s:../my_uniq.xml -xsl:../split.xslt
lindat-catalog-transformations/scripts/apply_in_order.sh -s . -o /tmp/uniq_solr -p "UNIQ" dspace
```
