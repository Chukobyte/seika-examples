#include <stdlib.h>
#include <stdio.h>

#include <seika/seika.h>
#include <seika/input/input.h>

int main(int argv, char** args) {
    ska_init_all("Simple Window", 800, 600, 800, 600);

    while (ska_is_running()) {
        ska_update();

        if (ska_input_is_key_just_pressed(SkaInputKey_KEYBOARD_ESCAPE, 0)) {
            break;
        }

        if (ska_input_is_key_just_pressed(SkaInputKey_KEYBOARD_SPACE, 0)) {
            printf("space just pressed\n");
        }
        if (ska_input_is_key_pressed(SkaInputKey_KEYBOARD_SPACE, 0)) {
            printf("space pressed\n");
        }
        if (ska_input_is_key_just_released(SkaInputKey_KEYBOARD_SPACE, 0)) {
            printf("space just released\n");
        }

        ska_window_render();
    }

    ska_shutdown_all();

    return EXIT_SUCCESS;
}