// swift-tools-version:3.1

import PackageDescription

let package = Package(
  name: "perfect-hello-world",
  dependencies: [
    .Package(url: "http://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2)
  ]
)
