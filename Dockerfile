FROM openresty/openresty:xenial

RUN apt-get update \
    && apt-get install -y \
        gcc \
        libssl-dev \
        git \
    && rm -rf /var/lib/apt/lists/*

RUN luarocks install lapis \
    && luarocks install luacrypto

WORKDIR /usr/src/app
COPY . .

CMD LAPIS_PORT=$PORT lapis server