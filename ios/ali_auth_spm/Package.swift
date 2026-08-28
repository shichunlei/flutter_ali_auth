// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ali_auth_spm",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "ali-auth-spm", targets: ["ali_auth_spm"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", exact: "5.21.3")
    ],
    targets: [
        .target(
            name: "ali_auth_spm",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "SDWebImage", package: "SDWebImage"),
                "ATAuthSDK",
                "YTXMonitor",
                "YTXOperators"
            ],
            resources: [
                .copy("Resources/ATAuthSDK.bundle"),
                .process("Resources/taobao.png")
            ],
            linkerSettings: [
                .linkedFramework("AuthenticationServices"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("Network"),
                .linkedFramework("WebKit"),
                .unsafeFlags(["-ObjC"])
            ]
        ),
        .binaryTarget(
            name: "ATAuthSDK",
            path: "Frameworks/ATAuthSDK.xcframework"
        ),
        .binaryTarget(
            name: "YTXMonitor",
            path: "Frameworks/YTXMonitor.xcframework"
        ),
        .binaryTarget(
            name: "YTXOperators",
            path: "Frameworks/YTXOperators.xcframework"
        )
    ]
)
