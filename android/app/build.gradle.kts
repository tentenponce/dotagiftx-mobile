import java.util.Base64
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") version "2.2.0"
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("com.google.firebase.firebase-perf")
}

val keystoreProperties = Properties()
val keyStorePropertiesFileName = "dotagiftx.keystore.properties"
val keystorePropertiesFile = file(keyStorePropertiesFileName)
var keystoreFileExists = false

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    val keystoreFile = file(keystoreProperties.getProperty("storeFile") ?: "")
    keystoreFileExists = keystoreFile.exists()
    if (keystoreFileExists) {
        println("Signing with provided keystore")
     } else {
        println("Could not find signing keystore")
     }
} else {
    println("Could not find signing keystore properties")
}

val dartDefines = getDartDefines()

android {
    namespace = "com.dotagiftx"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.dotagiftx"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["appName"] = dartDefines["appName"] ?: error("Missing appName in env")
    }
    
    signingConfigs {
        create("release").apply {
            if (keystoreFileExists) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile")!!)
                storePassword = keystoreProperties.getProperty("storePassword")
                enableV1Signing = true
                enableV2Signing = true
            }
        }
    }

    buildTypes {
        release {
            multiDexEnabled = true
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = if (keystoreFileExists) signingConfigs.getByName("release") else signingConfigs.getByName("debug")
        }

        debug {
            signingConfig = if (keystoreFileExists) signingConfigs.getByName("release") else signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.10.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics")
    implementation("com.google.firebase:firebase-perf")
}

fun Project.getDartDefines(): Map<String, String> {
    val encoded = findProperty("dart-defines") as? String ?: return emptyMap()

    return encoded
        .split(",")
        .mapNotNull {
            val decoded = String(Base64.getDecoder().decode(it))
            val parts = decoded.split("=", limit = 2)
            if (parts.size == 2) parts[0] to parts[1] else null
        }
        .toMap()
}
