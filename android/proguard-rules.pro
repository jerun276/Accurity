# Flutter frameworks
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.embedding.**  { *; }
-keep class io.flutter.plugin.common.**  { *; }
-keep class androidx.lifecycle.** { *; }

# Keep Supabase model classes from being obfuscated, as they rely on reflection.
-keep class com.supabase.** { *; }

# Keep SharedPreferences classes
-keep class androidx.datastore.preferences.core.** { *; }