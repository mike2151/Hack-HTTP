# Hack-HTTP 

This project is a HTTP server implemented in Hack. 

## Install Dependencies

Run `composer install` to install the dependencies

Run Autoload: `vendor/bin/hh-autoload`

## How To Run

Run `hhvm src/Server.hack [PORT] [DIR]`

Where `PORT` is the port number to listen to and `DIR` is the directory of static content relative to the src/Server folder.

As an example, the `www` folder in root has static content to server as a demo

An example of accesing this folder is:

`hhvm src/Server/Server.hack 9000 ../../www/`
