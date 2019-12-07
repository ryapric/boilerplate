docker-build:
	@docker build -f Dockerfile-airflow -t ryapric/airflow:latest .

dc-up:
	@make -s docker-build
	@docker-compose up -d --build
	@printf '\nTesting stack, waiting 10 seconds first for everything to come up...\n' && sleep 10
	@(make -s dc-ps | grep -v -E 'Restart|Exit') || (printf "Oops, something went wrong in the stack deployment!\n" && exit 1)
	@curl -f 'localhost:8080/api/experimental/test' || (printf "Oops, Airflow webserver failed!\n" && exit 1)
	@printf "\nAll tests passed, Airflow stack is alive & well!\n"

dc-ps:
	@docker-compose ps

dc-down:
	@docker-compose down

# Initialize the host system requirements
dc-host-sysinit:
	@bash ./helpers/sysinit/deb-sysinit.sh
