FROM ruby:2.6.3-alpine3.10

#------------------------------------------------------------------------------
#
# Install Project dependencies
#
#------------------------------------------------------------------------------
RUN apk update -qq && apk add git nodejs postgresql-client ruby-dev build-base \
  libxml2-dev libxslt-dev pcre-dev libffi-dev postgresql-dev tzdata

#------------------------------------------------------------------------------
#
# Install required bundler version
#
#------------------------------------------------------------------------------
RUN gem install bundler:2.0.2

#------------------------------------------------------------------------------
#
# Install Yarn
#
#------------------------------------------------------------------------------
ENV PATH=/root/.yarn/bin:$PATH
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    yarn

#------------------------------------------------------------------------------
#
# Define working directory
#
#------------------------------------------------------------------------------
WORKDIR /usr/src/app

#------------------------------------------------------------------------------
#
# Copy the Gemfile as well as the Gemfile.lock and install the RubyGems
#
#------------------------------------------------------------------------------
COPY Gemfile /usr/src/app/Gemfile
COPY ./Gemfile ./Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5  && cp ./Gemfile.lock /tmp

#------------------------------------------------------------------------------
#
# Copy Package.json and yarn.lock
#
#------------------------------------------------------------------------------
COPY ./package.json ./yarn.lock ./

#------------------------------------------------------------------------------
#
# Install yarn packages
#
#------------------------------------------------------------------------------
RUN yarn install && yarn check --integrity


# for entrypoint script
ENV	RUN_MODE="demo"

# Database URL configuration - with user/pass
ENV	DATABASE_URL="postgresql://homestead:secret@db:5432/health-plotter_test"


RUN mkdir -p /usr/src/app/public/uploads
VOLUME /usr/src/app/public/uploads

# RUN rails db:migrate && rails db:seed

COPY . /usr/src/app