#!/bin/bash

# If no author is specified, use this default.
local author=${CARGO_TOML_AUTHOR:-"Nils Mathieu <nils.mathieu.contact@gmail.com>"}

echo -n "\
[package]
name = "$1"
version = "0.0.1"
edition = "2021"
authors = [ "$author" ]
"
