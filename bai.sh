#!/bin/bash
args="$*"

if [ -z "$args" ]; then
    echo "You need to provide a prompt."
    exit 1
fi

if [ -z "$OPENAI_API_KEY" ]; then
    echo "You need to set the OPENAI_API_KEY environment variable."
    exit 1
fi

if ! command -v curl &> /dev/null  ||  ! command -v jq &> /dev/null; then
    echo "curl and jq need to be installed."
    exit 1
fi



response=$(curl --silent https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "{
    \"model\": \"gpt-4-turbo\",
    \"messages\": [
      {
        \"role\": \"system\",
        \"content\": \"You are a helpful assistant that is an expert in bash scripting. Users ask you how to do things in bash, and you retrun the bash command only. Do not put the command in a code block.\"
      },
      {
        \"role\": \"user\",
        \"content\": \"$args\"
      }
    ],
    \"temperature\": 0
  }")


response_text=$(echo "$response" | jq -r '.choices[0].message.content')

echo -e "\033[0;35m $response_text \033[0m [ENTER] to execute, any other key to exit."

read -r -n 1 key
if [[ -n $key ]]; then
    echo -e "\n EXITING"
    exit 1
fi

eval $response_text

echo -e "\nDONE"

