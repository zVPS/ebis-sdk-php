<?php

$xml = new DOMDocument(); 
$xml->load('S561-001802419641.XML'); 

$xsl = new DOMDocument; 
$xsl->load('eBis.XSL'); 

$proc = new XSLTProcessor(); 
$proc->importStyleSheet($xsl); 
$html = $proc->transformToXML($xml);

file_put_contents('S561-001802419641.html', $html);