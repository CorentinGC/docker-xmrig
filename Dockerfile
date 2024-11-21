FROM debian:bookworm

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]

WORKDIR /xmrig

RUN  apt-get update \
  && apt-get install -y wget jq \
  && rm -rf /var/lib/apt/lists/*

# Get latest release
RUN wget -O xmrig.tar.gz $(wget -q -O -  "https://api.github.com/repos/xmrig/xmrig/releases/latest" | jq -r '.assets[] | select (.name|test("linux-static-x64")) | .browser_download_url')   

# Extract binary
RUN tar xvf xmrig.tar.gz --strip-components=1 
RUN rm xmrig.tar.gz
# RUN chmod +x xmrig

# CMD ["ls"]
CMD ["/xmrig/xmrig --config ./config.json" ]
