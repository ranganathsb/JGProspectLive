/**
 * @license Copyright (c) 2003-2016, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
    config.skin = 'office2013';
    config.extraPlugins = 'uploadimage';
    config.imageUploadUrl = '../ckeditor/plugins/imageuploader/imgupload.php';
    
    // Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
};