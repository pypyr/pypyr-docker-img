# note ENTRYPOINT is still pypyr, meaning you can run this container as if it's
# the pypyr binary.
# be aware that the WORKDIR is NOT the GOPATH.
# the WORKDIR is /src, which is the pypyr working dir. this will let you mount a
# volume with a pipelines dir in it without hiding the go path.
# build me like this from repo root:
# docker build -t pypyr/pypyr-go -t pypyr/pypyr-go:latest -t pypyr/pypyr-go:1.10 -t pypyr/pypyr-go:1.10.3 -f pypyr-go/Dockerfile .
FROM pypyr/pypyr:0.8.2

ARG goversion=1.10.3
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
		amd64) goRelArch='linux-amd64'; goRelSha256='fa1b0e45d3b647c252f51f5e1204aba049cde4af177ef9f2181f43004f901035' ;; \
		armhf) goRelArch='linux-armv6l'; goRelSha256='d3df3fa3d153e81041af24f31a82f86a21cb7b92c1b5552fb621bad0320f06b6' ;; \
		arm64) goRelArch='linux-arm64'; goRelSha256='355128a05b456c9e68792143801ad18e0431510a53857f640f7b30ba92624ed2' ;; \
		i386) goRelArch='linux-386'; goRelSha256='3d5fe1932c904a01acb13dae07a5835bffafef38bef9e5a05450c52948ebdeb4' ;; \
		ppc64el) goRelArch='linux-ppc64le'; goRelSha256='f3640b2f0990a9617c937775f669ee18f10a82e424e5f87a8ce794a6407b8347' ;; \
		s390x) goRelArch='linux-s390x'; goRelSha256='34385f64651f82fbc11dc43bdc410c2abda237bdef87f3a430d35a508ec3ce0d' ;; \
		*) goRelArch='src'; goRelSha256='567b1cc66c9704d1c019c50bef946272e911ec6baf244310f87f4e678be155f2'; \
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

# Download and install the latest release of dep and vgo
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh \
		&& go get -u golang.org/x/vgo
