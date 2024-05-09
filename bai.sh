#!/bin/bash

get_gpt_response(){
    local response=$(curl --silent https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "{
        \"model\": \"gpt-4-turbo\",
        \"messages\": [
        {
            \"role\": \"system\",
            \"content\": \"$2\"
        },
        {
            \"role\": \"user\",
            \"content\": \"$1\"
        }
        ],
        \"temperature\": 0
    }")
    response_text=$(echo "$response" | jq -r '.choices[0].message.content')
    echo $response_text
}

# help menu
if [ "$1" == "--help" ]; then
    echo -e "Usage: bai [-v] [prompt...]\n\
Description: A bash script that uses the OpenAI API to generate bash commands.\n\
Options:\n\
  -v    Verbose mode, use bai as a chat app rather than to specifically generate bash commands.\n\
  --help    Display this help and exit.\n\
Example: bai.sh How to list files in a directory?\n\
NOTE: You need to set the OPENAI_API_KEY environment variable."
    exit 0
fi

# check if prerequisites are satisfied
if [ -z "$OPENAI_API_KEY" ]; then
    echo "You need to set the OPENAI_API_KEY environment variable."
    exit 1
fi

if ! command -v curl &> /dev/null  ||  ! command -v jq &> /dev/null; then
    echo "curl and jq need to be installed."
    exit 1
fi

if [ "$1" == '-v' ]; then # verbose mode
    all_args="$*"
    args="${all_args:3}"

    response_text=$(get_gpt_response "$args" "You are a helpful assistant. Be brief.")

    echo -e "\033[0;35m ${response_text//$'\n'/} \033[0m"

    exit 0
else # command mode
    args="$*"
    if [ -z "$args" ]; then
        echo "You need to provide a prompt."
        exit 1
    fi

    platform=$(uname)
    response_text=$(get_gpt_response "$args" "You are a helpful assistant that is an expert in bash scripting (on $platform). \
    Users ask you how to do things in bash, and you retrun the bash command only. Do not put the command in a code block.")


    echo -e "\033[0;35m $response_text \033[0m [ENTER] to execute, any other key to exit."

    read -r -n 1 key
    if [[ -n $key ]]; then
        echo -e "\n EXITING"
        exit 1
    fi

    eval $response_text

    echo -e "\nDONE"

    exit 0
fi