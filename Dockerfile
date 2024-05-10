# Use the official shiny base image
FROM rocker/shiny:latest

# Copy the app to the image
COPY . /srv/shiny-server/

# Workdir
WORKDIR /srv/shiny-server/

# Install system dependencies for httr2
RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev libssl-dev

# Install packages
RUN R -e "install.packages(c('shinyjs', 'httr2'), repos='http://cran.rstudio.com/')"

# Expose port
EXPOSE 3838