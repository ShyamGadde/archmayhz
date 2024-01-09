GREEN='\033[0;32m'
RED='\033[0;31m'
LIGHTBLUE='\033[1;34m'
RESET='\033[0m'

print_message() {s
    color=$1
    message=$2
    width=$(tput cols)
    padding=$(((width - ${#message}) / 2))

    line=$(printf "%*s" "${width}" '' | tr ' ' '-')
    message_line=$(printf "%*s%s" "$padding" '' "$message")
    output="${color}\n${line}\n${message_line}\n${line}\n\n${RESET}"
    printf "$output"
}

print_info() {
    print_message "${LIGHTBLUE}" "$1"
}

print_warning() {
    print_message "${RED}" "$1"
}

print_success() {
    print_message "${GREEN}" "$1"
}

is_vm() {
    if (lscpu | grep -q "Hypervisor vendor"); then
        return 0
    elif (dmesg | grep -q "Booting paravirtualized kernel on bare hardware"); then
        return 1
    elif (systemd-detect-virt --quiet --container); then
        return 1
    elif (systemd-detect-virt --quiet); then
        return 0
    else
        return 1
    fi
}
