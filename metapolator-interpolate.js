#!/usr/bin/env node
//
// This command is useful if you want to create an instance UFO at
//  a distance between two masters.
//
// The command will 
//    create a scratch Metapolator workspace
//    import two masters
//    create an instance at your location between them
//    export that instance to a UFO file at the path of your choosing.
//
//
//
"use strict";

var program  = require('commander');
var rimraf   = require('rimraf');
var sh       = require('execSync');   
var fs       = require('fs');
var path     = require('path');

var TMPWSDIR = "/tmp/mutatormathtools-metapolator-interpolate-workspace";
var MMTDIR   = __dirname;

program
  .version('0.0.1')
  .option('-a, --mastera <ufopath>',         'First master')
  .option('-b, --masterb <ufopath>',         'Second master')
  .option('-p, --percentage <n>',            'Percentage from mastera to metapolate (0.01 to 0.99)', 
	  parseFloat)
  .option('-o, --out <ufopath>',             'Write resulting UFO to a directory at this path')
  .option('-m, --metapolator <commandpath>', 'Path to your metapolator command')
  .parse(process.argv);

if( program.mastera === undefined 
    || program.masterb === undefined 
    || program.out === undefined 
    || (program.percentage !== undefined && (program.percentage > 1 || program.percentage < 0 ))
  ) {
    program.help();
}
    
var runMetapolator = function( cmdline ) {
    var fullCommand = program.metapolator + " " + cmdline;
    console.log("CMD: " + fullCommand );
    var output = sh.exec( program.metapolator + " " + cmdline );
//    console.log(output);
    if( output.code != 0 ) {
	console.error("A problem running metapolator. CMD: " + fullCommand );
	console.log(output.stdout);
    }
}

var importUFO = function( ufopath, masterName ) {
    console.log("importing " + ufopath + " to " + masterName + "...");
    if( !fs.existsSync(ufopath)) {
	console.log("UFO file does not exist,");
	console.log("  trying relative to the fonts directory in the mutatormathtools project");
	ufopath = MMTDIR + "/fonts/" + ufopath;
	if( !fs.existsSync(ufopath)) {
	    console.error("Can not find UFO font for import! ufopath" + ufopath );
	}
    }
    runMetapolator("import " + ufopath + " " + masterName);
}


if( program.metapolator === undefined ) {
    program.metapolator = "metapolator";
}
if( program.percentage === undefined ) {
    program.percentage = 0.5;
}

console.log("creating a temporary workspace in " + TMPWSDIR);
rimraf.sync( TMPWSDIR );


console.log("create a new metapolator project for this run");
process.chdir(path.dirname(TMPWSDIR));
console.log("program.metapolator:" + program.metapolator);
runMetapolator( " init " + path.basename(TMPWSDIR));
process.chdir(TMPWSDIR);

importUFO( program.mastera, "mastera" );
importUFO( program.masterb, "masterb" );

console.log("Going to generate instance...");
runMetapolator( "interpolate mastera,masterb " 
		+ program.percentage + "," + (1-program.percentage) 
		+ " interp" );

console.log("exporting the instance to: " + program.out );
rimraf.sync( program.out );
runMetapolator( "export interp " + program.out );
