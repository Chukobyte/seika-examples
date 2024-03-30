const std = @import("std");

pub fn build(b: *std.Build) void {
    const libDirs = b.option([]const u8, "libDirs", "Library directory path");
    const includeDirs = b.option([]const u8, "includeDirs", "Include directory path");

    const target = b.standardTargetOptions(.{});
    // const optimize = b.standardOptimizeOption(.{});
    const optimize = std.builtin.Mode.ReleaseSafe;
    const exe = b.addExecutable(.{
        .name = "zig_example",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // Split the paths and add them
    var libIt = std.mem.split(u8, libDirs.?, "+");
    while (libIt.next()) |dir| {
        exe.addLibraryPath(.{ .path = dir });
    }

    var includeIt = std.mem.split(u8, includeDirs.?, "+");
    while (includeIt.next()) |dir| {
        exe.addIncludePath(.{ .path = dir });
    }


    exe.linkSystemLibrary("gdi32");
    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("shell32");
    exe.linkSystemLibrary("imm32");
    exe.linkSystemLibrary("version");
    exe.linkSystemLibrary("ole32");
    exe.linkSystemLibrary("winmm");
    exe.linkSystemLibrary("cfgmgr32");
    exe.linkSystemLibrary("oleaut32");
    exe.linkSystemLibrary("ws2_32");
    exe.linkSystemLibrary("SDL3");
    exe.linkSystemLibrary("seika");
    exe.linkSystemLibrary("glad");
    exe.linkSystemLibrary("stb_image");
    exe.linkSystemLibrary("freetype");
    exe.linkSystemLibrary("zip");

    exe.linkLibC();

    b.installArtifact(exe);
}
