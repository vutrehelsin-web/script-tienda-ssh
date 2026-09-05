#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

void print_usage(const char *prog_name) {
    printf("DTUNEL Secure Tunnel Daemon v1.0\n");
    printf("Usage: %s --port <port> --mode <mode>\n", prog_name);
    printf("  --port, -p    Port number to listen on (default: 443)\n");
    printf("  --mode, -m    Tunnel mode (e.g. secure, direct, proxy) (default: secure)\n");
    printf("  --help, -h    Display this help message\n");
}

int main(int argc, char *argv[]) {
    int port = 443;
    char mode[64] = "secure";

    static struct option long_options[] = {
        {"port", required_argument, 0, 'p'},
        {"mode", required_argument, 0, 'm'},
        {"help", no_argument, 0, 'h'},
        {0, 0, 0, 0}
    };

    int opt;
    int option_index = 0;

    while ((opt = getopt_long(argc, argv, "p:m:h", long_options, &option_index)) != -1) {
        switch (opt) {
            case 'p':
                port = atoi(optarg);
                break;
            case 'm':
                strncpy(mode, optarg, sizeof(mode) - 1);
                mode[sizeof(mode) - 1] = '\0';
                break;
            case 'h':
                print_usage(argv[0]);
                return 0;
            default:
                print_usage(argv[0]);
                return 1;
        }
    }

    printf("Starting DTUNEL daemon on port %d with mode '%s'...\n", port, mode);
    
    // Daemonize process if needed, or maintain standard execution loop
    while (1) {
        sleep(60);
    }

    return 0;
}
