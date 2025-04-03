#!/bin/bash

# Update script for household census application with component selection
# Usage: ./script.sh [frontend|backend|deployment|all]

COMPONENT=${1:-all}
cd ~/household-census-workspace

if [[ $COMPONENT == "frontend" || $COMPONENT == "all" ]]; then
  echo "Updating frontend..."
  cd household-census-frontend
  git pull
  cd ..
fi

if [[ $COMPONENT == "backend" || $COMPONENT == "all" ]]; then
  echo "Updating backend..."
  cd household-census-backend
  git pull
  cd ..
fi

if [[ $COMPONENT == "deployment" || $COMPONENT == "all" ]]; then
  echo "Updating deployment configuration..."
  cd household-census-deployment
  git pull
  cd ..
fi

echo "Rebuilding and restarting containers..."
# Make sure we're in the right directory with docker-compose.yml
cd ~/household-census-workspace/household-census-deployment

if [[ $COMPONENT == "all" ]]; then
  # Stop all containers
  docker-compose down

  # Rebuild all images with --no-cache to ensure fresh builds
  docker-compose build --no-cache

  # Start all containers
  docker-compose up -d
else
  # Only rebuild the specified service
  docker-compose stop $COMPONENT
  docker-compose build --no-cache $COMPONENT
  docker-compose up -d $COMPONENT
fi

echo "Deployment of $COMPONENT complete!"