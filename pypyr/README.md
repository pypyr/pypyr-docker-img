# pypyr official docker images: pypyr

![pypyr pipeline runner](https://pypyr.io/images/2x1/pypyr-taskrunner-yaml-pipeline-automation-1200x600.1bd2401e4f8071d85bcb1301128e4717f0f54a278e91c9c350051191de9d22c0.png)

> *pypyr*
>
> pronounce how you like, but I generally say *piper* as in "piping
    down the valleys wild"

pypyr is a cli & api to run pipelines defined in yaml.
Think of pypyr as a simple task runner that lets you run sequential
steps.

The pypyr docker image contains the pypyr cli and the official plug-ins.
You can use the pypyr docker image to run pypyr pipelines without having
to install pypyr and/or python yourself.

The pypyr docker image is handy for devops activities such as CI and CD: it's a
readymade execution environment for running pipelines.

You can use the pypyr container instead of the pypyr executable, and use the
docker volume mount option to mount your custom pipelines directory in
the container.


## Installation

```bash
$ docker pull pypyr/pypyr
```

## Usage
### Run your first pipeline

Run one of the built-in pipelines to get a feel for it:

```bash
$ docker run pypyr/pypyr echo Ceci n'est pas une pipe
```

You can achieve the same thing by running a pipeline where the context
is set in the pipeline yaml rather than as a context argument:

```bash
$ docker run pypyr/pypyr magritte
```

### Documentation & source-code
Find pypyr help documentation, instructions and full source code here:
https://github.com/pypyr/pypyr

The Dockerfile is here:
https://github.com/pypyr/pypyr-docker-img

### Run a pipeline

The working dir on the container is `/src`

```bash
# mount your host's current dir to the container's working dir.
# Your host has ./mypipelinename.yaml
$ docker run -v ${PWD}:/src pypyr/pypyr mypipelinename

# run container's /src/mypipelinename.yaml with DEBUG logging level.
$ docker run pypyr/pypyr mypipelinename --logl 10

# run container /src/mypipelinename.yaml with INFO logging level.
$ docker run pypyr/pypyr mypipelinename --logl 20

# If you don't specify --logl it defaults to 20 - INFO logging level.
$ docker run pypyr/pypyr mypipelinename

# run host ./mypipelinename.yaml with an input context. For this input to
# be available to your pipeline you need to specify a context_parser in your
# pipeline yaml.
$ docker run pypyr/pypyr mypipelinename mykey=value
```

### Get cli help

pypyr has a couple of arguments and switches you might find useful. See
them all here:

```bash
$ docker run pypyr/pypyr -h
```

## Examples
### Run the pypyr examples
If you prefer reading code to reading words, https://github.com/pypyr/pypyr-example

To run the examples, do this:

```bash
# clone the pypyr-example repo
$ git clone git@github.com:pypyr/pypyr-example.git

# cd to the your new local repo
$ cd pypyr-example

# You now have a local ./pipelines dir
$ ls ./pipelines

# run some pipelines on your host inside the pypyr docker container,
# using a volume mount to get at the ./pipelines dir on the host
$ docker run -v ${PWD}:/src pypyr/pypyr simple

# and this is how you pass further parameters like context
# this command looks for ./pipelines/substitutions.yaml, which is on your host.
$ docker run -v ${PWD}:/src pypyr/pypyr substitutions key1="this is key1 in context" key2=pipe

# one more time, with extra logging. . .
$ docker run -v ${PWD}:/src pypyr/pypyr substitutions key1="this is key1 in context" key2=pipe --logl 10
```

### Use pypyr/pypyr as a parent image
See `./pypyr-go` for an example of a Dockerfile that uses pypyr/pypyr as a parent
image.

The pypyr image has working dir `/src` and entrypoint `pypyr`. Assuming you
don't over-ride these directives in your child image, you can keep on using
your derived image like this:

```bash
# this command looks for ./mypipelinename.yaml, which is on your host.
$ docker run myrepo/my-pypyr-child -v ${PWD}:/src pypyr/pypyr mypipelinename
```

## License
pypyr is cheerfully open source under the Apache License. License information
[here](https://github.com/pypyr/pypyr-docker-img/blob/main/LICENSE)
