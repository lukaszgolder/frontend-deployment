#!/usr/bin/make -f

-include Makefile.in

AWS_ACCESS_KEY_ID ?=
AWS_SECRET_KEY_ID ?=
BUCKET_NAME ?=programowanko
AWS_DEFAULT_REGION=eu-central-1

BUILD_COMMAND =npm install && npm run build
BUILD_DIRECTORY =build

prod:
	docker run \
	--rm --entrypoint /bin/bash \
	-v "$(shell pwd):/usr/src/app" \
	-w /usr/src/app \
  node:7.0.0 \
	-c "$(BUILD_COMMAND)"

deploy:prod
	docker run \
	-v $(shell pwd)/$(BUILD_DIRECTORY):/usr/build \
	--env AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
	--env AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_KEY_ID) \
	--env AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) \
	garland/aws-cli-docker \
	/bin/sh \
		-c "aws s3 rm s3://$(BUCKET_NAME)/ --recursive; aws s3 cp /usr/build s3://$(BUCKET_NAME)/ --recursive --acl public-read --cache-control max-age=31536000"
