#!/bin/bash
set -ex

source ~/.profile

function delete_file() {
  dir=$(pwd)/src
  for i in `find $dir -name '*.pyc' -type f`;do
    rm -rf $i
  done

  for i in `find $dir -name '*.pyo' -type f`
  do
    rm -rf $i
  done
}

function compilePy(){
  python.exe -m compileall src
  python.exe -O -m compileall src
}

delete_file