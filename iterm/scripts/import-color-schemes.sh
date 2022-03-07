#!/usr/bin/env bash

git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git
iTerm2-Color-Schemes/tools/import-scheme.sh -v schemes/*
rm -rf iTerm2-Color-Schemes 