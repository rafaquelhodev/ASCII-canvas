compose-build:
	docker-compose --env-file .docker_env build

compose-up:
	docker-compose --env-file .docker_env up

compose-test:
	docker-compose --env-file .docker_env run web mix test

.PHONY: compose-build compose-up compose-test
