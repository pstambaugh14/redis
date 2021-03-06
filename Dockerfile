#
# Redis Dockerfile
#
# https://github.com/dockerfile/redis
#

# Pull base image.
#FROM dockerfile/ubuntu
FROM ubuntu:18.04

USER root

# Install Redis.
RUN \
  apt update && apt upgrade -y && \
  apt install -y pkg-config && \
  apt install -y wget curl libc-dev libc6 libc6-dev cpp && \
  apt install -y gcc && \
  apt install -y g++ && \
  apt install -y build-essential make cmake && \
  cd /tmp && \
  wget http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable* && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf && \
  useradd redis

USER redis
  

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["redis-server", "/etc/redis/redis.conf"]

# Expose ports.
EXPOSE 6379
