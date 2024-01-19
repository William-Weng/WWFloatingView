// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWFloatingViewController",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWFloatingViewController", targets: ["WWFloatingViewController"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWPrint.git", from: "1.3.0"),
    ],
    targets: [
        .target(name: "WWFloatingViewController", dependencies: ["WWPrint"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
