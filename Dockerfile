FROM alpine:3.2

# Initial setup
RUN apk update
RUN apk add --quiet --force --virtual .setup-timezone tzdata
RUN setup-timezone -z /usr/share/zoneinfo/America/New_York
RUN apk add bash

# Add compiler
RUN apk add build-base zlib-dev openssl-dev libxml2-dev libxslt-dev libffi-dev readline-dev
RUN apk add ruby ruby-dev ruby-rdoc ruby-irb

# ==============================================================================
# Rubygems and Bundler
# ==============================================================================

ADD https://github.com/rubygems/rubygems/releases/download/v2.2.3/rubygems-update-2.2.3.gem /tmp/
RUN gem install --local /tmp/rubygems-update-2.2.3.gem
RUN rm /tmp/rubygems-update-2.2.3.gem

ENV RUBYGEMS_MAJOR 2.2
ENV RUBYGEMS_VERSION 2.2.3

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler

# Define working directory
WORKDIR /app

# Set bash as a default process
CMD ["bash"]
