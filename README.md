Quantezza Data Foundary CLI
===
1. Install golang 1.4.3
2. Clone the project 

```
mkdir qtz-go && cd qtz-go
git clone git@github.com/quantezza/qtz.git src/github.com/quantezza/qtz
```

3. Setup path.
``` 
    export QTZPATH=`pwd`
    export GOPATH=`make gopath`
    export PATH=$PATH:$QTZPATH\bin
```

4. Install deps. 
`make init`

5. Build code
```
make
qtz
```


Godep:
---
Ideally, we should use godep to manage dependencies like shown in the URL but it doesnot work as some packages have changed names and godep fails miserably.
(Section 2.2 in https://github.com/openshift/origin/blob/master/HACKING.md)
So, for now we use the openshift paths.

```
go get github.com/tools/godep

export GOPATH=
go install github.com/origin/openshift
cd $GOPATH/src/github.com/origin/openshift
git checkout tag v1.0.7
```