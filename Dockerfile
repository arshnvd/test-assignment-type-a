FROM ruby:2.6.3-alpine

MAINTAINER Arash Naveed <arsh.nvd@gmail.com>

# add required packages
RUN apk --update add --virtual build-dependencies \
                                build-base \
                                libxml2-dev \
                                libxslt-dev \
                                postgresql-dev \
                                nodejs \
                                tzdata \
                                && rm -rf /var/cache/apk/*

RUN gem install bundler
RUN bundle config build.nokogiri --use--system-libraries
RUN npm install yarn -g

# Configure main directory
RUN mkdir -p /app
WORKDIR /app

# Install app dependencies
COPY Gemfile Gemfile.lock package.json yarn.lock ./

RUN bundle install --jobs 20 --retry 5 --without development test
RUN yarn install --check-files

# Add project files
COPY . ./

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]