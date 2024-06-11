#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void)
{
    puts("Hello, World!");

    while (1)
    {
        sleep(1);
    }

    return EXIT_SUCCESS;
}
