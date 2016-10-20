#!/bin/bash

sudo apt-get install byacc flex
sudo apt-get install gcc
lex source.l
gcc lex.yy.c -lfl -o lexr
