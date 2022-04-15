FROM haskell:8

WORKDIR /bin
RUN curl -L https://github.com/sol/hpack/releases/download/0.34.2/hpack_linux.gz > hpack.gz
RUN bash -c "gunzip *.gz"
RUN chmod +x hpack

ADD . /app
WORKDIR /app
