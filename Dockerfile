FROM docker.io/golang:1.26.3-alpine3.23 AS builder

WORKDIR /workspack

COPY ./go.work .
ADD https://github.com/meterglost/osv-scalibr.git#feat/maven-local-bom osv-scalibr
ADD https://github.com/google/osv-scanner.git#ab572ecf4b4c3fd2795f29643ff7b1f77b9a0f58 osv-scanner

RUN go build -o ./build/osv-scanner ./osv-scanner/cmd/osv-scanner/

FROM docker.io/alpine:3.23

RUN apk --no-cache add ca-certificates git && \
    git config --global --add safe.directory '*'

WORKDIR /root/
COPY --from=builder /src/osv-scanner .

ENTRYPOINT ["/root/osv-scanner"]