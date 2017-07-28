FROM ubuntu:xenial
LABEL vendor="HelloFresh"
MAINTAINER "Kieran Patel <me@kieranajp.co.uk>"

WORKDIR /tmp

# Add some basic essential packages
RUN apt-get -qq -y update && \
    apt-get -qq -y install \
        build-essential \
        git \
        locales \
        python-software-properties \
        software-properties-common

# Add the PHP PPA to compile against
RUN locale-gen en_US.UTF-8 && export LANG=en_US.UTF-8 && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get -qq -y update && \
    apt-get -qq -y install \
        php5.6-dev

# Compile librdkafka library
RUN git clone https://github.com/edenhill/librdkafka && cd librdkafka && \
    ./configure && make && make install

# Compile phpkafka library
RUN git clone https://github.com/EVODelavega/phpkafka && cd phpkafka && \
    phpize && \
    make && \
    make install && \
    echo "extension=kafka.so" >> /etc/php5/conf.d/kafka.ini

