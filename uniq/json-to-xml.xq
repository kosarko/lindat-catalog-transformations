declare namespace map='http://www.w3.org/2005/xpath-functions/map';
declare namespace array='http://www.w3.org/2005/xpath-functions/array';
declare namespace saxon="http://saxon.sf.net/";
declare option saxon:output "indent=yes";

(:let $manuscripts := json-doc('./uniq_flu_cas_cz_api_v1_manuscripts-universals.json'):)
let $manuscripts := json-doc('./uniq_flu_cas_cz_api_v1_manuscripts.json')
let $size_manuscripts := array:size($manuscripts)

let $universals := json-doc('./uniq_flu_cas_cz_api_v1_universals.json')
let $size_universals := array:size($universals)
let $uniq :=
<uniq>
<manuscripts>
{
for $i in (1 to $size_manuscripts)
  let $manuscript := $manuscripts($i)
  return
    <dublin_core schema="dc">
    {
    for $key in map:keys($manuscript)
        let $val := if ($manuscript($key) instance of xs:string) then normalize-space($manuscript($key)) else ()
        let $o := switch($key)
        case 'id'
            return (
                <dcvalue element="identifier">{$val}</dcvalue>,
                <dcvalue element="landingPage">{concat('https://uniq.flu.cas.cz/manuscripts/', $val)}</dcvalue>,
                <dcvalue element="type">manuscript</dcvalue>,
                <dcvalue element="subject">Prague struggle over universals ca. 1348–1500</dcvalue>,
                <dcvalue element="rights">unknown</dcvalue>
            )
        case 'origin'
            return <dcvalue element="date">{$val}</dcvalue>
        case 'shelfmark'
            return <dcvalue element="title">{$val}</dcvalue>
        case 'universals'
            (:concat universals, catalog, digitalcopy into description:)
            return
                let $description := 'The manuscript contains the following texts on universals:&#xA;'
                let $linked_universals := $manuscript($key)
                let $catalogue := normalize-space($manuscript?catalogue)
                let $digital_copy := normalize-space($manuscript?digital_copy)
                let $s_u := array:size($linked_universals)
                return 
                    <dcvalue element="description">
                    {
                        concat($description, string-join(
                                for $j in (1 to $s_u)
                                    let $u := $linked_universals($j)
                                    return concat($u?author_names, ': ', $u?title)
                      , '&#xA;'),
                      if ($catalogue) then concat('&#xA;&#xA;Catalogue:&#xA;', $catalogue) else '',
                      if ($digital_copy) then concat('(', $digital_copy, ')') else ''
                      )
                    }
                    </dcvalue>
        case 'facsimile'
            return <dcvalue element="metadataOnly">{if ($val) then 'false' else 'true'}</dcvalue>
        default return ()
        return $o
(:
title
metadataOnly
all_as_cdata
identifier
landingPage
rights
:)
    }
        <dcvalue element="original_metadata">{concat('&lt;root&gt;', serialize($manuscript, map{"method": "json"}),'&lt;/root&gt;')}</dcvalue>
    </dublin_core>
}
</manuscripts>
<universals>
{
for $i in (1 to $size_universals)
  let $universal := $universals($i)
  return
    <dublin_core schema="dc">
    {
    for $key in map:keys($universal)
        let $val := if ($universal($key) instance of xs:string) then normalize-space($universal($key)) else ()
        let $o := switch($key)
        case 'id'
            return (
                <dcvalue element="identifier">{$val}</dcvalue>,
                <dcvalue element="landingPage">{concat('https://uniq.flu.cas.cz/universals/', $val)}</dcvalue>,
                <dcvalue element="type">text</dcvalue>,
                <dcvalue element="subject">Prague struggle over universals ca. 1348–1500</dcvalue>,
                <dcvalue element="rights">unknown</dcvalue>
            )
        case 'origin'
            return <dcvalue element="date">{$val}</dcvalue>
        case 'authors_id'
            return
                    let $authors := $universal($key)
                    let $authors_count := array:size($authors)
                    for $j in (1 to $authors_count)
                        let $author := $authors($j)
                        return <dcvalue element="creator">{$author?name}</dcvalue>
        case 'title'
            return <dcvalue element="title">{$val}</dcvalue>
        case 'manuscripts'
            (:concat manuscripts and others into description:)
            return
                let $description := 'The text is contained in the following manuscripts:&#xA;'
                let $linked_manuscripts := $universal($key)
                let $edition := normalize-space($universal?edition)
                let $literature := normalize-space($universal?literature)
                let $s_m := array:size($linked_manuscripts)
                return 
                    <dcvalue element="description">
                    {
                        concat($description, string-join(
                                for $j in (1 to $s_m)
                                    let $m := $linked_manuscripts($j)
                                    return $m?shelfmark
                      , '&#xA;'),
                      if ($edition) then concat('&#xA;&#xA;Edition:&#xA;', $edition) else '',
                      if ($literature) then concat('&#xA;&#xA;Literature:&#xA;', $literature) else ''
                      )
                    }
                    </dcvalue>
        case 'edition_link'
            return <dcvalue element="metadataOnly">{if ($val) then 'false' else 'true'}</dcvalue>
        default return ()
        return $o
(:
title
metadataOnly
all_as_cdata
identifier
landingPage
rights
:)
    }
        <dcvalue element="original_metadata">{concat('&lt;root&gt;', serialize($universal, map{"method": "json"}),'&lt;/root&gt;')}</dcvalue>
    </dublin_core>
}
</universals>
</uniq>

return $uniq
(:
return transform(
  map{
    "stylesheet-location": 'split.xslt',
    "source-node": $uniq 
    }
  )?output
:)
