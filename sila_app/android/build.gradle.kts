allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    afterEvaluate {
        if (project.plugins.hasPlugin("com.android.application") ||
            project.plugins.hasPlugin("com.android.library")) {
            
            project.extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
                if (namespace == null || namespace!!.isEmpty()) {
                    namespace = project.group.toString()
                }
                compileSdkVersion(35)
            }
        }
    }
}

rootProject.layout.buildDirectory.set(file("../build"))
subprojects {
    layout.buildDirectory.set(rootProject.layout.buildDirectory.dir(project.name))
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
