FROM ubuntu:jammy

ENV DEBIAN_FRONTEND noninteractive
ENV CRAN_URL https://cloud.r-project.org/
ENV USER=sccity
ENV GROUPNAME=$USER

USER root

RUN set -e \
    && ln -sf bash /bin/sh
      
RUN set -eo pipefail \
    && groupadd $GROUPNAME \
    && useradd -m -d /home/$USER -g $GROUPNAME $USER \
    && echo $USER:$USER | chpasswd
      
WORKDIR /app
COPY entrypoint.sh /app
COPY rdeps.R /app
RUN chown -R "$USER":"$GROUPNAME" /app && chmod -R 775 /app && chmod +x /app/entrypoint.sh

RUN set -e \
    && apt-get -y update \
    && apt-get -y dist-upgrade \
    && apt-get -y install --no-install-recommends --no-install-suggests \
                  apt-transport-https \
                  apt-utils \
                  ca-certificates \
                  curl \
                  gdebi-core \
                  gnupg2 \
                  libfontconfig1-dev \
                  libapparmor1 \
                  libclang-dev \
                  libedit2 \
                  libpq5 \
                  libssl3 \
                  libssl-dev \
                  lsb-release \
                  expect \
                  build-essential \
                  libffi-dev \
                  git-all \
                  libopenblas-dev \
                  zip \
                  protobuf-compiler \
                  libcurl4-openssl-dev \
                  psmisc \
                  sudo \
                  libbz2-dev \
                  liblzma-dev \
                  nano \
                  libxml2-dev \
                  libsodium-dev \
                  libprotobuf-dev \
                  libudunits2-dev \
                  libjq-dev \
                  gfortran \
                  libgdal-dev \
                  cron \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
RUN echo "deb [arch=amd64 trusted=yes] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" > /etc/apt/sources.list.d/r.list
    
RUN set -e \
    && apt-get -y update \
    && apt-get -y install r-base r-base-core r-recommended \
    && apt-get -y install r-cran-rgdal gdal-bin
    
RUN set -eo pipefail \
    && /usr/bin/Rscript /app/rdeps.R
    
RUN set -e \
    && apt-get -y update \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
RUN touch /etc/cron.d/rjobs
RUN chmod 0644 /etc/cron.d/rjobs
RUN touch /var/log/cron.log

ENTRYPOINT ["/app/entrypoint.sh"]