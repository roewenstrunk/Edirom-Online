xquery version "3.1";
(:
 : For LICENSE-Details please refer to the LICENSE file in the root directory of this repository.
 :)

(:~
 : Returns preferences as JSON or XML.
 :
 : @author <a href="mailto:roewenstrunk@edirom.de">Daniel Röwenstrunk</a>
 :)

(: IMPORTS ================================================================= :)

import module namespace edition = "http://www.edirom.de/xquery/edition" at "../xqm/edition.xqm";

(: NAMESPACE DECLARATIONS ================================================== :)

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace request = "http://exist-db.org/xquery/request";

(: OPTION DECLARATIONS ===================================================== :)

declare option output:media-type "text/html";
declare option output:method "xhtml";
declare option output:indent "yes";
declare option output:omit-xml-declaration "yes";

(: QUERY BODY ============================================================== :)

let $mode := request:get-parameter('mode', '')
let $edition := request:get-parameter('edition', '')

let $file := doc($edition:default-prefs-location)

let $projectFile := doc(edition:getPreferencesURI($edition))

return
    if ($mode = 'json') then (
        concat(
            '{',
                string-join((
                    for $entry in $file//entry
                    return
                        concat('"', $entry/string(@key), '":"', $entry/string(@value), '"'),
                    for $entry in $projectFile//entry
                    return
                        concat('"', $entry/string(@key), '":"', $entry/string(@value), '"')
                ), ','),
            '}'
        )
    ) else
        ($file)
