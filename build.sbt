lazy val root = project
  .in(file("."))
  .settings(
    name := "assembly-test",
    description := "",
    version := "0.1",
    scalaVersion := "2.12.4",
    libraryDependencies ++= Seq(
      "com.netflix.astyanax" % "astyanax-cassandra" % "3.9.0",
      "org.apache.cassandra" % "cassandra-all" % "3.4",
    ))