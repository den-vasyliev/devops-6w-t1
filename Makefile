APP_NAME=kbot
REGISTRY=ottomen
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
NAME=ottomenbot-$(VERSION)
TARGET_OS=darwin
TARGET_ARCH=arm64
IMAGE_NAME=$(REGISTRY)/$(NAME)


###############################################################################
# Core GO commands
###############################################################################

deps:
	go get

lint:
	golint ./...

test:
	go test

format: 
	gofmt -s -w .

build: format test deps
	CGO_ENABLED=0 GOOS=$(TARGET_OS) GOARCH=$(TARGET_ARCH) go build -v -o $(APP_NAME) -ldflags "-X="github.com/ottomen/ottomenbot/cmd.appVersion=$(VERSION)

run:
	go run main.go ottomenbot

###############################################################################
# Building the Go app
###############################################################################

linux:
	TARGET_OS=linux TARGET_ARCH=amd64 make build

arm:
	TARGET_ARCH=arm TARGET_ARCH=arm64 make build

macOS:
	TARGET_OS=darwin TARGET_ARCH=arm64 make build

windows:
	TARGET_OS=windows TARGET_ARCH=x64 make build
	

###############################################################################
# Building the image
###############################################################################	

image: 
	docker build . -t $(IMAGE_NAME)  --build-arg build_type=linux

image-linux: 
	docker build . -t $(IMAGE_NAME):linux-arm64  --build-arg build_type=linux

image-arm: 
	docker build . -t $(IMAGE_NAME):arm-arm64  --build-arg build_type=arm

image-macOS: 
	docker build . -t $(IMAGE_NAME):macOS-arm64 --build-arg build_type=macOS

image-windows: 
	docker build . -t $(IMAGE_NAME):windows-x64 --build-arg build_type=windows


###############################################################################
# Pushing image to registry
###############################################################################	

push-linux: 
	docker push $(IMAGE_NAME):linux-arm64	

push-arm: 
	docker push $(IMAGE_NAME):arm-arm64	

push-macOS: 
	docker push $(IMAGE_NAME):macOS-arm64	

push-windows: 
	docker push $(IMAGE_NAME):windows-x64


###############################################################################
# Cleaning up
###############################################################################		

clean:
	rm -rf $(APP_NAME)		
	docker rmi -f $(IMAGE_NAME)

clean-linux: clean	
	docker rmi -f $(IMAGE_NAME):linux-arm64

clean-arm: clean	
	docker rmi -f $(IMAGE_NAME):arm-arm64

clean-macOS: clean	
	docker rmi -f $(IMAGE_NAME):macOS-arm64

clean-windows: clean	
	docker rmi -f $(IMAGE_NAME):windows-x64
