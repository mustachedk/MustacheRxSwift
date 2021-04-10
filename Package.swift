// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "MustacheRxSwift",
  platforms: [
    .iOS(.v11)
  ],
  products: [
    .library(name: "MustacheRxSwift", targets: ["MustacheRxSwift"]),
  ],
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
    .package(url: "https://github.com/RxSwiftCommunity/RxSwiftExt.git", .upToNextMajor(from: "6.0.0")),
    .package(url: "https://github.com/mustachedk/RxViewController.git", .upToNextMajor(from: "2.0.1")),
    .package(url: "https://github.com/mustachedk/MustacheServices", .upToNextMajor(from: "6.0.0")),
    .package(url: "https://github.com/mustachedk/MustacheUIKit", .upToNextMajor(from: "3.0.0")),
 ],
  targets: [
    .target(name: "MustacheRxSwift", dependencies: ["RxSwift", "RxSwiftExt", "RxViewController", "MustacheServices", "MustacheUIKit"])
  ]
)
