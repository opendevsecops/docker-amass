FROM circleci/golang:latest

WORKDIR /

RUN true \
    && go get -u github.com/caffix/amass

ENTRYPOINT ["amass"]
