# FROM ruby:2.3.0
# RUN wget http://ftp-master.debian.org/ziyi_key_2006.asc
# RUN apt-key add ziyi_key_2006.asc
# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
# RUN mkdir /good_night
# WORKDIR /good_night
# COPY Gemfile /good_night/Gemfile
# COPY Gemfile.lock /good_night/Gemfile.lock
# RUN bundle install
# CMD ["rails", "server"]



FROM ruby:2.7.4

ENV INSTALL_PATH /srv/www/good_night
ENV LC_ALL C.UTF-8

RUN apt-get update -yqq \
  && apt-get install -y build-essential git curl ssh openssl xorg libssl-dev imagemagick shared-mime-info libjemalloc2 \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
  /var/lib/apt \
  /var/lib/dpkg \
  /var/lib/cache \
  /var/lib/log

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

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