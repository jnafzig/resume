IMAGE_NAME := resume

.PHONY: docker-build serve build clean

docker-build:
	docker build -t $(IMAGE_NAME) .

serve: docker-build
	docker run --rm --name $(IMAGE_NAME) -p 4000:4000 -v "$(PWD)":/home/app $(IMAGE_NAME)

build: docker-build
	docker run --rm -v "$(PWD)":/home/app $(IMAGE_NAME) bundle exec jekyll build

clean:
	rm -rf _site .sass-cache .jekyll-cache
