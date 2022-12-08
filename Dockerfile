FROM ruby:2.7.4

ENV INSTALL_PATH /srv/www/good_night
ENV LC_ALL C.UTF-8

RUN apt-get update -yqq \
  && apt-get install -y build-essential git curl ssh openssl xorg libssl-dev imagemagick shared-mime-info libjemalloc2 \
  && apt-get clean autoclean \
  && apt-get autoremove -y

WORKDIR $INSTALL_PATH
COPY . $INSTALL_PATH

RUN gem update --system 3.2.3
RUN gem install bundler
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]