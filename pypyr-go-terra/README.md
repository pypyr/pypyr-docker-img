# pypyr official docker images: pypyr-go-terra

![pypyr pipeline runner](https://cdn.345.systems/wp-content/uploads/2017/03/pypyr-logo-small.png)

> *pypyr*
>
> pronounce how you like, but I generally say *piper* as in "piping
    down the valleys wild"

pypyr is a command line interface to run pipelines defined in yaml.
Think of pypyr as a simple task runner that lets you run sequential
steps.

The pypyr docker image contains the pypyr cli and the official plug-ins.
You can use the pypyr docker image to run pypyr pipelines without having
to install pypyr and/or python yourself.

The pypyr docker image is handy for devops activities such as CI and CD: it's a
readymade execution environment for running pipelines.

This pypyr-go-terra image adds the golang runtime, development tools and
terraform executable to the pypyr base image. This is handy for devops activities
related to go and terraform, such as compiling and builder pattern orchestration.

You can use the pypyr container instead of the pypyr executable, and use the
docker volume mount option to mount your custom pipelines directory in
the container.


## Installation

```bash
$ docker pull pypyr/pypyr-go-terra
```

## Usage
### Run your first pipeline

Run one of the built-in pipelines to get a feel for it:

```bash
$ docker run pypyr/pypyr-go-terra echo "Ceci n'est pas une pipe"
```

You can achieve the same thing by running a pipeline where the context
is set in the pipeline yaml rather than as a context argument:

```bash
$ docker run pypyr/pypyr-go-terra magritte
```

### Documentation & source-code
Find pypyr help documentation, instructions and full source code here:
https://github.com/pypyr/pypyr-cli

The Dockerfile is here:
https://github.com/pypyr/pypyr-docker-img

### Run a pipeline

pypyr assumes a `pipelines` directory in your current
working directory. The working dir on the container is
`/src`

```bash
# chances are pretty good you want to do something like this:
# this mounts the current dir (with your go source code), and sets the working dir to the mount dir
# you then run pipelinenamehere in this working dir as if you're in your repo home.
$ docker run -v ${PWD}:/go/src/github.com/myrepo/myproj -w /go/src/github.com//myrepo/myproj pypyr/pypyr-go-terra pipelinenamehere`

# mount your host's current dir to the container's working dir.
# Your host has ./pipelines/mypipelinename.yaml
$ docker run -v ${PWD}:/src pypyr/pypyr-go-terra mypipelinename

# run container's /src/pipelines/mypipelinename.yaml with DEBUG logging level.
$ docker run pypyr/pypyr-go-terra mypipelinename --log 10

# run container /src/cpipelines/mypipelinename.yaml with INFO logging level.
$ docker run pypyr/pypyr-go-terra mypipelinename --log 20

# If you don't specify --log it defaults to 20 - INFO logging level.
$ docker run pypyr/pypyr-go-terra mypipelinename

# run pipelines/mypipelinename.yaml with an input context. For this input to
# be available to your pipeline you need to specify a context_parser in your
# pipeline yaml.
$ docker run pypyr/pypyr-go-terra mypipelinename "mykey=value"
```

### Get cli help

pypyr has a couple of arguments and switches you might find useful. See
them all here:

```bash
$ docker run pypyr/pypyr-go-terra -h
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
$ docker run -v ${PWD}:/src pypyr/pypyr-go-terra simple

# and this is how you pass further parameters like context
# this command looks for ./pipelines/substitutions.yaml, which is on your host.
$ docker run -v ${PWD}:/src pypyr/pypyr-go-terra substitutions "key1=this is key1 in context,key2=pipe"

# one more time, with extra logging. . .
$ docker run -v ${PWD}:/src pypyr/pypyr-go-terra substitutions "key1=this is key1 in context,key2=pipe" --log 10
```

### Use terraform in a pipeline
You can use terraform in a pipeline like this:
```
steps:
 name: pypyr.steps.safeshell
  in:
    cmd: terraform --version
```


### Use pypyr/pypyr-go-terra as a parent image
The pypyr image has working dir `/src` and entrypoint `pypyr`. Assuming you
don't over-ride these directives in your child image, you can keep on using
your derived image like this:

```bash
# this command looks for ./pipelines/mypipelinename.yaml, which is on your host.
$ docker run -v ${PWD}:/src myrepo/my-pypyr-child mypipelinename
```

## License
pypyr is cheerfully open source under the Apache License. License information
[here](https://github.com/pypyr/pypyr-docker-img/blob/master/LICENSE)
