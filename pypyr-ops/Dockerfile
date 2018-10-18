# note ENTRYPOINT is still pypyr, meaning you can run this container as if it's
# the pypyr binary.
# be aware that the WORKDIR is NOT the GOPATH.
# the WORKDIR is /src, which is the pypyr working dir. this will let you mount a
# volume with a pipelines dir in it without hiding the go path.
# build me like this from repo root:
# docker build -t pypyr/pypyr-ops -t pypyr/pypyr-ops:latest -t pypyr/pypyr-ops:1.0.0 -f pypyr-ops/Dockerfile .

FROM pypyr/pypyr-go:pypyr1.1.1-go1.11.1

ARG terraformversion=0.11.8

ARG awsversion=1.16.37

RUN  apt-get update && apt-get install -y apt-transport-https; \
        wget https://releases.hashicorp.com/terraform/${terraformversion}/terraform_${terraformversion}_linux_amd64.zip; \
         curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -; \
         echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list; \
         apt-get update && apt-get install -y unzip \
         kubectl; \
         unzip terraform_${terraformversion}_linux_amd64.zip; \
         mv terraform /usr/local/bin; \
         rm -f terraform_${terraformversion}_linux_amd64.zip; \
         pip install awscli==${awsversion}; \
         go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator
