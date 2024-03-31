const std = @import("std");
const seika = @cImport({
    @cInclude("seika/seika.h");
});

pub fn main() void {
    std.debug.print("Hello, {s}!\n", .{"World"});

    const success = seika.ska_init_all("Zig Window", 800, 600, 800, 600);
    if (!success) {
        std.debug.print("Failed to initialize seika\n", .{});
        return;
    }

    while (seika.ska_is_running()) {
        seika.ska_update();
        seika.ska_window_render();
    }

    seika.ska_shutdown_all();
}
