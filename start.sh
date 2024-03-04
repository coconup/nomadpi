GREY='\033[90m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m' # No Color

docker-compose up -d

echo -e "${BOLD}Services successfully started${NC}"
echo -e "${GREEN}Frontend:           http://$(host).local:3000${NC}"
echo -e "${GREY}---------------------------------------------${NC}"
echo -e "Portainer:          http://$(host).local:9000"
echo -e "Core API:           http://$(host).local:1880"
echo -e "Automation API:     http://$(host).local:1881"
echo -e "Frigate:            http://$(host).local:5000"