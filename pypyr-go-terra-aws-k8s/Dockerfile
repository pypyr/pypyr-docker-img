# note ENTRYPOINT is still pypyr, meaning you can run this container as if it's
# the pypyr binary.
# be aware that the WORKDIR is NOT the GOPATH.
# the WORKDIR is /src, which is the pypyr working dir. this will let you mount a
# volume with a pipelines dir in it without hiding the go path.
# build me like this from repo root:
# docker build -t pypyr/pypyr-go-terraform -t pypyr/pypyr-go-terraform:latest -t pypyr/pypyr-go-terraform:0.11 -t pypyr/pypyr-go-terraform:0.11.8 -f pypyr-go-terraform/Dockerfile .

FROM pypyr/pypyr-go-terra:pypyr1.0.0-go1.11.1-terra0.11.8

RUN pip install awscli --upgrade --user

RUN cp ~/.local/bin/aws /usr/local/bin

RUN go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator

RUN apt-get update && apt-get install -y apt-transport-https; \
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -; \
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list; \
        apt-get update; \
        apt-get install -y kubectl;