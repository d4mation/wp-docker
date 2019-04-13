# wp-docker
Multi-Container Docker Application for a local WordPress site with SSL, nginx reverse proxy, MailHog and more.

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

## Database Management

You can access phpMyAdmin at http://docker.test:8080 and the database tables for your WordPress install will be located under the `wordpress` database. From there you can Import a site backup from another Live/Staging site or otherwise manage the Database as-needed via a GUI.

Your database also lives within a directory called `./mysql`. _Do not delete this_. This is because when you run `docker-compose down -v`, you're actually completely destroying the local server. When you bring it back up again using `docker-compose up -d`, it then pulls in the database from `./mysql` so that none of that data is lost.

You can also access interconnect/it's amazing Search and Replace tool at http://docker.test:8081. If you're importing a database from a Live/Staging site, run this afterwards to Search/Replace your Live/Staging site's URL with `docker.test` in order to access your local environment properly.

## PHP Debugging

You can configure your favorite IDE to connect to xDebug when using this Docker Application. The primary things you will need to do are configure your Path Mappings and the Port Number.

The Path Mapping may look different based on your IDE of choice, but the Port will always be 9001 with the configuration files included in this Docker Application. 

Here's an example configuration for [Visual Studio Code](https://code.visualstudio.com/) (Requires [this extension](https://marketplace.visualstudio.com/items?itemName=felixfbecker.php-debug)). Visual Studio Code uses a `${workspaceRoot}` variable that may not apply in other IDEs, so check the documentation for your specific IDE.

```json
"configurations": [
        {
            "name": "Listen for XDebug",
            "type": "php",
            "request": "launch",
            "port": 9001,
            "pathMappings": {
                "/var/www/html/wp-content": "${workspaceRoot}/wp-content"
            }
        },
...
```

The above configuration will tell your IDE that any requests coming from xDebug should have the file path search/replaced with a local file path to your computer. It will then handle any breakpoints that you've set within any files.

If you need to set a specific IDEKEY for your IDE to communicate with xDebug, you can set this by adding `xdebug.idekey = <YOUR_ID_KEY>` to `./config/php-fpm/xdebug.ini`
