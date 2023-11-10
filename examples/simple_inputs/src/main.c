#include <stdlib.h>

#include <seika/seika.h>
#include <seika/input/input.h>

int main(int argv, char** args) {
    sf_initialize_simple("Simple Window", 800, 600);

    // Add input actions
    se_input_add_action_value("exit", "esc", 0);
    se_input_add_action_value("print", "space", 0);

    while (sf_is_running()) {
        sf_process_inputs();

        if (se_input_is_action_just_pressed("exit")) {
            break;
        }

        if (se_input_is_action_just_pressed("print")) {
            printf("space just pressed\n");
        }
        if (se_input_is_action_pressed("print")) {
            printf("space pressed\n");
        }
        if (se_input_is_action_just_released("print")) {
            printf("space just released\n");
        }

        sf_render();

        se_input_clean_up_flags();
    }

    sf_shutdown();

    return EXIT_SUCCESS;
}