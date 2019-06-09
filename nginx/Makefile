up:
	docker-compose up -d --build

down:
	docker-compose down

test:
	curl 'http://localhost/fredcast' | jq '.'
	curl 'http://localhost/fredcast/health' | jq '.'
