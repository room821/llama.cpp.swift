// swift-tools-version:5.5

import PackageDescription

var sources = [
    "ggml/ggml.c",
    "ggml/src/ggml-cpu/llamafile/sgemm.cpp",
    "src/llama.cpp",
    "src/unicode.cpp",
    "src/unicode-data.cpp",
    "ggml/ggml-alloc.c",
    "ggml/ggml-backend.c",
    "ggml/ggml-quants.c",
]

#if canImport(Darwin)
sources.append("ggml-metal.m")
resources.append(.process("ggml-metal.metal"))
linkerSettings.append(.linkedFramework("Accelerate"))
cSettings.append(
    contentsOf: [
        .define("GGML_USE_ACCELERATE"),
        .define("GGML_USE_METAL")
    ]
)
#endif

let package = Package(
    name: "llama",
    platforms: [
        .macOS(.v12),
        .iOS(.v14),
        .watchOS(.v4),
        .tvOS(.v14)
    ],
    products: [
        .library(name: "llama", targets: ["llama"]),
    ],
    targets: [
         .target(
            name: "llama",
            path: ".",
            exclude: [
               "cmake",
               "examples",
               "scripts",
               "models",
               "tests",
               "CMakeLists.txt",
               "Makefile"
            ],
            sources: sources,
            resources: resources,
            publicHeadersPath: "spm-headers",
            cSettings: cSettings,
            linkerSettings: linkerSettings
        )
    ]
)
