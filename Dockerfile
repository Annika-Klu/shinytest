# Use the official shiny base image
FROM rocker/shiny:latest

# Copy the app to the image
COPY . /srv/shiny-server/

# Expose port
EXPOSE 3838