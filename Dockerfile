FROM golang:buster

RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    git \
    libjpeg62-turbo-dev \
    libswscale-dev \
 \
 && mkdir -p "${GOPATH}/src/github.com/pixiv" \
 && cd ${GOPATH}/src/github.com/pixiv \
 && git clone https://github.com/pixiv/go-thumber.git \
 && go install github.com/pixiv/go-thumber/thumberd

FROM debian:buster-slim

ENV GODEBUG=cgocheck=0

RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    libjpeg62-turbo \
    libswscale5 \
 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 \
 && mkdir -p "/go/bin"

COPY --from=0 /go/bin/thumberd /go/bin

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH

EXPOSE 8080

CMD ["thumberd", "-local", "0.0.0.0:8080"]
