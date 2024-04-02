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
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "zig_example",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const cwd = std.fs.cwd().realpathAlloc(allocator, ".") catch unreachable;
    const executableDir = std.fmt.allocPrint(allocator, "{s}/zig-out/bin/", .{cwd}) catch "Format failed";

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

    const localMingwLibDir = std.fmt.allocPrint(allocator, "{s}{s}", .{thirdpartyDir.?, "x86_64-w64-mingw-13.1.0"}) catch "Format failed";
    exe.addLibraryPath(.{ .path = localMingwLibDir });

    const localMingwDllsDir = std.fmt.allocPrint(allocator, "{s}/{s}", .{localMingwLibDir, "dlls"}) catch "Format failed";
    var iter_dir = std.fs.openDirAbsolute(localMingwDllsDir, .{ .iterate = true }) catch unreachable;
    defer iter_dir.close();
    var iter = iter_dir.iterate();
    while (true) {
        const entry = iter.next() catch {
            continue;
        };
        if (entry == null) break;
        const currentDllSourcePath = std.fmt.allocPrint(allocator, "{s}/{s}", .{localMingwDllsDir, entry.?.name}) catch "Format failed";
        const currentDllDestPath = std.fmt.allocPrint(allocator, "{s}{s}", .{executableDir, entry.?.name}) catch "Format failed";
        std.fs.copyFileAbsolute(currentDllSourcePath, currentDllDestPath, .{}) catch unreachable;
    }

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
    const freetypeDLLName = if (optimize == std.builtin.Mode.Debug) "freetyped.dll" else "freetype.dll";
    addBuildLibrary(
        exe,
        freetypeIncludeDir,
        freetypeLibDir,
        freetypeDLLName
    );
    const freetypeSourcePath = std.fmt.allocPrint(allocator, "{s}/lib{s}", .{freetypeLibDir, freetypeDLLName}) catch "Format failed";
    const freetypeDLLDestPath = std.fmt.allocPrint(allocator, "{s}lib{s}", .{executableDir, freetypeDLLName}) catch "Format failed";
    std.fs.copyFileAbsolute(freetypeSourcePath, freetypeDLLDestPath, .{}) catch unreachable;

    // SDL3
    const sdlIncludeDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "sdl_content-src/include"}) catch "Format failed";
    const sdlLibDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "sdl_content-build"}) catch "Format failed";
    addBuildLibrary(
        exe,
        sdlIncludeDir,
        sdlLibDir,
        "SDL3"
    );
    const sdlDLLSourcePath = std.fmt.allocPrint(allocator, "{s}/{s}", .{sdlLibDir, "SDL3.dll"}) catch "Format failed";
    const sdlDLLDestPath = std.fmt.allocPrint(allocator, "{s}{s}", .{executableDir, "SDL3.dll"}) catch "Format failed";
    std.fs.copyFileAbsolute(sdlDLLSourcePath, sdlDLLDestPath, .{}) catch unreachable;

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

    // cglm
    const cglmIncludeDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "cglm_content-src/include"}) catch "Format failed";
    const cglmLibDir = std.fmt.allocPrint(allocator, "{s}{s}", .{fetchContentDir.?, "cglm_content-build"}) catch "Format failed";
    addBuildLibrary(
        exe,
        cglmIncludeDir,
        cglmLibDir,
        "cglm.dll"
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
