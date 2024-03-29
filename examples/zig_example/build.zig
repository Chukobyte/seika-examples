const std = @import("std");

pub fn build(b: *std.Build) void {
    const libDirs = b.option([]const u8, "libDirs", "Library directory path");
    const includeDirs = b.option([]const u8, "includeDirs", "Include directory path");

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "zig_example",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibC();

    // Split the paths and add them
    var libIt = std.mem.split(u8, libDirs.?, "+");
    while (libIt.next()) |dir| {
        exe.addLibraryPath(.{ .path = dir });
    }

    var includeIt = std.mem.split(u8, includeDirs.?, "+");
    while (includeIt.next()) |dir| {
        exe.addIncludePath(.{ .path = dir });
    }

    exe.linkSystemLibrary("seika");
    exe.linkSystemLibrary("SDL3");

    b.installArtifact(exe);
}
