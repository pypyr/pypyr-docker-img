# pypyr official docker images: pypyr-ops

![pypyr pipeline runner](https://pypyr.io/images/pypyr-logo-small.png)

> *pypyr*
>
> pronounce how you like, but I generally say *piper* as in "piping
    down the valleys wild"

pypyr is a command line interface to run pipelines defined in yaml.
Think of pypyr as a simple task runner that lets you run sequential
steps.

The pypyr-ops docker image contains the pypyr cli and the official plug-ins.
You can use the pypyr docker image to run pypyr pipelines without having
to install pypyr and/or python yourself.

The pypyr docker image is handy for devops activities such as CI and CD: it's a
readymade execution environment for running pipelines.

This pypyr-ops image is handy for devops activities related to go, terraform,
awscli, kubernetes and docker, such as compiling and builder pattern
orchestration.

You can use the pypyr container instead of the pypyr executable, and use the
docker volume mount option to mount your custom pipelines directory in
the container.


## Installed Packages
* [go](https://golang.org/)
* [awscli](https://aws.amazon.com/cli/)
* [docker](https://www.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)
* [helm](https://github.com/helm/)
* [kubectl](https://kubernetes.io/)
* [nodejs](https://nodejs.org/en/)
* [npm](https://www.npmjs.com/)
* [spin cli](https://www.spinnaker.io/guides/spin/cli/)
* [terraform](https://terraform.io)
* [yarn](https://yarnpkg.com/en/)

## Installation

```bash
$ docker pull pypyr/pypyr-ops
```

## Usage
### Run your first pipeline

Run one of the built-in pipelines to get a feel for it:

```bash
$ docker run pypyr/pypyr-ops echo "Ceci n'est pas une pipe"
```

You can achieve the same thing by running a pipeline where the context
is set in the pipeline yaml rather than as a context argument:

```bash
$ docker run pypyr/pypyr-ops magritte
```

### Documentation & source-code
Find pypyr help documentation, instructions and full source code here:
https://github.com/pypyr/pypyr-cli

The Dockerfile is here:
https://github.com/pypyr/pypyr-docker-img/tree/master/pypyr-ops

### Run a pipeline

pypyr assumes a `pipelines` directory in your current
working directory. The working dir on the container is
`/src`

```bash
# chances are pretty good you want to do something like this:
# this mounts the current dir (with your go source code), and sets the working dir to the mount dir
# you then run pipelinenamehere in this working dir as if you're in your repo home.
$ docker run -v ${PWD}:/go/src/github.com/myrepo/myproj -w /go/src/github.com//myrepo/myproj pypyr/pypyr-ops pipelinenamehere`

# mount your host's current dir to the container's working dir.
# Your host has ./pipelines/mypipelinename.yaml
$ docker run -v ${PWD}:/src pypyr/pypyr-ops mypipelinename

# run container's /src/pipelines/mypipelinename.yaml with DEBUG logging level.
$ docker run pypyr/pypyr-ops --logl 10

# run container /src/cpipelines/mypipelinename.yaml with INFO logging level.
$ docker run pypyr/pypyr-ops --logl 20

# If you don't specify --logl it defaults to 20 - INFO logging level.
$ docker run pypyr/pypyr-ops mypipelinename

# run pipelines/mypipelinename.yaml with an input context. For this input to
# be available to your pipeline you need to specify a context_parser in your
# pipeline yaml.
$ docker run pypyr/pypyr-ops mypipelinename "mykey=value"
```

### Get cli help

pypyr has a couple of arguments and switches you might find useful. See
them all here:

```bash
$ docker run pypyr/pypyr-ops -h
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
$ docker run -v ${PWD}:/src pypyr/pypyr-ops simple

# and this is how you pass further parameters like context
# this command looks for ./pipelines/substitutions.yaml, which is on your host.
$ docker run -v ${PWD}:/src pypyr/pypyr-ops substitutions "key1=this is key1 in context,key2=pipe"

# one more time, with extra logging. . .
$ docker run -v ${PWD}:/src pypyr/pypyr-ops substitutions "key1=this is key1 in context,key2=pipe" --logl 10
```

### Use terraform in a pipeline
You can use terraform in a pipeline like this:
```
steps:
 - name: pypyr.steps.safeshell
   in:
    cmd: terraform --version
```


### Use aws in a pipeline
You can interact with aws using the [pypyr-aws plug-in](https://github.com/pypyr/pypyr-aws).
This allows you to use any aws api functionality directly in a pipeline without
having to go via the cli.

For aws functions that are only in the cli and not in the api, you can still use
the aws cli in a pipeline like this:
```
steps:
 - name: pypyr.steps.safeshell
   in:
    cmd: aws --version
```

### Use kubectl in a pipeline
You can use kubectl in a pipeline like this:
```
steps:
 - name: pypyr.steps.safeshell
   in:
    cmd: kubectl version
```

### Use docker in a pipeline
You can use docker in a pipeline like this:
```
steps:
 - name: pypyr.steps.safeshell
   in:
    cmd: docker version
```


### Use pypyr/pypyr-ops as a parent image
The pypyr image has working dir `/src` and entrypoint `pypyr`. Assuming you
don't over-ride these directives in your child image, you can keep on using
your derived image like this:

```bash
# this command looks for ./pipelines/mypipelinename.yaml, which is on your host.
$ docker run -v ${PWD}:/src myrepo/my-pypyr-child mypipelinename
```

## Version History
See [history.md](https://github.com/pypyr/pypyr-docker-img/blob/master/pypyr-ops/history.md) for details.

## License
pypyr is cheerfully open source under the Apache License. License information
[here](https://github.com/pypyr/pypyr-docker-img/blob/master/LICENSE)
