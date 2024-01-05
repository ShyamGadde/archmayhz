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
