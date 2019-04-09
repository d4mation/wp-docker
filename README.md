# wp-docker
Multi-Container Docker Application for a local WordPress site with SSL, nginx reverse proxy, MailCatcher and more.

## Requirements
1. [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. (Optional) install the [localhost.crt](https://github.com/d4mation/wp-docker/raw/master/config/ssl-certs/localhost.crt) Certificate to your system so that SSL will show as valid.
3. (Optional) add `127.0.0.1 docker.test` to your Hosts file

## Usage
1. Clone this Repository to your computer
2. `docker-compose up -d` to start the Containers in the background
3. Visit `docker.test/wp-admin` to install WordPress
    - You will want to visit `https://docker.test/wp-admin` if you are using SSL so that the WP Site gets configured with a https URL
4. `docker-compose down -v` to remove any unnecessary files when you're done.

You can only have one site up and running at a time using this, but the speed it offers over many other solutions I've used makes it worth it in my opinion.
