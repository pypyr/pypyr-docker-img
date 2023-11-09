# note ENTRYPOINT is still pypyr, meaning you can run this container as if it's
# the pypyr binary.
# be aware that the WORKDIR is NOT the GOPATH.
# the WORKDIR is /src, which is the pypyr working dir. this will let you mount a
# volume with a pipelines dir in it without hiding the go path.
# build me like this from repo root:
# docker build -t pypyr/pypyr-ops -t pypyr/pypyr-ops:latest -t pypyr/pypyr-ops:1.0.0 -f pypyr-ops/Dockerfile .

FROM pypyr/pypyr-go:pypyr5.9.1-go1.21.4

ARG terraformversion=1.6.3

ARG awsversion=1.29.80

ARG kubeversion=v1.28.3

ARG helmversion=v3.13.0

ARG dockerversion=24.0.7

ARG dockercompose_version=v2.23.0

ARG NODE_VERSION=21.1.0

ARG NPM_VERSION=10.2.3

ARG YARN_VERSION=1.22.19

ARG spinversion=1.30.0

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
  mkdir -p /usr/local/lib/docker/cli-plugins && \
  curl -SL https://github.com/docker/compose/releases/download/${dockercompose_version}/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose && \
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && bash ./get_helm.sh --version ${helmversion} && rm -f ./get_helm.sh && \
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
  # use pre-existing gpg directory, see https://github.com/nodejs/docker-node/pull/1895#issuecomment-1550389150
  && export GNUPGHOME="$(mktemp -d)" \
  # gpg keys listed at https://github.com/nodejs/node#release-keys
  && set -ex \
  && for key in \
  4ED778F539E3634C779C87C6D7062848A1AB005C \
  141F07595B7B3FFE74309A937405533BE57C7D57 \
  74F12602B6F1C4E913FAA37AD3A89613643B6201 \
  DD792F5973C6DE52C432CBDAC77ABFA00DDBF2B7 \
  61FC681DFB92A079F1685E77973F295594EC4689 \
  8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
  C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  890C08DB8579162FEE0DF9DB8BEAB4DFCF555EF4 \
  C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
  108F52B48DB57BB0CC439B2997B01419BD92F80A \
  A363A499291CBBC940DD62E41F10027AF002F8B0 \
  ; do \
  gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
  gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && gpgconf --kill all \
  && rm -rf "$GNUPGHOME" \
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
