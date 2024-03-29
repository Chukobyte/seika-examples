const std = @import("std");
const seika = @cImport({
    @cInclude("seika.h");
});

pub fn main() void {
    std.debug.print("Hello, {s}!\n", .{"World"});

    const success = seika.ska_init_all("Simple Window", 800, 600, 800, 600);
    if (!success) {
        std.debug.print("Failed to initialize seika\n", .{});
        return;
    }
}
