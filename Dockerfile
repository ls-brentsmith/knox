FROM ruby:2.5-alpine

COPY . knox/
WORKDIR knox
RUN bundle

ENTRYPOINT ["knox"]
