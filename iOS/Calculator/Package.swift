// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "Calculator",
    products: [
        .library(
            name: "Calculator",
            targets: ["Calculator"]),
    ],
    targets: [
        .target(name: "Calculator"),
        .testTarget(name: "CalculatorTests", dependencies: ["Calculator"]),
    ]
)
