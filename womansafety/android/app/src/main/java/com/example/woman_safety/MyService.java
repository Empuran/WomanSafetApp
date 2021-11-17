package com.example.woman_safety;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.SystemClock;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;
import android.util.FloatMath;
import android.util.Log;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import java.util.Arrays;
import java.util.List;

@SuppressLint("HandlerLeak")
public class MyService extends Service implements AccelerometerListener{

    String str_address;
    static int count=1;
    String name;
    List<String> data;
    String extradata;
    LocationManager  locationManager;


    private Looper mServiceLooper;
    private ServiceHandler mServiceHandler;

    private final class ServiceHandler extends Handler {

        public ServiceHandler(Looper looper) {
            super(looper);
        }
        @Override
        public void handleMessage(Message msg) {}
    }

    @Override
    public IBinder onBind(Intent arg0) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();

        if (AccelerometerManager.isSupported(this)) {
            AccelerometerManager.startListening(this);
        }

        HandlerThread thread = new HandlerThread("ServiceStartArguments",android.os.Process.THREAD_PRIORITY_BACKGROUND);
        thread.start();

        mServiceLooper = thread.getLooper();

        mServiceHandler = new ServiceHandler(mServiceLooper);
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Context context = getApplicationContext();
        CharSequence text = "Women Safety App Service Started";
        int duration = Toast.LENGTH_SHORT;
        Toast toast = Toast.makeText(context, text, duration);
        toast.show();

        name=intent.getStringExtra("name");
        extradata=intent.getStringExtra("data");
        data= Arrays.asList(extradata.split(","));

        Message msg = mServiceHandler.obtainMessage();

        msg.arg1 = startId;

        mServiceHandler.sendMessage(msg);
        return START_STICKY;
    }



    public class GeocoderHandler extends Handler {
        @Override
        public void handleMessage(Message message) {

            switch (message.what) {
                case 1:
                    Bundle bundle = message.getData();
                    String[] details = name.split("/");
                    str_address = bundle.getString("address");
                    String[] number=data.get(0).split(":");
                    
                    TelephonyManager tmgr=(TelephonyManager)MyService.this.getSystemService(Context.TELEPHONY_SERVICE);
                     for(int i=0;i<data.size()-1;i++){
                      String[] ph_number=data.get(i).split(":");

                           // Toast.makeText(getApplicationContext(), ph_number[1], Toast.LENGTH_SHORT).show();

                            SmsManager smsManager=SmsManager.getDefault();
                            smsManager.sendTextMessage("+91"+ph_number[1], "","Emergency message from "+details[0]+". I need help immediately. This is where i am now:"+str_address, null, null);
                            smsManager.sendTextMessage("+91"+ph_number[1],"",details[2]+","+details[1]+"\n"+extradata,null,null);
                     }
                        Intent intent=new Intent(Intent.ACTION_CALL);
                        intent.setData(Uri.parse("tel:+91" +  number[1]));
                        getApplicationContext().startActivity(intent);
                    break;
                default:
                    str_address = null;
            }
        }
    }


    @Override
    public void onAccelerationChanged(float x, float y, float z) {}
    @Override
    public void onShake(float force) {


        if(count==12){
          
        GPSTracker gps;
        gps = new GPSTracker(MyService.this);
        if(gps.canGetLocation()){

            double latitude = gps.getLatitude();
            double longitude = gps.getLongitude();

            RGeocoder RGeocoder = new RGeocoder();
            RGeocoder.getAddressFromLocation(latitude, longitude,getApplicationContext(), new GeocoderHandler());
           Toast.makeText(getApplicationContext(), "onShake detected", Toast.LENGTH_SHORT).show();

        }
        else{
            gps.showSettingsAlert();
        }
          count=1;
        }else {count++;}

    }




    @Override
    public void onDestroy() {
        super.onDestroy();

        // Toast Service Stopped.
        Context context = getApplicationContext();

        Log.i("Sensor", "Service  distroy");

        if (AccelerometerManager.isListening()) {

            AccelerometerManager.stopListening();

        }

        CharSequence text = "Women Safety App Service Stopped";
        int duration = Toast.LENGTH_SHORT;
        Toast toast = Toast.makeText(context, text, duration);
        toast.show();


    }



}