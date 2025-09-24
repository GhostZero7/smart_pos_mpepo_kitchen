// 1. ADD THIS MISSING BUILDSCRIPT SECTION
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // THIS IS THE CRITICAL LINE YOU NEED TO ADD
        classpath("com.android.tools.build:gradle:8.7.2")
    }
}

// 2. YOUR EXISTING CONTENT STARTS HERE
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// COMMENT OUT OR REMOVE THE CUSTOM BUILD DIRECTORY CONFIGURATION
/*
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
*/

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}