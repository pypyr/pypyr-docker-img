# build me like this from repo root:
# docker build -t pypyr/pypyr -t pypyr/pypyr:latest -t pypyr/pypyr:0.8 -t pypyr/pypyr:0.8.0 -f pypyr/Dockerfile .
# 3-stretch implies release versions >=3.6.5
FROM python:3-stretch
# version of pypyr to install. This version must exist on pypi.
ARG pypyrversion=2.9.0
# awsversion: version of pypyraws to install. This version must exist on pypi.
ARG awsversion=1.1.0
# slackversion: version of pypyrslack to install. This version must exist on pypi.
ARG slackversion=1.0.0
# name of limited user+group as whom the container will execute
ARG limiteduser=pypyruser

# install pypyr and pypyr plugins
RUN pip install --upgrade pip \
    && pip install -q --no-cache-dir pypyr==${pypyrversion} pypyraws==${awsversion} pypyrslack==${slackversion} \
    && pypyr --version && pypyr magritte \
    # create pypyr user and group. no-log-init due to docker recommendation on uid bug.
    && groupadd -r ${limiteduser} \
    && useradd --create-home --no-log-init -g ${limiteduser} ${limiteduser} \
    # permission the working dir
    && mkdir /src \
    && chown ${limiteduser}: /src

WORKDIR /src

USER ${limiteduser}

ENTRYPOINT ["pypyr"]
