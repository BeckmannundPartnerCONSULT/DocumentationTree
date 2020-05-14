FROM openjdk:8-jdk

RUN apt update -f
RUN apt install maven -f

RUN apt-get update && apt-get install -y --no-install-recommends openjfx && rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["sh", "/entrypoint.sh"]
