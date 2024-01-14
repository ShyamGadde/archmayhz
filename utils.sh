GREEN='\033[0;32m'
RED='\033[0;31m'
LIGHTBLUE='\033[1;34m'
RESET='\033[0m'

print_message() {
    color=$1
    message=$2
    width=$(tput cols)
    padding=$(((width - ${#message}) / 2))

    printf "${color}\n%*s\n" "${width}" '' | tr ' ' '-'
    printf "%*s%s\n" $padding '' "$message"
    printf "%*s\n\n${RESET}" "${width}" '' | tr ' ' '-'
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

backup_file() {
    if [ -f "$1" ]; then
        cp "$1" "$1.bak"
    fi
}

apply_config() {
    local filename = $1
    local url = "https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/configs${filename}"
    curl -fsSL $url >$filename
}
