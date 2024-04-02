const std = @import("std");
const seika = @cImport({
    @cInclude("seika/seika.h");
});
const input = @cImport({
    @cInclude("seika/input/input.h");
});

pub fn main() void {
    const success = seika.ska_init_all("Zig Window", 800, 600, 800, 600);
    if (!success) {
        std.debug.print("Failed to initialize seika\n", .{});
        return;
    }

    while (seika.ska_is_running()) {
        seika.ska_update();

        // Exit when escape is pressed
        if (input.ska_input_is_key_just_pressed(input.SkaInputKey_KEYBOARD_ESCAPE, 0)) {
            break;
        }

        seika.ska_window_render();
    }

    seika.ska_shutdown_all();
}
