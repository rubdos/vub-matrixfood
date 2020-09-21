FROM ruby:2 
LABEL maintainer "Christophe De Troyer <christophe@call-cc.be>"

# Copy source.
ADD . /app

# Install requirements
WORKDIR /app
RUN gem install bundler ; bundle install

ENTRYPOINT ["bundle", "exec", "ruby", "slackfood-evening.rb"]
