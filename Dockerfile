# The container includes:
#
# * MRI Ruby 2.2.2
# * Bundler
# * Image Magick
#

FROM ctwise/phusion

# Add compiler
RUN apt-get update
RUN apt-get upgrade -yq
RUN apt-get -yq install build-essential
RUN apt-get -yq install zlib1g-dev libssl-dev libxml2-dev libxslt1-dev libffi-dev libyaml-dev libreadline6-dev

ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.2

# Set $PATH so that non-login shells will see the Ruby binaries
ENV PATH $PATH:/opt/rubies/ruby-$RUBY_VERSION/bin

# Install MRI Ruby $RUBY_VERSION
RUN curl -O http://ftp.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz
RUN tar -zxvf ruby-$RUBY_VERSION.tar.gz
RUN cd ruby-$RUBY_VERSION && ./configure --disable-install-doc && make && make install
RUN rm -r ruby-$RUBY_VERSION ruby-$RUBY_VERSION.tar.gz
RUN echo 'gem: --no-document' > /usr/local/etc/gemrc

# ==============================================================================
# Rubygems and Bundler
# ==============================================================================

ENV RUBYGEMS_MAJOR 2.3
ENV RUBYGEMS_VERSION 2.3.0

# Install rubygems and bundler
ADD http://production.cf.rubygems.org/rubygems/rubygems-$RUBYGEMS_VERSION.tgz /tmp/
RUN cd /tmp && tar -zxf /tmp/rubygems-$RUBYGEMS_VERSION.tgz
RUN cd /tmp/rubygems-$RUBYGEMS_VERSION && ruby setup.rb && /bin/bash -l -c 'gem install bundler --no-rdoc --no-ri'
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

# Define working directory
WORKDIR /app

# Set bash as a default process
CMD ["bash"]
