Quantezza Data Foundary CLI
===
1. Install golang 1.4.3
2. Clone the project 

		mkdir qtz-go && cd qtz-go
		git clone git@github.com:quantezza/qtz.git src/github.com/quantezza/qtz


3. Setup path.

		cd src/github.com/quantezza/qtz
    . env.sh


4. Install deps. `make init`

5. Build code

		make
		qtz



Godep
---
Ideally, we should use godep to manage dependencies like shown in the link below but it doesnot work. Some packages are broken and godep restore fails.

(Section 2.2 in https://github.com/openshift/origin/blob/master/HACKING.md)

So, for now we just add openshift/Godeps/_workspace to GOPATH.

```
go get github.com/tools/godep
export GOPATH=
go install github.com/origin/openshift
cd $GOPATH/src/github.com/origin/openshift
git checkout tag v1.0.7
```
