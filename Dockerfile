FROM golang:alpine as build

WORKDIR /build

RUN true \
	&& apk --no-cache add \
		git \
		curl

RUN true \
	&& go get -u github.com/OWASP/Amass/...

RUN true \
	&& curl https://raw.githubusercontent.com/OWASP/Amass/master/wordlists/namelist.txt > namelist.txt \
	&& curl https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/bitquark-subdomains-top100K.txt > bitquark-subdomains-top100K.txt

# ---

FROM opendevsecops/launcher:latest as launcher

# ---

FROM alpine:latest

WORKDIR /run

COPY --from=build /go/bin/amass /bin/amass
COPY --from=build /build/namelist.txt /run/namelist.txt
COPY --from=build /build/bitquark-subdomains-top100K.txt /run/bitquark-subdomains-top100K.txt

COPY --from=launcher /bin/launcher /bin/launcher

WORKDIR /session

ENTRYPOINT ["/bin/launcher", "/bin/amass"]
