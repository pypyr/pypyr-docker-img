# note ENTRYPOINT is still pypyr, meaning you can run this container as if it's
# the pypyr binary.
# be aware that the WORKDIR is NOT the GOPATH.
# the WORKDIR is /src, which is the pypyr working dir. this will let you mount a
# volume with a pipelines dir in it without hiding the go path.
# build me like this from repo root:
# docker build -t pypyr/pypyr-go-terraform -t pypyr/pypyr-go-terraform:latest -t pypyr/pypyr-go-terraform:0.11 -t pypyr/pypyr-go-terraform:0.11.8 -f pypyr-go-terraform/Dockerfile .

FROM pypyr/pypyr-go:pypyr2.10.0-go1.11.2

ARG terraformversion=0.11.10

RUN wget https://releases.hashicorp.com/terraform/0.11.8/terraform_${terraformversion}_linux_amd64.zip; \
         apt-get update && apt-get install -y unzip; \
         unzip terraform_${terraformversion}_linux_amd64.zip; \
         mv terraform /usr/local/bin; \
         rm -f terraform_${terraformversion}_linux_amd64.zip
