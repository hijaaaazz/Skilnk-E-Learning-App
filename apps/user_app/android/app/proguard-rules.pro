# Retain Razorpay classes
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Retain Google Pay classes used by Razorpay
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.**

# Retain ProGuard annotation classes
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers

# Retain members annotated with the above annotations
-keepclassmembers class * {
    @proguard.annotation.Keep *;
    @proguard.annotation.KeepClassMembers *;
}

# Retain all annotations
-keepattributes *Annotation*

# Prevent method inlining optimizations
-optimizations !method/inlining/

# Retain methods related to payment callbacks
-keepclasseswithmembers class * {
    public void onPayment*(...);
}
