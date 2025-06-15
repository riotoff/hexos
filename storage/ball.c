// project compiler

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>

#define RESET "\x1b[0m"
#define RED "\x1b[31m"
#define GREEN "\x1b[32m"
#define YELLOW "\x1b[33m"
#define BLUE "\x1b[34m"
#define MAGENTA "\x1b[35m"
#define CYAN "\x1b[36m"
#define WHITE "\x1b[37m"
#define LIGHT_GRAY "\x1b[90m"

void print_colored(const char *color_code, const char *prefix, const char *action, const char *target) {
    printf("%s[%s]%s %s%s%s\n", color_code, prefix, RESET, action, GREEN, target);
}

void execute_command(const char *action, const char *target_path, const char *command) {
    print_colored(CYAN, "ball", action, target_path);
    int result = system(command);
    if (result != 0) {
        printf("%s[ERROR]%s Command failed: %s\n", LIGHT_GRAY, RESET, command);
        exit(1);
    }
}

int build_dir() {
    printf("Creating build/ directory...\n");
    
    if (access("build/", F_OK) == -1) {
        print_colored(CYAN, "ball", "Creating directory:", " build/");
        if (mkdir("build/", 0777) == -1) {
            printf("%s[ERROR]%s Failed to create build/ directory\n", LIGHT_GRAY, RESET);
            perror("Reason:");
            return 1;
        }
    }

    printf("Created build/ directory.\n");

    return 0;
}

int hexos16() {
    printf("\n%sBuilding hexOS-16...%s\n", WHITE, RESET);

    if (access("build/16/", F_OK) == -1) {
        print_colored(CYAN, "ball", "Creating directory:", "build/os/16/");
        if (mkdir("build/os/16/", 0777) == -1) {
            printf("%s[ERROR]%s Failed to create build/os/16/ directory\n", LIGHT_GRAY, RESET);
            perror("Reason:");
            return 1;
        }
    }

    execute_command("Assembling:", " src/16/bootloader/main.asm",
                    "nasm -f bin src/16/bootloader/main.asm -o build/16/bootloader.bin");

    execute_command("Assembling:", " src/16/kernel/main.asm",
                    "nasm -f bin srcs/16/kernel/main.asm -o build/16/kernel.bin");

    execute_command("Creating disk image:", " builds/16/hexos.img",
                    "dd if=/dev/zero of=build/16/disk.img bs=512 count=2880 2>/dev/null");

    execute_command("Writing bootloader:", " build/16/bootloader.bin",
                    "dd if=build/16/bootloader.bin of=build/16/disk.img conv=notrunc 2>/dev/null");

    execute_command("Writing kernel:", " build/16/kernel.bin",
                    "dd if=build/16/kernel.bin of=build/16/disk.img bs=512 seek=1 conv=notrunc 2>/dev/null");

    printf("Built hexOS-16.\n");

    return 0;
}

/*
int hexos32(); {
}
*/

/*
int hexos64(); {
}
*/

int main() {
    printf("%sStarting build process...%s\n\n", GREEN, RESET);

    build_dir();

    hexos16();
    // hexos32();
    // hexos64();

    printf("\n%sBuild has successfully completed.%s\n", GREEN, RESET);

    return 0;
}
