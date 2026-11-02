# 注意事项
1、如果使用自定义协议页面 (对小白不够友好，需要会Android布局) 
    1.1 添加清单
    ```<!--   自定义协议页面    -->
    <activity
        android:configChanges="orientation|keyboardHidden|screenSize|uiMode|fontScale"
        android:name="com.sean.rao.aliAuth.CustomWebViewActivity"
        android:theme="@style/AppTheme"
        android:exported="true"
        android:screenOrientation="sensorPortrait">
       <intent-filter>
           <action android:name="com.sean.rao.ali_auth_example.protocolWeb"/>
           <category android:name="android.intent.category.DEFAULT"/>
       </intent-filter>
    </activity>```   
    1.2 拷贝Activity文件    
    ```ali_auth/example/android/app/src/main/java/com/sean/rao/aliAuth/CustomWebViewActivity.java```   
    1.3 拷贝布局文件  
    ```ali_auth/example/android/app/src/main/res/layout/activity_custom_web.xml```    
    1.4 拷贝资源文件    
    ```ali_auth/example/android/app/src/main/res/drawable/icon_close.png```   
    1.5 修改CustomWebViewActivity.java 将R 资源引入

## Fork 边界与上游基准

业务源码、参数声明、默认值、序列化、Web 回调及原生处理以上游
[CodeGather/flutter_ali_auth](https://github.com/CodeGather/flutter_ali_auth) 的提交
`712747d5028a73227be0110333674bd216c51735` 为基准。宿主配置不能反向定义插件能力。

允许的适配及例外：

- iOS 使用 Swift 实现 OC 的同等行为，支持 SPM 并保留 CocoaPods；SDK 二进制仅移动目录。
- `ali_auth_spm` 包名、版本、注册及模块路径保持 fork 标识。
- Android 保留经确认的当前宿主构建兼容设置：AGP 8.13.2、Java 17、compileSdk 36、
  本地 AAR 模块路径和 Manifest 合并兼容；Android Java、AAR 及鸿蒙业务实现遵循上游。
- `isDebug` 布局日志只观察参数及几何值，不修改 SDK 配置或排版，不记录凭据和手机号。

Dart 与 Web 不增加上游没有的公开便捷 API、构造器注入或回调数据转换。Web 鉴权与
取号回调保留 JS 原始对象，调用者需要时自行转换为 Dart 数据。平台版本查询也保持
上游 BrowserDetection.debugUserAgentOverride 的可空结果，不替换为实际 UA。
