build:
	@docker build -f Dockerfile-prometheus -t prometheus:latest .
	@docker build -f Dockerfile-node_exporter -t node_exporter:latest .

up:
	@docker-compose up -d --build

down:
	@docker-compose down
