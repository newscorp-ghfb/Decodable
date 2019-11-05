// swift-tools-version:5.1

import PackageDescription

let package = Package(name: "Decodable",
                      platforms: [
                        .iOS(.v8),
                        .macOS(.v10_10),
                        .tvOS(.v9),
                        .watchOS(.v2)
    ],
                      products:
    [
        .library(name: "Decodable",
                 targets: ["Decodable"])
    ],
                      targets: [
                        .target(name: "Decodable",
                                path: "Sources"),
//                        .testTarget(name: "DecodableTests",
//                                    path: "Tests")
    ],
                      swiftLanguageVersions: [.v5, .v4_2])
