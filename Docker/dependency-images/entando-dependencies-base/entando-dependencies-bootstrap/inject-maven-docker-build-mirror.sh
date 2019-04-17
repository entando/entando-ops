#!/usr/bin/env bash
if [ -n "$MAVEN_MIRROR_URL" ]; then
cp $HOME/.m2/settings.xml $HOME/.m2/settings.xml.bup
xml="\
    <mirror>\
      <id>mirror.default</id>\
      <url>$MAVEN_MIRROR_URL</url>\
      <mirrorOf>external:*</mirrorOf>\
    </mirror>"
sed -i "s|<!-- ### configured mirrors ### -->|$xml|" $HOME/.m2/settings.xml
fi