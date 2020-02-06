<?php


// Strip document extension
$file_name = basename("Commercial Invoice.pdf", '.pdf');

// Convert this document
// Each page to single image
$img = new imagick();

// Set image resolution
$img->setBackgroundColor('white');
$img->setResolution(300,300);
// must be done after setting resolution
$img->readImage($file_name.'.pdf');

// Determine num of pages
$num_pages = $img->getNumberImages();

// Compress Image Quality
$img->setImageCompressionQuality(100);
$img->setCompression(imagick::COMPRESSION_JPEG);
$img->posterizeImage(2, false);
$height = $img->getImageHeight();
$weight = $img->getImageWidth();


// Convert PDF pages to images
for($i = 0;$i < $num_pages; $i++) {         

    // Set iterator postion
    $img->setIteratorIndex($i);

    // Set image format
    $img->setImageFormat('tiff');

    // Write Images to temp 'upload' folder  
    $img1 = new imagick();
    $img1->setBackgroundColor('white');
    $img1->readImageBlob($img->getImageBlob());
    $img1 = $img1->flattenImages();
    $img1->setImageCompressionQuality(100);
    $img1->setCompression(imagick::COMPRESSION_JPEG);
    $img1->posterizeImage(2, false);
    $img1->writeImage($file_name.'-'.$i.'.tif');
    $img1->destroy();
}

$img->destroy();
