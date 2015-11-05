mkdir qtz-go
cd qtz-go
mkdir {bin,pkg,src}

cd src
git clone git@github.com/quantezza/qtz.git github.com/quantezza/qtz

go get github.com/tools/godep# qtz
