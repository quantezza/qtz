export QTZPATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../../.." && pwd )

export GOPATH="${QTZPATH}:${QTZPATH}/src/github.com/openshift/origin/Godeps/_workspace"
export PATH=$PATH:$QTZPATH/bin