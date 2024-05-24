package com.celuweb.pidekyapp

import io.flutter.embedding.android.FlutterFragmentActivity
import android.content.Intent
import android.content.pm.PackageManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "com.celuweb.pidekyapp/openThirdPartyApp"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openThirdPartyApp") {
                val arguments: Map<String, Object> = call.arguments()!!
                val packagename = arguments["packagename"] as String
                if ( packagename != null ) {
                    openThirdPartyApp(packagename, result)
                } else {
                    result.error("INVALID", "Invalid package name", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openThirdPartyApp(packagename: String?, result: MethodChannel.Result) {
        var aplicacion: Intent? = null
        val manager: PackageManager = getPackageManager()
        try {
            aplicacion = packagename?.let { manager.getLaunchIntentForPackage(it) }
            if (aplicacion == null) throw PackageManager.NameNotFoundException()
            intent.addCategory(Intent.CATEGORY_LAUNCHER)
            aplicacion.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            aplicacion.setAction(Intent.ACTION_SEND)
            startActivity(aplicacion)
            result.success(true) // Devuelve 'true' si la aplicación se abre correctamente
        } catch (e: PackageManager.NameNotFoundException) {
            result.error("ERROR", "No se pudo abrir la aplicación: ${e.message}", packagename) // Devuelve un mensaje de error
        }
    }
}
