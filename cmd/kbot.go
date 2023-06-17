package cmd

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

var (
	TeleToken = os.Getenv("TELE_TOKEN")
)

var kbotCmd = &cobra.Command{
	Use:     "ottomenbot",
	Aliases: []string{"start"},
	Short:   "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains
examples and usage of using your command.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("kbot %s started", appVersion)

		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		if err != nil {
			log.Fatalf("Please, check TeleToken variable, %s", err)
			return
		}

		kbot.Handle(telebot.OnText, func(c telebot.Context) error {
			fmt.Println(c.Message().Payload, c.Text())

			payload := c.Message().Payload

			switch payload {
			case "hello":
				err = c.Send(fmt.Sprintf("Hello, I'm Ottomen bot %s", appVersion))
			}

			return err
		})

		kbot.Start()
	},
}

func init() {
	rootCmd.AddCommand(kbotCmd)
}
