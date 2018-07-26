FROM ubuntu:14.04.1

services:
  - docker:dind

ADD . /src
RUN /src/docker.setup.sh
RUN /src/setup.sh