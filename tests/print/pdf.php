<?php

// Include the main TCPDF library (search for installation path).
require_once('../../vendor/autoload.php');

// create new PDF document
$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);

// set document information
$pdf->SetCreator(PDF_CREATOR);
$pdf->SetAuthor('eBIS Converter');
$pdf->SetTitle('eBIS Converter to PDF');

// set header and footer fonts
$pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
$pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));
$pdf->SetFont(PDF_FONT_NAME_DATA);

$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
$pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);
$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
$pdf->AddPage('L');
$pdf->SetFillColor(255,255,255);
$html = $pdf->fixHTMLCode(
        file_get_contents('S561-001802419641.html'), 
        '* { font-size: 10px; } table { margin-bottom: 10px; padding: 0; margin: 0; width: 100%; } table tr { margin-bottom: 10px; padding: 0; margin: 0; } table tr td,th { margin-bottom: 10px; } table tr td:nth-child(4) { width: 30%; }', 
        array(
            'p' => array( array('h' => 0, 'n' => 0), array('h' => 0, 'n' => 0) ), 
            'div' => array( array('h' => 0, 'n' => 0), array('h' => 0, 'n' => 0) ), 
            'span' => array( array('h' => 0, 'n' => 0), array('h' => 0, 'n' => 0) ),
            'table' => array( array('h' => 0, 'n' => 0), array('h' => 0, 'n' => 0) ),
        ),
        array (
            'clean' => 1,
//            'drop-empty-paras' => 0,
//            'drop-proprietary-attributes' => 1,
//            'fix-backslash' => 1,
//            'hide-comments' => 1,
//            'join-styles' => 1,
//            'lower-literals' => 1,
//            'merge-divs' => 1,
//            'merge-spans' => 1,
//            'output-xhtml' => 1,
//            'word-2000' => 1,
//            'wrap' => 0,
//            'output-bom' => 0,
//            'char-encoding' => 'utf8',
//            'input-encoding' => 'utf8',
//            'output-encoding' => 'utf8'
    )
        );

$pdf->writeHTML($html, false, true, false, '');
$pdf->lastPage();
file_put_contents('Commercial Invoice.pdf', $pdf->Output('Commercial Invoice.pdf', 'S'));