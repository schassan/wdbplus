(: kontrolliert die Verarbeitung von projektspezifischen XQuery;
 : Bearbeiter:DK Dario Kampkaspar kampkaspar@hab.de
 : erstellt 2016-11-03 DK :)
xquery version "3.0";

module namespace wdbpq = "https://github.com/dariok/wdbplus/pquery";

import module namespace templates	= "http://exist-db.org/xquery/templates" ;
import module namespace wdb			= "https://github.com/dariok/wdbplus/wdb" at "app.xql";
import module namespace console 	= "http://exist-db.org/xquery/console";

declare %templates:default("q", "") %templates:default("q2", "")
	function wdbpq:start($node as node(), $model as map(*), $edition as xs:string, $query as xs:string, $q as xs:string, $q2 as xs:string) as map(*) {
	
	map{ "query" := $query, "q" := $q, "q2" := $q2, "ed" := $edition, "edPath" := wdb:getEdPath($edition, true()) }
};

declare function wdbpq:pageTitle ($node as node(), $model as map(*)) {
	<title>{$wdb:configFile//*:short}</title>
};

(: die angegebene Datei laden. Die Eingangsfunktion muß gegeben sein; 2016-11-03 DK :)
(: TODO geht das auch anders? :)
(: Wir nehmen grundsätzlich an, daß die Skripte im Unterverzeichnis scripts innerhalb des Projektordners liegen
		(vgl. Mail Thomas 2017-01-04T12:05) :)
declare function wdbpq:body($node as node(), $model as map(*)) {
	let $path := wdb:getEdPath($model("ed"), true())  || '/' || $model("query")
	let $module := util:import-module(xs:anyURI("https://github.com/dariok/wdbplus/wdbq"), 'wdbq', xs:anyURI($path))
	
	return util:eval("wdbq:query($map)", xs:boolean('false'), (xs:QName('map'), $model))
};

(: gibt das h2 für die navbar aus; neu 2017-03-27 DK :)
declare function wdbpq:getTask($node as node(), $model as map(*)) {
	let $path := wdb:getEdPath($model("ed"), true())  || '/' || $model("query")
	let $module := util:import-module(xs:anyURI("https://github.com/dariok/wdbplus/wdbq"), 'wdbq', xs:anyURI($path))
	
	return util:eval("wdbq:getTask()", xs:boolean('false'), (xs:QName('map'), $model))
};