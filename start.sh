GREY='\033[90m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m' # No Color

docker-compose build 
docker-compose --profile core up -d
docker-compose --profile core --profile accessory up -d

echo -e "${BOLD}nomadPi services successfully started${NC}"
echo -e "${GREEN}Frontend:           http://$(hostname).local:3000${NC}"
echo -e "${GREY}---------------------------------------------${NC}"
echo -e "Portainer:          http://$(hostname).local:9000"
echo -e "Core API:           http://$(hostname).local:1880"
echo -e "Automation API:     http://$(hostname).local:1881"
echo -e "Frigate:            http://$(hostname).local:5000"