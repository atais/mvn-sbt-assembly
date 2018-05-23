# Maven vs SBT Assembly plugin  

This project aims to find the differences between Maven's and SBT's Assembly plugin.

I have created a demo project, with the same dependencies for both build tools. 
For some reason, Maven successfully creates a fat jar, 
while SBT requires user to resolve conflicts in the classpath.

# StackOverflow question

https://stackoverflow.com/questions/50249818/why-maven-assembly-works-when-sbt-assembly-find-conflicts

As Alexey Romanov states in his <a href="https://stackoverflow.com/a/50464199/1549135" target="_blank">answer</a>
the 

> by just picking one of the files in an unspecified way when jar-with-dependencies is used (since it only has one phase)

The assumption is that it has to be somehow similar to either:

* MergeStrategy.first 
* MergeStrategy.last

since they are the only strategies that could make sense in term of java `class` files.

# Checking the answer

I have prepared a binary check of the output, since it is the easiest way to find out what is actually happening.

`build.sbt` was modified with `assemblyMergeStrategy`, for conflicting paths:

```scala
assemblyMergeStrategy in assembly := {
      case PathList("org", "apache", "commons", "logging", xs@_*) => MergeStrategy.first/last
      case PathList("org", "cliffc", "high_scale_lib", xs@_*) => MergeStrategy.first/last
      case x => (assemblyMergeStrategy in assembly).value.apply(x)
    },
```

The binary check is done with `diff` build-in tool. 

You can find the exact test in `test.sh`.

### MergeStrategy.first

The only differences found were, that `sbt` jar contained **more** files, for example:

```scala
Only in ./target/sbt-assembly/org/apache/commons/logging/impl: AvalonLogger.class
```

I will try to explain how it happens later.


### MergeStrategy.last

But for the differences present in the first case, you can find binary differences in conflicting files, for example:

```scala
Binary files ./target/maven-assembly/org/cliffc/high_scale_lib/NonBlockingHashMap$1.class and ./target/sbt-assembly/org/cliffc/high_scale_lib/NonBlockingHashMap$1.class differ
```

---

That shows, that the `MergeStrategy.first` gave the result that was closer to `maven-assembly-plugin`.
**But what about those extra files?**

## Extra files

To explain it, I had check the dependencies that gave the conflicts. 
There are 2 conflicts, between 4 dependencies, but as an example I have checked:

* [jcl-over-slf4j-1.7.7.jar](http://central.maven.org/maven2/org/slf4j/jcl-over-slf4j/1.7.7/jcl-over-slf4j-1.7.7.jar)
* [commons-logging-1.1.1.jar](http://central.maven.org/maven2/commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar)

Question is: <br>
**Which class files are present in `maven` and `sbt` builds?**

I am comparing the given `jars` with output of `maven package` and `sbt assembly` (with `MergeStrategy.first`).

The exact script and the output can be found in `files-check.sh`. It's summary can be present as a table:

|                | maven                                   | sbt                                     |        
| -------------- | --------------------------------------- | --------------------------------------- | 
| jcl-over-slf4j | no conflicts                            | contained extra files                   |      
| commons-logging| binary differences & missing files      | binary differences & extra files        |

Also `maven` build does not contain `commons-logging` folder in `/META-INF/maven`

# Conclusion

`maven-assembly-plugin` resolves conflicts on `jar` level. 
When it finds any conflict, it picks the first `jar` and simply ignores all the content from the other.

Whereas `sbt-assembly` mixes all the `class` files, resolving conflicts locally, file by file. 

**My theory** would be, that if your `fat-jar` made with `maven-assembly-plugin` works, you can 
specify `MergeStrategy.first` for all the conflicts in `sbt`. 
They only difference would be, that the `jar` produced with `sbt` will be even bigger, containing extra classes
that were ignored by `maven`.




 


