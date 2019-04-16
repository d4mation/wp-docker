# wp-docker
Multi-Container Docker Application for a local WordPress site with SSL, nginx reverse proxy, MailHog and more.

## Requirements
1. [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. (Recommended) install the [localhost.crt](https://github.com/d4mation/wp-docker/raw/master/config/ssl-certs/localhost.crt) Certificate to your system so that SSL will show as valid.
    - [Mac Instructions](https://tosbourn.com/getting-os-x-to-trust-self-signed-ssl-certificates/)
    - [Windows Instructions](https://www.poweradmin.com/help/sslhints/ie.aspx) (It will work with other browsers, but installing it using IE appears to be the simplest way)
3. (Recommended) add `127.0.0.1 docker.test` to your Hosts file
    - [Mac Instructions](https://www.hostinger.com/tutorials/how-to-edit-hosts-file-macos)
    - [Windows Instructions](https://www.hostinger.com/tutorials/dns/how-to-emulate-edit-windows-hosts-file)

## Usage
1. Clone this Repository to your computer
2. Run the `start-server` script under `./scripts/` or `docker-compose up -d` to start the Containers in the background
3. Visit `docker.test/wp-admin` to install WordPress
    - You will want to visit `https://docker.test/wp-admin` if you are using SSL so that the WP Site gets configured with a https URL
4. Run the the `stop-server` script under `./scripts/` or `docker-compose down -v` to remove any unnecessary files when you're done.

You can only have one WordPress install up and running at a time using this, but the speed it offers over many other solutions I've used makes it worth it in my opinion.

## Database Management

You can access phpMyAdmin at http://docker.test:8080 and the database tables for your WordPress install will be located under the `wordpress` database. From there you can Import a site backup from another Live/Staging site or otherwise manage the Database as-needed via a GUI.

Your database also lives within a directory called `./mysql/`. _Do not delete this_. This is because when you run the `stop-server` script under `./scripts/` or `docker-compose down -v`, you're actually completely destroying the local server. When you bring it back up again using the `start-server` script under `./scripts/` or `docker-compose up -d`, it then pulls in the database from `./mysql/` so that none of that data is lost.

You can also access interconnect/it's amazing Search and Replace tool at http://docker.test:8081. If you're importing a database from a Live/Staging site, run this afterwards to Search/Replace your Live/Staging site's URL with `docker.test` in order to access your local environment properly.

## WordPress Multisite

To configure this Docker Application to be used as a WordPress Multisite, it will take a little extra configuration.

### New Local Multisites (Not based on a Live/Staging database export)

In `./docker-compose.override.yml`, you will need to update the `WORDPRESS_CONFIG_EXTRA` Environment Variable for the WordPress Service to look like the following if you're setting up a new, local Multisite (Not importing a Database from a Live/Staging site):

```yml
environment:
...
      WORDPRESS_CONFIG_EXTRA: | 
        define( 'WP_DEBUG_LOG', true );
        define( 'WP_ALLOW_MULTISITE', true );
```

Then run the `restart-server` script under `./scripts/` or `docker-compose down -v` followed by `docker-compose up -d`. From there, once logged in go to Tools -> Network Setup and follow the instructions there. 

If you choose to do a Sub-Domain setup, it will tell you that it failed to reach a randomly chosen Subdomain, but that's OK. Just add the extra `define()`s/Constants to your `./docker-compose.override.yml` file and then run the `restart-server` script under `./scripts/` or `docker-compose down -v` and `docker-compose up -d` to restart your server. Your `WORDPRESS_CONFIG_EXTRA` Environment Variable will now look like this:

```yml
environment:
...
      WORDPRESS_CONFIG_EXTRA: | 
        define( 'WP_DEBUG_LOG', true );
        define( 'WP_ALLOW_MULTISITE', true );
        define( 'MULTISITE', true );
        define( 'SUBDOMAIN_INSTALL', true );
        define( 'DOMAIN_CURRENT_SITE', 'docker.test' );
        define( 'PATH_CURRENT_SITE', '/' );
        define( 'SITE_ID_CURRENT_SITE', 1 );
        define( 'BLOG_ID_CURRENT_SITE', 1 );
```

For a Subdirectory Multisite Install the instructions are basically identical, the exact Constants above that you copy will just differ slightly. 

If you're having trouble logging in after enabling Multisite, be sure to clear your Cookies!

### Local Multisite built from a Live/Staging database

The steps here are similar to above, but you can skip the manual step of enabling the Multisite from the WordPress Dashboard.

Check the `./wp-config.php` file from your site backup and scroll down near the bottom where you begin to see mentions of `WP_ALLOW_MULTISITE` and other such Constants. If you copy those into your `./docker-compose.override.yml` file under the `WORDPRESS_CONFIG_EXTRA` Environment Variable, you'll be ready to go. Just be sure to change the value of `DOMAIN_CURRENT_SITE` to be `docker.test`.

You will however need to ensure that you Search/Replace each of the domains for subsites in your Database. It is possible your subsites had their own domain, so you'll need to replace them with something like `subsitedomain.docker.test` if using a sub-domain install.

### Accessing Sub-sites on a Sub-domain install

When using a Sub-domain install, you will need to add each of your Sub-domains to your Hosts file manually.

For example, `127.0.0.1 subsite.docker.test`

## Outbound E-Mails

Any outbound e-mails will not leave your local environment and will instead be viewable at http://docker.test:8025. This is very helpful when testing functionality that would send emails out but you only want to check whether or not it would have worked or if you want to check to see what an email would look like. 

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
