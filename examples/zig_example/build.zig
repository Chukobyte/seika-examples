const std = @import("std");

pub fn build(b: *std.Build) void {
    const libDir = b.option([]const u8, "libDir", "Library directory path");
    const includeDir = b.option([]const u8, "includeDir", "Include directory path");

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "zig_example",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibC();
    exe.addIncludePath(.{ .path = includeDir.? });
    exe.addLibraryPath(.{ .path = libDir.? });
    exe.linkSystemLibrary("seika");

    b.installArtifact(exe);
}
