<?php
/**
 * Plugin Name: MailHog Support
 * Description: Forces MailHog to work with the Docker WordPress Image
 */

defined( 'ABSPATH' ) || die();

add_action( 'phpmailer_init', function( $phpmailer ) { 
	
	$phpmailer->Host = 'mailhog'; 
	$phpmailer->Port = 1025; 
	$phpmailer->IsSMTP(); 
	
} );