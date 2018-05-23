#!/usr/bin/env bash

cd ./target

wget http://central.maven.org/maven2/org/slf4j/jcl-over-slf4j/1.7.7/jcl-over-slf4j-1.7.7.jar
wget http://central.maven.org/maven2/commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar

unzip -q jcl-over-slf4j-1.7.7.jar -d ./jcl-over-slf4j
unzip -q commons-logging-1.1.1.jar -d ./commons-logging

echo "Maven check"
echo "jcl-over-slf4j"
diff -r "./maven-assembly/org/apache/commons/logging" "./jcl-over-slf4j/org/apache/commons/logging"
echo "commons-logging"
diff -r "./maven-assembly/org/apache/commons/logging" "./commons-logging/org/apache/commons/logging"

echo "SBT check"
echo "jcl-over-slf4j"
diff -r "./sbt-assembly/org/apache/commons/logging" "./jcl-over-slf4j/org/apache/commons/logging"
echo "commons-logging"
diff -r "./sbt-assembly/org/apache/commons/logging" "./commons-logging/org/apache/commons/logging"