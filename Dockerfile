FROM ubuntu:14.04.1

ADD . /src
RUN /src/setup.sh