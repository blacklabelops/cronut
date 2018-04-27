# Cronut - Delicious Docker Cron

The delicious cron software solution for your Docker environment.

Cronut is a cron demon for Docker environments. Finally, dynamically executing cron on containers.

## Why Cronut?

Everybody needs cron jobs! Cron jobs on containers containing your scripts!

Example:

Firstly, start Cronut:

~~~~
$ docker run -d --name cronut \
    -v /var/run/docker.sock:/var/run/docker.sock \
    blacklabelops/cronut
~~~~

Secondly, start any container with cron jobs and keep it running:

~~~~
$ docker run -d \
    -e "CRONJOB1NAME=Job1" \
    -e "CRONJOB1CRON=* * * * *" \
    -e 'CRONJOB1COMMAND=echo "Hello World!"' \
    busybox sh -c "while sleep 600; do :; done"
~~~~

> Note: Just a random container containing your application, scripts and binaries.

## Job Configuration

You can define an arbitrary amount of jobs. That's why jobs have to defined by enumerated environment variables starting from index 1, e.g. `CRONJOB1`, `CRONJOB2`, `CRONJOB3` and so on.

Job settings are defined by configuration fields and the jobs can be defined using the following fields:

* `NAME`: (Required) A unique job name, must be unique among all container's jobs.
* `CRON`: (Required) The cron schedule. Specifics and syntax can be found here [Wikipedia - Cron](https://en.wikipedia.org/wiki/Cron)
* `COMMAND`: (Required) Then command to be executed.
* `PRE_COMMAND`: (Optional) This command to be executed before the actual command.
* `POST_COMMAND`: (Optional) This command to be executed after the actual command.
* `SHELL_COMMAND`: (Optional) The shell command. Default: Set by global configuration.
* `EXECUTION`: (Optional) The execution mode for this job. Default: Set by global configuration.
* `ON_ERROR`: (Optional) The error mode for this job. Default: Set by global configuration.

Setting a job configuration field:

All fields are configured as environment variables. The environment variable are preceeded by the enumerated jobs prefix, e.g. `CRONJOB1`, `CRONJOB2`, `CRONJOB3`:

Example minimal job configuration:

~~~~
$ docker run -d \
    -e "CRONJOB1NAME=Job1" \
    -e "CRONJOB1CRON=* * * * *" \
    -e 'CRONJOB1COMMAND=echo "Hello World"' \
    your-image
~~~~

> Job will print `Hello World` every minute inside container.

Example full job configuration:

~~~~
$ docker run -d --name cronium \
    -e "CRONJOB1NAME=Job1" \
    -e "CRONJOB1CRON=* * * * *" \
    -e 'CRONJOB1PRE_COMMAND=echo "Hello World - Pre"' \
    -e 'CRONJOB1COMMAND=echo "Hello World"' \
    -e 'CRONJOB1POST_COMMAND=echo "Hello World - Post"' \
    -e "CRONJOB1SHELL_COMMAND=/bin/bash -c" \
    -e "CRONJOB1EXECUTION=sequential" \
    -e "CRONJOB1ON_ERROR=continue" \
    your-image
~~~~

> Job will print `Hello World` every minute inside container.

## Command Line Client

This image includes a command line interface (cli). The cli can be run against local or remote cronut server.

Supported Commands:

| Command | Description |
|---------|-------------|
| list | List all jobs. |
| version | Print client and server versions. |
| help | Print help. |

Configuration:

* `CRONUT_BASE_URL`: The server's base url. Default: `http://localhost:8080`.

Usage:

~~~~
$ docker exec your_cronut_container cronut list
~~~~

> Lists all jobs in cronium container with name `your_cronut_container`.

Remote Usage:

~~~~
$ docker run --rm -e "CRONUT_BASE_URL=http://your_cronut_container:8080" blacklabelops/cronut cronut list
~~~~

> Runs command against remote container with host name `your_cronut_container`.

Full Example:

1. Create Docker Network

~~~~
$ docker create network cronut
~~~~

2. Start Cronut

~~~~
$ docker run -d --name cronut \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --network cronut \
    blacklabelops/cronut
~~~~

3. Remote List Cronut Jobs

~~~~
$ docker run --rm \
    --network cronut \
    -e "CRONUT_BASE_URL=http://cronut:8080" \
    blacklabelops/cronut \
    cronut list
~~~~
