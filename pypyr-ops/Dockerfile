# note ENTRYPOINT is still pypyr, meaning you can run this container as if it's
# the pypyr binary.
# be aware that the WORKDIR is NOT the GOPATH.
# the WORKDIR is /src, which is the pypyr working dir. this will let you mount a
# volume with a pipelines dir in it without hiding the go path.
# build me like this from repo root:
# docker build -t pypyr/pypyr-ops -t pypyr/pypyr-ops:latest -t pypyr/pypyr-ops:1.0.0 -f pypyr-ops/Dockerfile .

FROM pypyr/pypyr-go:pypyr2.0.0-go1.11.4

ARG terraformversion=0.11.11

ARG awsversion=1.16.76

ARG kubeversion=v1.13.1

ARG dockerversion=18.09.0

RUN  apt-get update && apt-get install -y apt-transport-https &&\
        wget https://releases.hashicorp.com/terraform/${terraformversion}/terraform_${terraformversion}_linux_amd64.zip && \
         apt-get update && apt-get install -y unzip &&\
         unzip terraform_${terraformversion}_linux_amd64.zip && \
         mv terraform /usr/local/bin && \
         rm -f terraform_${terraformversion}_linux_amd64.zip && \
         pip install awscli==${awsversion} && \
         go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator && \
         curl -LO https://storage.googleapis.com/kubernetes-release/release/${kubeversion}/bin/linux/amd64/kubectl && \
         chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl && \
         curl -LO  https://download.docker.com/linux/static/stable/x86_64/docker-${dockerversion}.tgz && \
         tar xzvf docker-${dockerversion}.tgz && \
         chmod +x ./docker/* && \
         mv ./docker/* /usr/local/bin/ && \
         rm -f docker-${dockerversion}.tgz && \
         rm -rf docker/
