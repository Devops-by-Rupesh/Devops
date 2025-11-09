#!/bin/bash
# Script: list_users_with_read_access.sh
# Purpose: List all GitHub users with read access to a given repository

# Exit on error
set -e

# ===== CONFIGURATION =====
API_URL="https://api.github.com"

# Read GitHub username and token from environment or prompt
USERNAME="${USERNAME:-$1}"
TOKEN="${TOKEN:-$2}"
REPO_OWNER="${3}"
REPO_NAME="${4}"

if [[ -z "$USERNAME" || -z "$TOKEN" || -z "$REPO_OWNER" || -z "$REPO_NAME" ]]; then
    echo "Usage: $0 <github-username> <personal-access-token> <repo-owner> <repo-name>"
    echo "Example: $0 rupesh mytoken123 Devops-by-Rupesh Devops"
    exit 1
fi

# ===== FUNCTION =====
github_api_get() {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Use authentication and handle rate limits
    curl -s -u "${USERNAME}:${TOKEN}" -H "Accept: application/vnd.github.v3+json" "$url"
}

list_users_with_read_access() {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators?per_page=100"

    echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
    response="$(github_api_get "$endpoint")"

    # Validate that jq sees JSON, not an error message
    if echo "$response" | grep -q "Bad credentials"; then
        echo "❌ Invalid GitHub token or username. Please check your credentials."
        exit 1
    fi

    # Extract collaborator usernames with read (pull) access
    collaborators="$(echo "$response" | jq -r '.[] | select(.permissions.pull == true) | .login' 2>/dev/null || true)"

    if [[ -z "$collaborators" ]]; then
        echo "⚠️  No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "✅ Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# ===== MAIN =====
list_users_with_read_access
