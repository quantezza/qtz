package main

import (
	occmd "github.com/openshift/origin/pkg/cmd/cli/cmd"
	occlientcmd "github.com/openshift/origin/pkg/cmd/util/clientcmd"
	"github.com/spf13/cobra"
	"k8s.io/kubernetes/pkg/client/unversioned/clientcmd"
	"os"

	"github.com/openshift/origin/pkg/cmd/cli/config"
)

func main() {
	cmds := &cobra.Command{
		Use:   "qtz",
		Short: "Quantezza CLI.",
		Long:  `Quantezza Data Foundary superpowers.`,
		//		Run: runHelp,
	}

	in, out := os.Stdin, os.Stdout

	loadingRules := config.NewOpenShiftClientConfigLoadingRules()
	cmds.PersistentFlags().StringVar(&loadingRules.ExplicitPath, config.OpenShiftConfigFlagName, "", "Path to the config file to use for CLI requests.")
	overrides := &clientcmd.ConfigOverrides{}
	//	overrideFlags := clientcmd.RecommendedConfigOverrideFlags("")
	//	//	overrideFlags.ContextOverrideFlags.Namespace.ShortName = "n"
	//	overrideFlags.ClusterOverrideFlags.APIVersion.LongName = ""
	//	overrideFlags.ClusterOverrideFlags.CertificateAuthority.LongName = ""
	//	overrideFlags.ClusterOverrideFlags.CertificateAuthority.LongName = ""
	//	overrideFlags.ContextOverrideFlags.ClusterName.LongName = ""
	//	overrideFlags.ContextOverrideFlags.Namespace.LongName = ""
	//
	//	overrideFlags.AuthOverrideFlags.ClientCertificate.LongName = ""
	//
	//	clientcmd.BindOverrideFlags(overrides, cmds.PersistentFlags(), overrideFlags)

	clientConfig := clientcmd.NewNonInteractiveDeferredLoadingClientConfig(loadingRules, overrides)
	f := occlientcmd.NewFactory(clientConfig)

	fullName := "qtz"

	loginCmd := occmd.NewCmdLogin(fullName, f, in, out)
	cmds.AddCommand(loginCmd)

	whoamiCmd := occmd.NewCmdWhoAmI(occmd.WhoAmIRecommendedCommandName, fullName+" "+occmd.WhoAmIRecommendedCommandName, f, out)
	cmds.AddCommand(whoamiCmd)

	cmds.AddCommand(occmd.NewCmdProject(fullName+" project", f, out))
	cmds.Execute()
}
