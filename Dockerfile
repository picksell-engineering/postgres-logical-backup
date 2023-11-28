FROM google/cloud-sdk:slim

WORKDIR /app

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install --no-install-recommends -y \
    jq \
    curl \
    pigz \
    gnupg \
    apt-utils \
    lsb-release \
    ca-certificates \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && cat /etc/apt/sources.list.d/pgdg.list \
    && curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && apt-get install --no-install-recommends -y postgresql-client-15  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY dump.sh /app/dump.sh

ENV PG_DIR=/usr/lib/postgresql

ENTRYPOINT ["bash", "/app/dump.sh"]
