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
