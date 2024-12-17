package com.medlyves.simple_kiosk_software;
import android.content.Intent;
import java.util.Map;
import java.util.HashMap;

import android.content.ComponentName;
import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String ECG_CHANNEL = "ECG";
    private static final int ECG_ACTIVITY_REQUEST_CODE = 1; // Request code
    private MethodChannel ecgChannel;
    private String Shutdown_ChannelName = "Shutdown";
    private MethodChannel shutdownChannel;

    Intent intent;
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        ecgChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), ECG_CHANNEL);
        ecgChannel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("openECGApp")) {
                        String name = call.argument("name");
                        String gender = call.argument("gender");
                        int age = call.argument("age");
                        boolean opened = openECGApp(name, gender, age);
                        if (opened) {
                            result.success(true);
                        } else {
                            result.error("UNAVAILABLE", "Cannot open the ECG app.", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                }
        );

        shutdownChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), Shutdown_ChannelName);
        shutdownChannel.setMethodCallHandler((call, result) -> {
            // 判断方法名是否支持
            if(call.method.equals("openShutdownApp")){
                boolean opened = openShutdownApp();
                if (opened) {
                    result.success(true);
                } else {
                    result.error("UNAVAILABLE", "Cannot open the shutdown app.", null);
                }
            }else{
                // 方法暂时不支持
                result.notImplemented();
            }
        });
    }

    private boolean openShutdownApp() {
        try {
            ComponentName componentName = new ComponentName("com.samiadom.Shutdown", "com.samiadom.Shutdown.MainActivity");
            Intent intent = new Intent();
            intent.setComponent(componentName);
            this.startActivity(intent);
            //finish();
            return true;
        } catch (Exception e) {
            return false;
        }
    }


    private boolean openECGApp(String name, String gender, int age) {
        try {
            ComponentName componentName = new ComponentName("com.ecgmac.ecgtab", "com.ecgmac.ecgtab.ECG_Main_Activity");
            Bundle bundle = new Bundle();
            bundle.putString("Patient_Name", name); // 患者姓名
            bundle.putString("Patient_ID", "MedLyvesUser"); // 患 者 ID
            bundle.putString("Patient_Gender", gender); // 患者性别：男或女
            bundle.putInt("Patient_Age", age); // 患者年龄
            // bundle.putInt("Birtss_Year", 1990); // 患者出生年份
            // bundle.putInt("Birth_Month", 1); // 患者出生月份
            // bundle.putInt("Birth_Day", 1); // 患者出生日期
            bundle.putString("Check_Doctor", ""); // 检查医生
            bundle.putString("Audit_Doctor", ""); // 诊断医生
            bundle.putString("Hospital_Info", ""); // 医院信息，可以设置菜单中设置，不传时默认为上次保存值
            bundle.putBoolean("StartAD", true); // 在启动TabletECG后是否自动采集
            bundle.putBoolean("Export_LowResolutionImage", false); // 启用低分辨率图片报告
            bundle.putBoolean("Export_OnlyWaveImage", false); // 图片报告仅显示波形
            bundle.putString("DataFormat", "EM-XML"); // 数据文件格式： OFF、EM-XML、SCP、DICOM、FDA-XML 或 BKG
            bundle.putString("ImageFormat", "JPEG"); // 图 片 文 件 格 式 ： OFF 、 PDF 或 JPEG
            bundle.putBoolean("Database_Enable", true); // 是否使用数据库
            bundle.putBoolean("ReAnalysis_Enable", true); // 是否使用重分析
            bundle.putBoolean("AutoAnalysis_Enable", true); // 是否使用自动分析
            bundle.putBoolean("DiagnoseClassify_Enable", true); // 是否使用诊断分类
            bundle.putBoolean("Exit_Confirmation", false); // 退出时是否弹出确认对话框
            bundle.putInt("ECG_MODE", 1); // 十二导/六导模式：0为十二导模式，1为六导模式。
            bundle.putString("BTAddress", ""); // 蓝牙采集盒的MAC地址，可不传，App会自己查找蓝牙采集盒
            bundle.putInt("Pacemaker_Sensitivity", 0); // 起搏检测灵敏度：0关闭，1起搏灵敏“低”，2起搏灵敏度“中”，3起搏灵敏度“高”
            intent = new Intent();
            intent.putExtras(bundle);
            intent.setComponent(componentName);
            this.startActivityForResult(intent, ECG_ACTIVITY_REQUEST_CODE);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == ECG_ACTIVITY_REQUEST_CODE) {
            if (resultCode == -1) {
                Map<String, String> resultMap = new HashMap<String, String>();
                int hr = data.getExtras().getInt("HeartRate");
                int p_width = data.getExtras().getInt("PWidth");
                int pr = data.getExtras().getInt("PR_Interval");
                int qrs_dur = data.getExtras().getInt("QRS_Duration");
                int qtc = data.getExtras().getInt("QTc_Interval");
                int qt = data.getExtras().getInt("QT_Interval");
                int p_axis = data.getExtras().getInt("P_Axis");
                int qrs_axis = data.getExtras().getInt("QRS_Axis");
                int t_axis = data.getExtras().getInt("T_Axis");
                float rv5 = data.getExtras().getFloat("RV5");
                float sv1 = data.getExtras().getFloat("SV1");
                float rv5sv1 = data.getExtras().getFloat("RV5SV1");
                String imageName = data.getExtras().getString("ImageName");
                String result = data.getExtras().getString("DiagnoseResult");
                int rr = 0;
                if (hr != 0) {
                    rr = 60000 / hr;
                }
                resultMap.put("hr", String.valueOf(hr));
                resultMap.put("p_width", String.valueOf(p_width));
                resultMap.put("pr", String.valueOf(pr));
                resultMap.put("qrs_dur", String.valueOf(qrs_dur));
                resultMap.put("qtc", String.valueOf(qtc));
                resultMap.put("qt", String.valueOf(qt));
                resultMap.put("p_axis", String.valueOf(p_axis));
                resultMap.put("qrs_axis", String.valueOf(qrs_axis));
                resultMap.put("t_axis", String.valueOf(t_axis));
                resultMap.put("rv5", String.valueOf(rv5));
                resultMap.put("sv1", String.valueOf(sv1));
                resultMap.put("rv5sv1", String.valueOf(rv5sv1));
                resultMap.put("imageName", String.valueOf(imageName));
                resultMap.put("result", String.valueOf(result));
                resultMap.put("rr", String.valueOf(rr));

                ecgChannel.invokeMethod("receiveData", resultMap);
            }
        }
    }
}
