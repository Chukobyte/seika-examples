#include <stdlib.h>

#include <seika/seika.h>

int main(int argv, char** args) {
    ska_init_all("Simple Window", 800, 600, 800, 600);

    while (ska_is_running()) {
        ska_update();
        ska_window_render();
    }

    ska_shutdown_all();

    return EXIT_SUCCESS;
}