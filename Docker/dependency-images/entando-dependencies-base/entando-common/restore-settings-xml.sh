#!/usr/bin/env bash
if [ -f $HOME/.m2/settings.xml.bup ]; then
  rm $HOME/.m2/settings.xml
  mv $HOME/.m2/settings.xml.bup $HOME/.m2/settings.xml
fi