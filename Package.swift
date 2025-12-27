// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BlockchainSimPlus",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BlockchainLogic",
            targets: ["BlockchainLogic"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BlockchainLogic",
            path: "Blockchain/Blockchain",
            exclude: [
                "App",          // Exclude UI/App Lifecycle code
                "Presentation", // Exclude ViewModels/Views (likely import SwiftUI)
                "Info.plist"    // Exclude plist if present in root of that folder
            ],
            sources: [
                "Domain",
                "Data"
            ]
        ),
        .testTarget(
            name: "BlockchainSimPlusTests",
            dependencies: ["BlockchainLogic"],
            path: "Tests"
        ),
    ]
)
