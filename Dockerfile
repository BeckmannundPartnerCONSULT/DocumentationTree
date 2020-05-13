FROM openjdk:8-slim

RUN apk add --no-cache maven
RUN apk add --no-cache git
RUN apk add --no-cache asciidoctor

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["sh", "/entrypoint.sh"]
