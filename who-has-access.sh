#!/bin/bash
# Example script: check_access.sh

# GitHub username and repo name
read -p "Enter your Gihub token: " GITHUB_TOKEN

read -p "Enter your Organisation name: " OWNER

read -p "Enter your Repository name: " REPO

# Use GitHub API with token
curl -s -H "Authorization: token $GITHUB_TOKEN" \
"https://api.github.com/repos/$OWNER/$REPO/collaborators" \
| jq -r 'if type=="array" then .[] | "\(.login) - \(.permissions)" else .message end'
