#!/bin/bash

set -e

# Read environment (default to 'production' if not passed)
ENV="${1:-production}"

# Set stack name and compose file path
if [[ "$ENV" == "production" ]]; then
  STACK="production"
  COMPOSE="/srv/app/docker-compose.production.yml"
elif [[ "$ENV" == "staging" ]]; then
  STACK="staging"
  COMPOSE="/srv/app/docker-compose.staging.yml"
else
  echo "❌ Unknown environment: $ENV" > /srv/app/last_deploy.log
  exit 1
fi

# Run deploy and log output
echo "🚀 Deploying $STACK using $COMPOSE"
echo "🚀 Deploying $STACK using $COMPOSE" > /srv/app/last_deploy.log
/usr/bin/docker stack deploy --with-registry-auth -c "$COMPOSE" "$STACK" --detach=false 2>&1 | tee -a /srv/app/last_deploy.log
