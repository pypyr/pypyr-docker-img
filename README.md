# pypyr official docker images

![pypyr pipeline runner](https://cdn.345.systems/wp-content/uploads/2017/03/pypyr-logo-small.png)

> *pypyr*
>
> pronounce how you like, but I generally say *piper* as in "piping
    down the valleys wild"

pypyr is a command line interface to run pipelines defined in yaml.
Think of pypyr as a simple task runner that lets you run sequential
steps.

You can use the various pypyr containers instead of the pypyr executable, and
use the docker volume mount option to mount your custom pipelines directory in
the container.


## Documentation & source-code
Find pypyr help documentation, instructions and full source code here:
https://github.com/pypyr/pypyr-cli

## Images
### pypyr
Contains the pypyr executable, with all the official pypyr plug-ins. You can use
this image as a drop-in replacement for the pypyr executable.

### pypyr-go
Adds the golang runtime and development tools to the pypyr base image. This is
handy for devops activities related to go.

## Contribute
### Can I contribute?
The usual jazz - create an issue, fork, code, test, PR. It might be an idea to
discuss your idea via the Issues list first before you go off and write a
huge amount of code - you never know, something might already be in the works,
or maybe it's not quite right for the core (you're still welcome to fork
and go wild regardless, of course, it just mightn't get merged back in here).

### How to add an image
1. Create new directory. The directory name becomes the image name in _pypyr/imagename_
2. Add `imagename/Dockerfile`. Chances are you'll use pypyr/pypyr as a base.
3. Add `imagename/README.md`. Describe what it does and how to use it.
4. Add `imagename/tags` file. Plain text file containing a comma delimited list
   of tags to apply to _pypyr/imagename_
5. Add `imagename/hooks/test` file. This tests the built container - chances are
   you'll be checking version numbers are as expected.

## ops
### Deploy to docker hub
Uses docker cloud automated builds to build image in the docker registry with
links back to this repo and with the README file in the description.

Dockercloud has build rules on it looking for tags in format _imagename-tags_.
Tags is a comma delimited string of all the tags to apply to the image.

To deploy, git tag code once PRd into master with the appropriate tags.

To build a new version:
1. update `imagename/Dockerfile`
2. update `imagename/tags` file
3. update `imagename/hooks/test` file to verify whatever you just updated
3. run `ops/deploy.sh [imagename]`
