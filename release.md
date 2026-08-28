
## 1.4.3
* 修复 Flutter 无法识别 Swift Package Manager 支持的问题，同步 SPM 目录、product 与 target 名称为 `ali_auth_spm`

## 1.4.2
* 修复包名改为 `ali_auth_spm` 后 Android 工程引用失败的问题
* 修复 CocoaPods 无法找到 `ali_auth_spm` podspec 的问题

## 1.4.1
* 新增 iOS Swift Package Manager 支持，并继续兼容 CocoaPods
* 将 iOS 插件源码从 Objective-C 全面迁移至 Swift，Flutter 通道接口保持不变

## 1.4.0
* 更新android sdk 为 2.14.23
* 更新ios sdk 为 2.14.18
* 将IOS的引入改为动态库，将framework修改xcframework 兼容 Apple Silicon iOS 26+ simulators
* 修复 Android 端 700001 回调不到达 Flutter 的问题
  - 所有 Config 类增加 setUIClickListener 注册
  - 移除 OneKeyLoginPublic 对 CODE_ERROR_USER_SWITCH 的过滤
* 修复 Android 端 getSdkVersion 方法未实现的问题
* 修复 iOS 端 privacyOffsetX 参数无效的问题（复制粘贴错误，4处）
* 修复 iOS 端 buildSheetPortraitModel 协议链接不生效的问题（appPrivacyOne -> protocolOneName/URL）
* 修复 iOS 端 protocolColor/protocolCustomColor 不生效的问题
* 修复 iOS 端 privacyAlertTitleOffsetY 被覆盖的问题
* 修复 iOS 端 privacyAlertContentHorizontalMargin 不支持的问题
* 统一 500001 状态码的消息文本
* 新增动态参数配置页面（ConfigEditorPage），支持可视化调整 AliAuthModel 全部参数
* 优化 Demo 页面布局，采用卡片式分组设计，提升视觉体验 
