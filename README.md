mkdir qtz-go
cd qtz-go
mkdir {bin,pkg,src}

cd src
git clone git@github.com/quantezza/qtz.git github.com/quantezza/qtz

go get github.com/tools/godep

export GOPATH=
go install github.com/origin/openshift
cd $GOPATH/src/github.com/origin/openshift
git checkout tag v1.0.7
