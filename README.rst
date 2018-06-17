############################
pypyr official docker images
############################

.. image:: https://cdn.345.systems/wp-content/uploads/2017/03/pypyr-logo-small.png
    :alt: pypyr-logo
    :align: left

*pypyr*
    pronounce how you like, but I generally say *piper* as in "piping down the
    valleys wild"


pypyr is a command line interface to run pipelines defined in yaml. Think of
pypyr as a simple task runner that lets you run sequential steps.

The pypyr docker image contains the pypyr cli and the official plug-ins. You
can use the pypyr docker image to run pypyr pipelines without having to install
pypyr yourself.

You can just use the pypyr container as the pipeline runner, and use the docker
volume mount option to mount your custom pipelines directory in the container.


.. contents::

.. section-numbering::

************
Installation
************
.. code-block:: bash

  $ docker pull pypyr/pypyr

*****
Usage
*****
Run your first pipeline
=======================
Run one of the built-in pipelines to get a feel for it:

.. code-block:: bash

  $ docker run pypyr/pypyr echo --context "echoMe=Ceci n'est pas une pipe"

You can achieve the same thing by running a pipeline where the context is set
in the pipeline yaml rather than as a --context argument:

.. code-block:: bash

  $ docker run pypyr/pypyr magritte

Check here `pypyr.steps.echo`_ to see yaml that does this.

Run a pipeline
==============
pypyr assumes a :code:`pipelines` directory in your current working directory. The
working dir on the container is :code:`/src`

.. code-block:: bash

  # mount your host's current dir to the container's working dir.
  # Your host has ./pipelines/mypipelinename.yaml
  $ docker run -v ${PWD}:/src pypyr/pypyr mypipelinename

  # run container's /src/pipelines/mypipelinename.yaml with DEBUG logging level.
  $ docker run pypyr/pypyr mypipelinename --log 10

  # run container /src/cpipelines/mypipelinename.yaml with INFO logging level.
  $ docker run pypyr/pypyr mypipelinename --log 20

  # If you don't specify --log it defaults to 20 - INFO logging level.
  $ docker run pypyr/pypyr mypipelinename

  # run pipelines/mypipelinename.yaml with an input context. For this input to
  # be available to your pipeline you need to specify a context_parser in your
  # pipeline yaml.
  $ docker run pypyr/pypyr mypipelinename --context 'mykey=value'

Get cli help
============
pypyr has a couple of arguments and switches you might find useful. See them all
here:

.. code-block:: bash

  $ docker run pypyr/pypyr -h

Examples
========
If you prefer reading code to reading words, https://github.com/pypyr/pypyr-example
