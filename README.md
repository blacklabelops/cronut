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
* `COMMAND`: (Required) The command to be executed.
* `PRE_COMMAND`: (Optional) This command to be executed before the actual command.
* `POST_COMMAND`: (Optional) This command to be executed after the actual command.
* `SHELL_COMMAND`: Optional) The shell command. Example: `/bin/sh -c` or `/bin/bash -c`.
* `EXECUTION`: (Optional) The execution mode. Possible values `parallel` or `sequential`. A single job will be either executes strictly sequential or multiple instances of the same job can run in parallel. Default is: `sequential`.
* `ON_ERROR`: (Optional) The error mode. Possible values `stop` or `continue`. A single job will be either executed continuesly despite of errors or will not be scheduled anymore after an error occured. Default is: `continue`.

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
