FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    git \
    make \
    gcc \
    wget \
    curl \
    gnupg \
    apt-transport-https \
    && apt-get clean

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 8919F6BD2B48D754 && \
    echo "deb https://packages.clickhouse.com/deb stable main" | tee /etc/apt/sources.list.d/clickhouse.list && \
    apt-get update && apt-get install -y clickhouse-client && apt-get clean

WORKDIR /opt
RUN git clone https://github.com/vadimtk/ssb-dbgen.git && \
    cd ssb-dbgen && \
    make

COPY load_data.sh /opt/load_data.sh
RUN chmod +x /opt/load_data.sh
