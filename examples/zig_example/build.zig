const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const zeika_dep = b.dependency("zeika", .{
        .target = target,
        .optimize = optimize,
    });
    const zeika_module = zeika_dep.module("zeika");

    const exe = b.addExecutable(.{
        .name = "zig_example",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibC();
    const seika_lib: *std.Build.Step.Compile = zeika_dep.artifact("seika");
    exe.linkLibrary(seika_lib);
    exe.installLibraryHeaders(seika_lib);
    exe.root_module.addImport("zeika", zeika_module);
    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_exe.step);
}
