FROM openjdk:15-alpine

RUN apk add --no-cache maven
RUN apk add --no-cache git
RUN apk add --no-cache asciidoctor

RUN ls -ltr
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
