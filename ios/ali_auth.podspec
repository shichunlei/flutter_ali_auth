#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'ali_auth'
  s.version          = '1.4.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
  是一个集成阿里云号码认证服务SDK的flutter插件
                       DESC
  s.homepage         = 'http://ki5k.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'raohong07@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'ali_auth/Sources/ali_auth/**/*.swift'

  s.dependency 'Flutter'
  s.dependency 'SDWebImage'
  # s.dependency 'MBProgressHUD'

  s.frameworks = 'AuthenticationServices', 'AVFoundation', 'Network', 'WebKit'

  s.vendored_frameworks = 'ali_auth/Frameworks/ATAuthSDK.xcframework', 'ali_auth/Frameworks/YTXMonitor.xcframework', 'ali_auth/Frameworks/YTXOperators.xcframework'
  s.static_framework = false

  # 解决移动crash
  s.xcconfig = {
    'OTHER_LDFLAGS' => '-ObjC',
    'ENABLE_BITCODE' => 'NO'
  }
  
  # 加载静态资源
  s.resources = ['ali_auth/Sources/ali_auth/Resources/*']

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.9'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
