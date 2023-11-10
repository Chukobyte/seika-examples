#include <stdlib.h>

#include <seika/seika.h>

int main(int argv, char** args) {
    sf_initialize_simple("Simple Window", 800, 600);

    while (sf_is_running()) {
        sf_process_inputs();
        sf_render();
    }

    sf_shutdown();

    return EXIT_SUCCESS;
}