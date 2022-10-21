FROM golang:1.18-alpine3.14@sha256:70ba8ec1a0e26a828c802c76ecfc65d1efe15f3cc04d579747fd6b0b23e1cea5  AS build-env

RUN echo $GOPATH

RUN apk add --no-cache git gcc musl-dev
RUN apk add --update make
RUN go install github.com/google/wire/cmd/wire@latest
WORKDIR /go/src/github.com/devtron-labs/devtron
ADD . /go/src/github.com/devtron-labs/devtron/
RUN GOOS=linux make build-all

# uncomment this post build arg
FROM alpine:3.15.0@sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300 as  devtron-all
RUN apk add --no-cache ca-certificates
RUN apk update
RUN apk add git
COPY --from=build-env  /go/src/github.com/devtron-labs/devtron/devtron .
COPY --from=build-env  /go/src/github.com/devtron-labs/devtron/auth_model.conf .
COPY --from=build-env  /go/src/github.com/devtron-labs/devtron/vendor/github.com/argoproj/argo-cd/assets/ /go/src/github.com/devtron-labs/devtron/vendor/github.com/argoproj/argo-cd/assets
COPY --from=build-env  /go/src/github.com/devtron-labs/devtron/scripts/devtron-reference-helm-charts scripts/devtron-reference-helm-charts
COPY --from=build-env  /go/src/github.com/devtron-labs/devtron/scripts/argo-assets/APPLICATION_TEMPLATE.JSON scripts/argo-assets/APPLICATION_TEMPLATE.JSON

COPY ./git-ask-pass.sh /git-ask-pass.sh
RUN chmod +x /git-ask-pass.sh

CMD ["./devtron"]


#FROM alpine:3.15.0 as  devtron-ea

#RUN apk add --no-cache ca-certificates
#COPY --from=build-env  /go/src/github.com/devtron-labs/devtron/auth_model.conf .
#COPY --from=build-env  /go/src/github.com/devtron-labs/devtron/cmd/external-app/devtron-ea .

#COPY --from=build-env  /go/src/github.com/devtron-labs/devtron/vendor/github.com/argoproj/argo-cd/assets/ /go/src/github.com/devtron-labs/devtron/vendor/github.com/argoproj/argo-cd/assets
#COPY --from=build-env  /go/src/github.com/devtron-labs/devtron/scripts/devtron-reference-helm-charts scripts/devtron-reference-helm-charts
#COPY --from=build-env  /go/src/github.com/devtron-labs/devtron/scripts/argo-assets/APPLICATION_TEMPLATE.JSON scripts/argo-assets/APPLICATION_TEMPLATE.JSON

#CMD ["./devtron-ea"]
