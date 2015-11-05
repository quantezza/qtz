SHELL := /bin/bash
NAME := qtz

VERSION := 0.1-rc
OPENSHIFT_TAG := 1.0.7
ROOT_PACKAGE := $(shell go list .)
GO_VERSION := $(shell go version)
PACKAGE_DIRS := $(shell go list -f '{{.Dir}}' ./...)
FORMATTED := $(shell go fmt ./...)

REV        := $(shell git rev-parse --short HEAD 2> /dev/null  || echo 'unknown')
BRANCH     := $(shell git rev-parse --abbrev-ref HEAD 2> /dev/null  || echo 'unknown')
BUILD_DATE := $(shell date +%Y%m%d-%H:%M:%S)
BUILDFLAGS := -ldflags \
  " -X $(ROOT_PACKAGE)/version.Version '$(VERSION)'\
		-X $(ROOT_PACKAGE)/version.Revision '$(REV)'\
		-X $(ROOT_PACKAGE)/version.Branch '$(BRANCH)'\
		-X $(ROOT_PACKAGE)/version.BuildDate '$(BUILD_DATE)'\
		-X $(ROOT_PACKAGE)/version.GoVersion '$(GO_VERSION)'"

build: *.go */*.go fmt
	CGO_ENABLED=0 godep go build $(BUILDFLAGS) -o build/$(NAME) -a $(NAME).go

install: *.go */*.go
	GOBIN=${GOPATH}/bin godep go install $(BUILDFLAGS) -a $(NAME).go

fmt:
	@([[ ! -z "$(FORMATTED)" ]] && printf "Fixed unformatted files:\n$(FORMATTED)") || true

release:
	rm -rf build release && mkdir build release

	# Build for linux and mac
	for os in linux darwin ; do \
		CGO_ENABLED=0 GOOS=$$os ARCH=amd64 \
		godep go build $(BUILDFLAGS) -o build/$(NAME)-$$os-amd64 -a $(NAME).go ; \
		tar --transform 's|^build/||' --transform 's|-.*||' \
		-czvf release/$(NAME)-$(VERSION)-$$os-amd64.tar.gz build/$(NAME)-$$os-amd64 README.md LICENSE ; \
	done

    # Build for windows
	CGO_ENABLED=0 GOOS=windows ARCH=amd64 godep go build $(BUILDFLAGS) -o build/$(NAME)-$(VERSION)-windows-amd64.exe -a $(NAME).go
	zip --junk-paths release/$(NAME)-$(VERSION)-windows-amd64.zip build/$(NAME)-$(VERSION)-windows-amd64.exe README.md LICENSE

    # Not sure what this does yet.
	go get -u github.com/progrium/gh-release
	gh-release create quantezza/$(NAME) $(VERSION) $(BRANCH) $(VERSION)

clean:
		rm -rf build release

.PHONY: release clean