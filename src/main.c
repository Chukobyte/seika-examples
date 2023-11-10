#include <stdlib.h>
#include <stdio.h>

#include "../seika/seika.h"

int main(int argv, char** args) {
    printf("Hello, World!\n");

    sf_initialize_simple("test", 800, 600);

    while (sf_is_running()) {
        sf_process_inputs();
    }

    for (int i = 0; i < 9999999; i++) {}

    sf_shutdown();

    return EXIT_SUCCESS;
}