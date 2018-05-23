lazy val root = project
  .in(file("."))
  .settings(
    name := "assembly-test",
    description := "",
    version := "0.1",
    scalaVersion := "2.12.4",
    assemblyMergeStrategy in assembly := {
      case PathList("org", "apache", "commons", "logging", xs@_*) => MergeStrategy.first
      case PathList("org", "cliffc", "high_scale_lib", xs@_*) => MergeStrategy.first
      case x => (assemblyMergeStrategy in assembly).value.apply(x)
    },
    libraryDependencies ++= Seq(
      "com.netflix.astyanax" % "astyanax-cassandra" % "3.9.0",
      "org.apache.cassandra" % "cassandra-all" % "3.4",
    ))