allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// تغيير مسار مجلد build للمشروع الرئيسي
val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.set(newBuildDir)

// تغيير مسار مجلد build لكل مشروع فرعي
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

// التأكد من أن كل مشروع فرعي يقيم بعد :app
subprojects {
    project.evaluationDependsOn(":app")
}

// مهمة clean لحذف مجلد build
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
