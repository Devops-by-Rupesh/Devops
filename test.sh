#!/bin/bash
# Example script: check_access.sh

# GitHub username and repo name
OWNER="your-username"
REPO="your-repo"

# Use GitHub API with token
curl -s -H "Authorization: token $GITHUB_TOKEN" \
"https://api.github.com/repos/$OWNER/$REPO/collaborators" \
| jq -r 'if type=="array" then .[] | "\(.login) - \(.permissions)" else .message end'
