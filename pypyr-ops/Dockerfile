# note ENTRYPOINT is still pypyr, meaning you can run this container as if it's
# the pypyr binary.
# be aware that the WORKDIR is NOT the GOPATH.
# the WORKDIR is /src, which is the pypyr working dir. this will let you mount a
# volume with a pipelines dir in it without hiding the go path.
# build me like this from repo root:
# docker build -t pypyr/pypyr-ops -t pypyr/pypyr-ops:latest -t pypyr/pypyr-ops:1.0.0 -f pypyr-ops/Dockerfile .

FROM pypyr/pypyr-go:pypyr4.4.0-go1.15.6

ARG terraformversion=0.14.3

ARG awsversion=1.18.203

ARG kubeversion=v1.20.1

ARG helmversion=v3.4.2

ARG dockerversion=20.10.0

ARG dockercompose_version=1.27.4

ARG NODE_VERSION=14.15.3

ARG NPM_VERSION=6.14.10

ARG YARN_VERSION=1.22.10

ARG spinversion=1.20.0

RUN  apt-get update && apt-get install -y apt-transport-https &&\
  wget https://releases.hashicorp.com/terraform/${terraformversion}/terraform_${terraformversion}_linux_amd64.zip && \
  apt-get update && apt-get install -y unzip &&\
  unzip terraform_${terraformversion}_linux_amd64.zip && \
  mv terraform /usr/local/bin && \
  rm -f terraform_${terraformversion}_linux_amd64.zip && \
  pip install awscli==${awsversion} && \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/${kubeversion}/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl && \
  curl -LO  https://download.docker.com/linux/static/stable/x86_64/docker-${dockerversion}.tgz && \
  tar xzvf docker-${dockerversion}.tgz && \
  chmod +x ./docker/* && \
  mv ./docker/* /usr/local/bin/ && \
  rm -f docker-${dockerversion}.tgz && \
  rm -rf docker/ && \
  pip install docker-compose==${dockercompose_version} && \
  curl -o get-helm https://raw.githubusercontent.com/helm/helm/master/scripts/get && bash ./get-helm --version ${helmversion} && rm -f ./get-helm && \
  curl -LO https://storage.googleapis.com/spinnaker-artifacts/spin/${spinversion}/linux/amd64/spin && \
  chmod +x spin && \
  mv spin /usr/local/bin/spin && \
  #nodejs
  ARCH= && dpkgArch="$(dpkg --print-architecture)" \
  && case "${dpkgArch##*-}" in \
  amd64) ARCH='x64';; \
  ppc64el) ARCH='ppc64le';; \
  s390x) ARCH='s390x';; \
  arm64) ARCH='arm64';; \
  armhf) ARCH='armv7l';; \
  i386) ARCH='x86';; \
  *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  # gpg keys listed at https://github.com/nodejs/node#release-keys
  && set -ex \
  && for key in \
  4ED778F539E3634C779C87C6D7062848A1AB005C \
  94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
  1C050899334244A8AF75E53792EF661D867B9DFA \
  71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
  8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
  C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
  DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
  108F52B48DB57BB0CC439B2997B01419BD92F80A \
  B9E2F5981AA6E0CD28160D9FF13993A75599653C \
  ; do \
  gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
  gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
  gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  # smoke tests
  && node --version \
  && npm --version \
  # npm and yarn
  && npm install -g npm@${NPM_VERSION} \
  && npm install -g yarn@${YARN_VERSION}
