# note ENTRYPOINT is still pypyr, meaning you can run this container as if it's
# the pypyr binary.
# be aware that the WORKDIR is NOT the GOPATH.
# the WORKDIR is /src, which is the pypyr working dir. this will let you mount a
# volume with a pipelines dir in it without hiding the go path.
# build me like this from repo root:
# docker build -t pypyr/pypyr-go -t pypyr/pypyr-go:latest -t pypyr/pypyr-go:1.10 -t pypyr/pypyr-go:1.10.3 -f pypyr-go/Dockerfile .
FROM pypyr/pypyr:2.8.0

ARG goversion=1.12.2
# username for limited user from base image
ARG limiteduser=pypyruser

# apt-get will need root. currently still pypyruser, as inherited from base image.
USER root
# Credits: All of the core go install cheerfully nicked from the superb official
# golang docker lib:
# https://github.com/docker-library/golang/

# gcc for cgo
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
		&& rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION=${goversion}

RUN set -eux; \
	\
# this "case" statement is generated via "update.sh"
	dpkgArch="$(dpkg --print-architecture)"; \
	case "${dpkgArch##*-}" in \
		amd64) goRelArch='linux-amd64'; goRelSha256='f28c1fde8f293cc5c83ae8de76373cf76ae9306909564f54e0edcf140ce8fe3f' ;; \
		armhf) goRelArch='linux-armv6l'; goRelSha256='38d92116cd8c408e995972ff7fb0b6453c4f2214bde602d1772bd88f9d4d5c60' ;; \
		arm64) goRelArch='linux-arm64'; goRelSha256='598558fe54bbdce8b676f81e37f514dd70b8fc1377086658ae6e836480e900eb' ;; \
		i386) goRelArch='linux-386'; goRelSha256='3005a7937ff2be7ea9badd416cc37dfe2ff589d3a311f1685de0a805e45455b6' ;; \
		ppc64el) goRelArch='linux-ppc64le'; goRelSha256='62be1d5f38e322edc21de0debd3051247faff59890c343a7f2173c15098dbd35' ;; \
		s390x) goRelArch='linux-s390x'; goRelSha256='a41b0b11f5e34c3cccd7619bddf79a6d4b94bcbd2160fefcdf25f0afe87cad0a' ;; \
		*) goRelArch='src'; goRelSha256='af992580a4a609309c734d46fd4374fe3095961263e609d9b017e2dffc3b7b58'; \
			echo >&2; echo >&2 "warning: current architecture ($dpkgArch) does not have a corresponding Go binary release; will be building from source"; echo >&2 ;; \
	esac; \
	\
	url="https://golang.org/dl/go${GOLANG_VERSION}.${goRelArch}.tar.gz"; \
	wget -O go.tgz "$url"; \
	echo "${goRelSha256} *go.tgz" | sha256sum -c -; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	\
	if [ "$goRelArch" = 'src' ]; then \
		echo >&2; \
		echo >&2 'error: UNIMPLEMENTED'; \
		echo >&2 'TODO install golang-any from jessie-backports for GOROOT_BOOTSTRAP (and uninstall after build)'; \
		echo >&2; \
		exit 1; \
	fi; \
	\
	export PATH="/usr/local/go/bin:$PATH"; \
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH" \
		&& chown -R ${limiteduser}:${limiteduser} $GOPATH

# don't need root anymore. downstream should only run as less permissive.
# pypyruser created in base container. it's got a home dir for go get caching.
# in theory, you'd switch to less permissive here. this causes a whole bunch
# of problems with vol bind mounting though, when you're interacting w host file
# system. Until elegant solution found, this is a dev env only container, don't
# run in prod.
# USER ${limiteduser}
