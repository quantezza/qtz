package main

import (
	"github.com/spf13/cobra"
	occmd "github.com/openshift/origin/pkg/cmd/cli/cmd"
	"os"
	"github.com/openshift/origin/pkg/cmd/util/clientcmd"
)

func runHelp(cmd *cobra.Command, args []string) {
	cmd.Help()
}

func main() {
	cmds := &cobra.Command{
		Use:   "qtz",
		Short: "gofabric8 is used to validate & deploy fabric8 components on to your Kubernetes or OpenShift environment",
		Long: `gofabric8 is used to validate & deploy fabric8 components on to your Kubernetes or OpenShift environment
								Find more information at http://fabric8.io.`,
		Run: runHelp,
	}



	in, out := os.Stdin, os.Stdout

	f := clientcmd.New(cmds.PersistentFlags())

	loginCmd := occmd.NewCmdLogin("qtz", f, in, out)

	cmds.AddCommand(loginCmd)

	cmds.Execute()
}