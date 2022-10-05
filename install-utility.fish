#!/bin/fish

# A simple script to download and install some utility programs.

function assert_command_exists
    if not command -q $argv[1]
        echo "command `$argv[1]` not found"
        
        if test -n $argv[2]
            echo $argv[2]
        end
        
        exit 1
    end
end

function cargo_target_dir
    cargo metadata --format-version=1 | grep -o '"target_directory":"[^"]*"' | grep -o '"[^"]*"$' | grep -o '[^"]*'
end

function read_confirm
    set -l REPLY (read -P $argv[1] -n 1)
    test -z $REPLY -o $REPLY = y -o $REPLY = Y
end

# Query the commands required to use this script.

assert_command_exists git "How do you not have git???"
assert_command_exists gunzip
assert_command_exists curl
assert_command_exists cargo "You must have Rust installed on your maching to use this utility."

# Determine in which directory the binaries should be outputed.
set -l BIN_DIR (read -P "bin directory (~/bin): ")
if test -z "$BIN_DIR"
    set BIN_DIR ~/bin
else
    # Parse an eventual initial starting ~
    if test $BIN_DIR = '~'
        set BIN_DIR ~
    else
        set BIN_DIR (string replace -r '^~/' ~/ $BIN_DIR)
    end
end

mkdir -p $BIN_DIR

set -l INSTALL_DIR /tmp/installing-nils-mathieu

mkdir $INSTALL_DIR
cd $INSTALL_DIR

# Installing EXA

if not command -q exa && read_confirm "install the `exa` utility (Y/n): "
    git clone https://github.com/ogham/exa.git
    or exit
    
    cd exa
    
    cargo build --release
    cp (cargo_target_dir)/release/exa $BIN_DIR/exa
    
    echo "`exa` installed at `$BIN_DIR/exa`"
    cd -
end

# Installing HELIX

if not command -q hx && read_confirm "install the Helix editor (Y/n): "
    git clone git@github.com:helix-editor/helix.git
    or exit    

    cd helix
    
    cargo build --release
    cp (cargo_target_dir)/release/hx $BIN_DIR/hx
    
    if set -q HELIX_RUNTIME
        set -l HELIX_RUNTIME ~/.config/helix/runtime
    end
    
    mkdir -p $HELIX_RUNTIME
    cp runtime $HELIX_RUNTIME

    hx --grammar fetch
    hx --grammar build
    
    echo "Helix installed at `$BIN_DIR/hx`"
    cd -
    
    if not command -q rust-analyzer && read_confirm "add support for Rust in Helix (Y/n): "
        curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > $BIN_DIR/rust-analyzer
        or exit

        echo "`rust-analyzer` installed at `$BIN_DIR/rust-analyzer`"
    end
    
    if not command -q taplo && read_confirm "add support for TOML in Helix (Y/n): "
        git clone git@github.com:tamasfe/taplo.git
        or exit
        
        cd taplo
        
        cargo build --release
        cp (cargo_target_dir)/release/taplo $BIN_DIR/taplo
        
        cd -
        echo "`taplo` installed at `$BIN_DIR/taplo`"
    end
end

rm -rf $INSTALL_DIR