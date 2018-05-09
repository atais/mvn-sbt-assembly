# Maven vs SBT Assembly plugin  

This project aims to find the differences between Maven's and SBT's Assembly plugin.

I have created a demo project, with the same dependencies for both build tools. 
For some reason, Maven successfully creates a fat jar, 
while SBT requires user to resolve conflicts in the classpath.

# How to test

## Maven
`mvn package`

## Sbt
`sbt assembly`

# StackOverflow question

https://stackoverflow.com/questions/50249818/why-maven-assembly-works-when-sbt-assembly-find-conflicts