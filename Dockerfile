ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN bundle install
CMD ["puma", "-C", "/config/puma.rb"]