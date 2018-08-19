FROM ubuntu:18.04

WORKDIR .

RUN apt-get update
RUN apt-get install curl
RUN curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh
RUN mv luvi /usr/local/bin
RUN mv lit /usr/local/bin
RUN mv luvit /usr/local/bin

EXPOSE 8888

CMD ["luvit server.lua"]
