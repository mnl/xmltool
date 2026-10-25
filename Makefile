#!/usr/bin/env make

NAME := xmltool
TAG ?= latest
SRC_FILES := Dockerfile entrypoint.sh

build: .buildah_image_id

.buildah_image_id: $(SRC_FILES) .podman_host_ok
	buildah bud -f $< \
		--annotation=org.opencontainers.image.version="$(TAG)" \
		--annotation=org.opencontainers.image.revision="$(shell git rev-parse --short HEAD)" \
		--created-annotation \
		--iidfile=.buildah_image_id \
		--tag $(NAME):$(TAG)

.podman_host_ok:
	# Ensure that podman can build and run containers
	echo from scratch | podman build -qt $(NAME)-pause -
	podman run --replace --detach --rm \
		--name $(NAME)-pause --init localhost/$(NAME)-pause /run/podman-init -P
	podman stop $(NAME)-pause
	podman rmi $(NAME)-pause
	touch .podman_host_ok
	@echo "HOST IS OK (reset with make wipe)"

test: build
	podman run --init --replace -d --rm --name smoke \
		localhost/$(NAME):$(TAG) sleep 120s
	podman wait --condition running smoke
	podman exec smoke xmlstarlet --version
	podman exec smoke xmllint --version
	podman exec smoke xq --version
	podman rm -f smoke
	@echo SMOKE TEST PASSED

scan: build
	systemctl is-active podman.socket --user --quiet
	podman run --rm \
		--security-opt label=disable \
		-v "$${XDG_RUNTIME_DIR}/podman/podman.sock:/run/podman.sock" \
		-v trivy-cache:/root/.cache/trivy \
		docker.io/aquasec/trivy:latest image --scanners vuln \
		--image-src podman --podman-host /run/podman.sock \
		localhost/$(NAME):$(TAG)

clean:
	podman rmi -i $(NAME):$(TAG)
	$(RM) .buildah_image_id

wipe: clean
	$(RM) .podman_host_ok

.PHONY: clean build all wipe test scan

all: clean build test
