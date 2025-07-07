
# Variables
COMPOSE_FILE = ./srcs/docker-compose.yml
DATA_PATH = /home/fzayani/shared_inception/data

# Colors for output
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[0;33m
NC = \033[0m # No Color

.PHONY: all build up down clean fclean re logs status help

# Default target
all: up

# Build all images
build:
	@echo "$(YELLOW)Building Docker images...$(NC)"
	@mkdir -p $(DATA_PATH)/wordpress $(DATA_PATH)/mariadb
	@docker compose -f $(COMPOSE_FILE) build
	@echo "$(GREEN)Build completed!$(NC)"

# Start services
up: build
	@echo "$(YELLOW)Starting services...$(NC)"
	@docker compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN)Services started!$(NC)"
	@echo "$(GREEN)WordPress is available at: https://fzayani.42.fr$(NC)"

stop:
	@echo "$(YELLOW)Stopping services...$(NC)"
	@docker compose -f $(COMPOSE_FILE) stop
	@echo "$(GREEN)Services stopped!$(NC)"

# Stop services
down:
	@echo "$(YELLOW)Stopping services...$(NC)"
	@docker compose -f $(COMPOSE_FILE) down
	@echo "$(GREEN)Services stopped!$(NC)"

# Clean containers and networks
clean: down
	@echo "$(YELLOW)Cleaning containers and networks...$(NC)"
	@docker system prune -f
	@echo "$(GREEN)Cleanup completed!$(NC)"

# Full clean (containers, networks, volumes, images)
fclean: down
	@echo "$(RED)Full cleanup - removing all Docker data...$(NC)"
	@docker compose -f $(COMPOSE_FILE) down -v --rmi all
	@docker system prune -a -f --volumes
	@sudo rm -rf $(DATA_PATH)/wordpress/* $(DATA_PATH)/mariadb/*
	@echo "$(GREEN)Full cleanup completed!$(NC)"

# Restart everything
re: fclean up

# Show logs
logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

# Show logs for specific service
logs-nginx:
	@docker compose -f $(COMPOSE_FILE) logs -f nginx

logs-wordpress:
	@docker compose -f $(COMPOSE_FILE) logs -f wordpress

logs-mariadb:
	@docker compose -f $(COMPOSE_FILE) logs -f mariadb

logs-adminer:
	@docker compose -f $(COMPOSE_FILE) logs -f adminer

logs-ftp:
	@docker compose -f $(COMPOSE_FILE) logs -f ftp

logs-backup:
	@docker compose -f $(COMPOSE_FILE) logs -f backup

# Show status of containers
status:
	@echo "$(YELLOW)Container status:$(NC)"
	@docker compose -f $(COMPOSE_FILE) ps

# Enter containers
shell-nginx:
	@docker compose -f $(COMPOSE_FILE) exec nginx /bin/bash

shell-wordpress:
	@docker compose -f $(COMPOSE_FILE) exec wordpress /bin/bash

shell-mariadb:
	@docker compose -f $(COMPOSE_FILE) exec mariadb /bin/bash

shell-backup:
	@docker compose -f $(COMPOSE_FILE) exec backup /bin/bash

# Check /etc/hosts configuration
check-hosts:
	@echo "$(YELLOW)Checking /etc/hosts configuration...$(NC)"
	@if grep -q "fzayani.42.fr" /etc/hosts; then \
		echo "$(GREEN)fzayani.42.fr is configured in /etc/hosts$(NC)"; \
	else \
		echo "$(RED)fzayani.42.fr is NOT configured in /etc/hosts$(NC)"; \
		echo "$(YELLOW)Please add: 127.0.0.1 fzayani.42.fr$(NC)"; \
	fi

# Setup hosts file (requires sudo)
setup-hosts:
	@echo "$(YELLOW)Adding fzayani.42.fr to /etc/hosts...$(NC)"
	@echo "127.0.0.1 fzayani.42.fr" | sudo tee -a /etc/hosts
	@echo "$(GREEN)Hosts file updated!$(NC)"

# Help
help:
	@echo "$(GREEN)Inception Makefile Commands:$(NC)"
	@echo "  $(YELLOW)make$(NC) or $(YELLOW)make all$(NC)     - Build and start all services"
	@echo "  $(YELLOW)make build$(NC)           - Build Docker images"
	@echo "  $(YELLOW)make up$(NC)              - Start services"
	@echo "  $(YELLOW)make down$(NC)            - Stop services"
	@echo "  $(YELLOW)make clean$(NC)           - Clean containers and networks"
	@echo "  $(YELLOW)make fclean$(NC)          - Full cleanup (everything)"
	@echo "  $(YELLOW)make re$(NC)              - Restart everything (fclean + up)"
	@echo "  $(YELLOW)make logs$(NC)            - Show all logs"
	@echo "  $(YELLOW)make logs-[service]$(NC)  - Show logs for specific service"
	@echo "  $(YELLOW)make status$(NC)          - Show container status"
	@echo "  $(YELLOW)make shell-[service]$(NC) - Enter container shell"
	@echo "  $(YELLOW)make check-hosts$(NC)     - Check hosts file configuration"
	@echo "  $(YELLOW)make setup-hosts$(NC)     - Add domain to hosts file"
	@echo "  $(YELLOW)make help$(NC)            - Show this help"