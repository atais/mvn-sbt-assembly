#!/usr/bin/env bash

rm -rf ./target/maven-assembly
rm -rf ./target/sbt-assembly

sbt assembly
mvn package

unzip -q target/assembly-test-0.1-jar-with-dependencies.jar -d ./target/maven-assembly
unzip -q target/scala-2.12/assembly-test-assembly-0.1.jar -d ./target/sbt-assembly

diff -r "./target/maven-assembly/org/cliffc/high_scale_lib/" "./target/sbt-assembly/org/cliffc/high_scale_lib/"
diff -r "./target/maven-assembly/org/apache/commons" "./target/sbt-assembly/org/apache/commons"


