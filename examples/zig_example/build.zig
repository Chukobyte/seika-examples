const std = @import("std");

pub fn addBuildLibrary(exe: *std.Build.Step.Compile, includePath: []const u8, libPath: []const u8, linkFlags: []const u8) void {
    exe.addLibraryPath(.{ .path = libPath });
    exe.addIncludePath(.{ .path = includePath });
    var it = std.mem.split(u8, linkFlags, " ");
    while (it.next()) |flag| {
        exe.linkSystemLibrary(flag);
    }
}

pub fn build(b: *std.Build) void {
    const fetchContentDir = b.option([]const u8, "fetchContentDir", "Fetch content path for dependencies");
    const thirdpartyDir = b.option([]const u8, "thirdpartyDir", "Thirdpart path for dependencies");
    const libDirs = b.option([]const u8, "libDirs", "Library directory path");
    const includeDirs = b.option([]const u8, "includeDirs", "Include directory path");

    const allocator = std.heap.page_allocator;

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
    if (libDirs != null and libDirs.?.len > 0) {
        var libIt = std.mem.split(u8, libDirs.?, "+");
        while (libIt.next()) |dir| {
            exe.addLibraryPath(.{ .path = dir });
        }
    }

    if (includeDirs != null and includeDirs.?.len > 0) {
        var includeIt = std.mem.split(u8, includeDirs.?, "+");
        while (includeIt.next()) |dir| {
            exe.addIncludePath(.{ .path = dir });
        }
    }


    exe.linkLibC();

    // pthread (GC2)
    const pthreadIncludeDir = std.fmt.allocPrint(allocator, "{s}{s}", .{thirdpartyDir.?, "pthreads-win32/include"}) catch "Format failed";
    const pthreadLibDir = std.fmt.allocPrint(allocator, "{s}{s}", .{thirdpartyDir.?, "pthreads-win32/lib/x64"}) catch "Format failed";
    addBuildLibrary(
        exe,
        pthreadIncludeDir,
        pthreadLibDir,
        "pthreadGC2"
    );

    exe.linkSystemLibrary("gcc_eh");
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

    // freetype
    const freetypeIncludeDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "freetype_content-src/include"}) catch "Format failed";
    const freetypeLibDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "freetype_content-build"}) catch "Format failed";
    addBuildLibrary(
        exe,
        freetypeIncludeDir,
        freetypeLibDir,
        if (optimize != std.builtin.Mode.Debug) "freetyped" else "freetype"
    );

    // SDL3
    const sdlIncludeDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "sdl_content-src/include"}) catch "Format failed";
    const sdlLibDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "sdl_content-build"}) catch "Format failed";
    addBuildLibrary(
        exe,
        sdlIncludeDir,
        sdlLibDir,
        "SDL3"
    );

    // glad
    const gladIncludeDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "seika_content-build"}) catch "Format failed";
    const gladLibDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "seika_content-src/thirdparty"}) catch "Format failed";
    addBuildLibrary(
        exe,
        gladIncludeDir,
        gladLibDir,
        "glad"
    );

    // zip
    const zipIncludeDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "kuba_zip_content-src/src"}) catch "Format failed";
    const zipLibDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "kuba_zip_content-build"}) catch "Format failed";
    addBuildLibrary(
        exe,
        zipIncludeDir,
        zipLibDir,
        "zip"
    );

    // stb_image
    const stbImageIncludeDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "seika_content-src/thirdparty"}) catch "Format failed";
    const stbImageLibDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "seika_content-build"}) catch "Format failed";
    addBuildLibrary(
        exe,
        stbImageIncludeDir,
        stbImageLibDir,
        "stb_image"
    );

    // seika
    const seikaIncludeDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "seika_content-src"}) catch "Format failed";
    const seikaLibDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "seika_content-build"}) catch "Format failed";
    addBuildLibrary(
        exe,
        seikaIncludeDir,
        seikaLibDir,
        "seika"
    );

    b.installArtifact(exe);
}
