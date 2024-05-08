# Bash AI (bai)

> "Why use many code if few code do the trick?"

You want to have an AI assistant in your terminal that generates bash commands, but other solutions:

- require that you install a whole new terminal
- compile/install some executable
- install oh-my-zsh so you can install a plugin etc..

Fear no more `bai` has you covered.

> Disclaimer: You are responsibel for vetting any commands the AI generates before hitting Enter to execute them!

Prerequisites:
- bash
- curl
- jq
- OpenAi API key

The first 3 are usually pre installed on most Unix systems.

## How to

### Setup
1. Clone this repo
2. `chmod +x bai.sh`
3. `cp bai.sh to /usr/local/bin/bai`
4. `export OPENAI_API_KEY=<your key here>`

Done

If you want you can also do

`echo "export OPENAI_API_KEY=<your key here> >> ~/.bashrc"`

so that you don't have to export the key wevery time you start the terminal.

### Usage

[demo](./assets/demo.gif)

