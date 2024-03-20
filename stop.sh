BOLD='\033[1m'
NC='\033[0m' # No Color

docker-compose --profile core --profile accessory down

echo -e "${BOLD}nomadPi services successfully stopped${NC}"