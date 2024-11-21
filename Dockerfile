FROM ubuntu:22.04 as build-runner
ARG XMRIG_VERSION=6.22.0
LABEL maintainer "CorentinGC"

RUN set -xe; \
  apt update; \
  apt install -y wget jq build-essential cmake automake libtool autoconf; \
  apt install -y gcc-9 g++-9; \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 100; \
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 100; \
  rm -rf /var/lib/apt/lists/*; \
  VERSION=$(wget -q -O - "https://api.github.com/repos/xmrig/xmrig/releases/latest" | jq -r '.tag_name'  | cut -c 2-); \
  echo $VERSION; \
  wget -O xmrig.tar.gz https://github.com/xmrig/xmrig/archive/refs/tags/v$VERSION.tar.gz; \
  tar xf xmrig.tar.gz; \
  mv xmrig-$VERSION /xmrig; \
  cd /xmrig; \
  mkdir build; \
  sed -i 's/kDefaultDonateLevel = 1;/kDefaultDonateLevel = 0;/; s/kMinimumDonateLevel = 1;/kMinimumDonateLevel = 0;/;' src/donate.h; \
  cd scripts; \
  ./build_deps.sh; \
  cd ../build; \
  cmake .. -DXMRIG_DEPS=scripts/deps; \
  make -j $(nproc);

RUN set -xe; \
  cd /xmrig; \
  cp build/xmrig /xmrig

FROM ubuntu:22.04 as runner
LABEL maintainer "CorentinGC"

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]

WORKDIR /xmrig

RUN  apt update \
  && apt install -y wget jq \
  && rm -rf /var/lib/apt/lists/*

# # Get latest release
# RUN wget -O xmrig.tar.gz $(wget -q -O -  "https://api.github.com/repos/xmrig/xmrig/releases/latest" | jq -r '.assets[] | select (.name|test("linux-static-x64")) | .browser_download_url')   

# # Extract binary
# RUN tar xvf xmrig.tar.gz --strip-components=1 
# RUN rm xmrig.tar.gz

COPY --from=build-runner /xmrig/xmrig /xmrig/xmrig

# CMD ["ls"]
CMD ["/xmrig/xmrig --config ./config.json" ]
