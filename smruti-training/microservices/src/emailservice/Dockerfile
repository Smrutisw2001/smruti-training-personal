FROM ruby:3.1.4-slim as base

FROM base as builder

WORKDIR /tmp

# Copy Gemfile from the right path
COPY ./src/emailservice/Gemfile ./src/emailservice/Gemfile.lock ./

# Install dependencies
RUN apt-get update && apt-get install -y build-essential && bundle install

FROM base as release

WORKDIR /emailservice

# Copy source code from the correct path in the builder stage
COPY ./src/emailservice ./

# Copy bundled gems from the builder stage
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

# Expose the service port
EXPOSE ${EMAIL_SERVICE_PORT}

# Run the Ruby application
ENTRYPOINT ["bundle", "exec", "ruby", "email_server.rb"]
