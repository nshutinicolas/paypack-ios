// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Paypack",
	platforms: [
		.iOS(.v13), .macOS(.v11)
	],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Paypack",
            targets: ["Paypack"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Paypack"),
        .testTarget(
            name: "PaypackTests",
            dependencies: ["Paypack"]),
    ]
)
