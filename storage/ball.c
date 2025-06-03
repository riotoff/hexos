// project compiler

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>

#define RESET   "\x1b[0m"
#define GREEN   "\x1b[32m"
#define CYAN    "\x1b[36m"
#define GRAY    "\x1b[90m"

void print_colored(const char* prefix, const char* action, const char* target) {
    printf("%s[%s]%s %s%s%s\n", CYAN, prefix, RESET, action, GREEN, target);
}

void execute_command(const char* action, const char* target, const char* command) {
    print_colored("ball", action, target);
    int result = system(command);
    if (result != 0) {
        printf("%s[ERROR]%s Command failed: %s\n", GRAY, RESET, command);
        exit(1);
    }
}

int build_dir() {
    if (access("build/", F_OK) == -1) {
        print_colored("ball", "Creating directory: ", "build/");
	printf("\n");
        if (mkdir("build/", 0777) == -1) {
            printf("%s[ERROR]%s Failed to create build/ directory\n", GRAY, RESET);
            perror("  Reason");
            return 1;
        }
    if (access("build/hexos/", F_OK) == -1) {
        print_colored("ball", "Creating directory: ", "build/hexos/");
	printf("\n");
        if (mkdir("build/hexos/", 0777) == -1) {
            printf("%s[ERROR]%s Failed to create build/hexos/ directory\n", GRAY, RESET);
            perror("  Reason");
            return 1;
        }
    if (access("build/vm/", F_OK) == -1) {
        print_colored("ball", "Creating directory: ", "build/vm/");
	printf("\n");
        if (mkdir("build/vm/", 0777) == -1) {
            printf("%s[ERROR]%s Failed to create build/vm/ directory\n", GRAY, RESET);
            perror("  Reason");
            return 1;
        }
    }
}

//int vm() {
//}

int hexos16() {
    printf("Building hexOS-16...\n");

    if (access("build/hexos-16/", F_OK) == -1) {
        print_colored("ball", "Creating directory: ", "build/hexos/16/");
        if (mkdir("build/hexos-16/", 0777) == -1) {
            printf("%s[ERROR]%s Failed to create build/hexos-16/ directory\n", GRAY, RESET);
            perror("  Reason");
            return 1;
        }
    }

    execute_command("Assembling: ", "src/hexos/16/bootloader/main.asm", 
                  "nasm -f bin src/hexos/16/bootloader/main.asm -o build/hexos/16/bootloader.bin");
    
    execute_command("Assembling: ", "src/hexos/16/kernel/main.asm", 
                  "nasm -f bin src/hexos/16/kernel/main.asm -o build/hexos/16/kernel.bin");

    execute_command("Creating disk image: ", "build/hexos/16/hexos.img", 
                  "dd if=/dev/zero of=build/hexos/16/hexos.img bs=512 count=2880 2>/dev/null");

    execute_command("Writing bootloader: ", "build/hexos/16/bootloader.bin", 
                  "dd if=build/hexos/16/bootloader.bin of=build/hexos/16/hexos.img conv=notrunc 2>/dev/null");

    execute_command("Writing kernel: ", "build/hexos/16/kernel.bin", 
                  "dd if=build/hexos/16/kernel.bin of=build/hexos/16/hexos.img bs=512 seek=1 conv=notrunc 2>/dev/null");
}

//int hexos32() {
//}
//
//int hexos64() {
//
//}

int main() {
    printf("%sStarting build process...%s\n\n", GREEN, RESET);
    
    build_dir();
//    vm();
    hexos16();
//    hexos32();
//    hexos64();

    printf("\n%sBuild has successfully completed.%s\n", GREEN, RESET);


    return 0;
}
