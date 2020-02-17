package com.crab.counter.test

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.view.FlutterView


class TestActivity : FlutterActivity() {
    companion object {
        fun startActivity(context: Context) {
            val intent = Intent(context, TestActivity::class.java)
            context.startActivity(intent)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

//        val flutterView = Flutter
    }
}
