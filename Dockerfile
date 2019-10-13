FROM ruby:2.5.1

RUN apt update
RUN curl -sL https://deb.nodesource.com/setup_10.x
RUN apt install -y ruby-dev libpq-dev  build-essential patch \
                   zlib1g-dev liblzma-dev nodejs gcc g++ make libsodium-dev
ENV WORKDIR_PATH = /isspay_api
RUN mkdir $WORKDIR_PATH
WORKDIR $WORKDIR_PATH
COPY . .

ENV BUNDLER_VERSION=2.0.2
RUN gem install bundler:2.0.2

RUN bundler install

CMD ['bundle', 'exec', 'rails', 'console']