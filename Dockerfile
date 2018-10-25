FROM circleci/golang:latest

WORKDIR /

RUN true \
    && go get -u github.com/OWASP/Amass/...

ENTRYPOINT ["amass"]
