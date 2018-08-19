FROM alpine:latest

WORKDIR .

RUN curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh
RUN mv luvi /usr/local/bin
RUN mv lit /usr/local/bin
RUN mv luvit /usr/local/bin

EXPOSE 8888

CMD ["luvit server.lua"]
