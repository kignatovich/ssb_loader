FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    git \
    make \
    gcc \
    wget \
    curl \
    && apt-get clean

RUN apt-get install -y apt-transport-https ca-certificates dirmngr && \
    curl -s https://packages.clickhouse.com/keys/gpg | apt-key add - && \
    echo "deb https://packages.clickhouse.com/deb/stable/ main/" | tee /etc/apt/sources.list.d/clickhouse.list && \
    apt-get update && apt-get install -y clickhouse-client

WORKDIR /opt
RUN git clone https://github.com/vadimtk/ssb-dbgen.git && \
    cd ssb-dbgen && \
    make

COPY load_data.sh /opt/load_data.sh
RUN chmod +x /opt/load_data.sh
