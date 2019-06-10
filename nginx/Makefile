up:
	docker-compose up -d --build

down:
	docker-compose down

lb-up:
	docker build --no-cache -t nginx-lb:latest -f Dockerfile-nginx-lb .
	docker run -d -p 80:80 --name nginx-lb nginx-lb:latest

lb-down:
	docker stop nginx-lb
	docker rm nginx-lb

test:
	curl 'http://localhost/fredcast' | jq '.'
	curl 'http://localhost/fredcast/health' | jq '.'
