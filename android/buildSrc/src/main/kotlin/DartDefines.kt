import org.gradle.api.Project
import java.util.Base64

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