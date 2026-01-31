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
                compileSdkVersion(36)
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
