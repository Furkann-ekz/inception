NAME=inception

all:
	docker-compose -f srcs/docker-compose.yml --env-file srcs/.env up --build -d

down:
	docker-compose -f srcs/docker-compose.yml --env-file srcs/.env down

fclean: down
	docker system prune -af || true
	-docker volume rm $$(docker volume ls -q)

re: fclean all
