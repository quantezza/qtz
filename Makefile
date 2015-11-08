SHELL := /bin/bash
NAME := qtz

VERSION := 0.1-rc
OPENSHIFT_TAG := v1.0.7
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

GOPATH="${QTZPATH}:${QTZPATH}/src/github.com/openshift/origin/Godeps/_workspace"

all install: ${QTZPATH}/src/github.com/quantezza/qtz/*.go ${QTZPATH}/src/github.com/openshift/origin/*/*.go
	GOPATH=$(GOPATH) GOBIN=${QTZPATH}/bin go install $(BUILDFLAGS) -a $(NAME).go

init:
	rm -rf ${QTZPATH}/src/github.com/openshift/origin
	git clone https://github.com/openshift/origin ${QTZPATH}/src/github.com/openshift/origin && \
	cd ${QTZPATH}/src/github.com/openshift/origin && \
	git checkout -b $(OPENSHIFT_TAG) $(OPENSHIFT_TAG) && \
	cd -

build: ${QTZPATH}/src/github.com/quantezza/qtz/*.go ${QTZPATH}/src/github.com/openshift/origin/*/*.go fmt
	GOPATH=$(GOPATH) CGO_ENABLED=0 go build $(BUILDFLAGS) -o ${QTZPATH}/build/$(NAME) -a $(NAME).go

fmt:
	@([[ ! -z "$(FORMATTED)" ]] && printf "Fixed unformatted files:\n$(FORMATTED)") || true

# release:
# 	rm -rf build release && mkdir build release
#
# 	# Build for linux and mac
# 	for os in linux darwin ; do \
# 		GOPATH=$(GOPATH) CGO_ENABLED=0 GOOS=$$os ARCH=amd64 \
# 	  go build $(BUILDFLAGS) -o build/$(NAME)-$$os-amd64 -a $(NAME).go ; \
# 		tar --transform 's|^build/||' --transform 's|-.*||' \
# 		-czvf release/$(NAME)-$(VERSION)-$$os-amd64.tar.gz build/$(NAME)-$$os-amd64 README.md LICENSE ; \
# 	done
#
#     # Build for windows
# 	GOPATH=$(GOPATH) CGO_ENABLED=0 GOOS=windows ARCH=amd64 \
# 	go build $(BUILDFLAGS) -o build/$(NAME)-$(VERSION)-windows-amd64.exe -a $(NAME).go
#
# 	zip --junk-paths release/$(NAME)-$(VERSION)-windows-amd64.zip build/$(NAME)-$(VERSION)-windows-amd64.exe README.md LICENSE
#
#   # Not sure what this does yet.
# 	go get -u github.com/progrium/gh-release
# 	gh-release create quantezza/$(NAME) $(VERSION) $(BRANCH) $(VERSION)

clean:
		rm -rf ${QTZPATH}/build ${QTZPATH}/release

.PHONY: release clean
