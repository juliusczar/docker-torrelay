FROM clearlinux:latest

# Tor version
ARG TOR_VERSION=0.3.5.4-alpha

# Set compiler perfomance options
ENV CFLAGS "-g -march=ivybridge -O3 -feliminate-unused-debug-types -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=32 -Wformat -Wformat-security -Wl,--copy-dt-needed-entries -m64 -fasynchronous-unwind-tables -Wp,-D_REENTRANT -ftree-loop-distribute-patterns -Wl,-z -Wl,now -Wl,-z -Wl,relro -fno-semantic-interposition -ffat-lto-objects -fno-signed-zeros -fno-trapping-math -fassociative-math -Wl,-sort-common"
ENV CXXFLAGS "-g -march=ivybridge -O3 -feliminate-unused-debug-types -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=32 -Wformat -Wformat-security -Wl,--copy-dt-needed-entries -m64 -fasynchronous-unwind-tables -Wp,-D_REENTRANT -ftree-loop-distribute-patterns -Wl,-z -Wl,now -Wl,-z -Wl,relro -fno-semantic-interposition -ffat-lto-objects -fno-signed-zeros -fno-trapping-math -fassociative-math -Wl,-sort-common -fvisibility-inlines-hidden"

RUN swupd update \
 && swupd bundle-add dev-utils-dev os-core-update-dev \
 && rm -rf /var/lib/swupd/staged \
 && curl -k https://dist.torproject.org/tor-$TOR_VERSION.tar.gz -o /tmp/tor-$TOR_VERSION.tar.gz \
 && tar zxf /tmp/tor-$TOR_VERSION.tar.gz -C /tmp \
 && useradd -r tor \
 && mkdir -m 0700 /var/lib/tor \
 && chown tor:tor /var/lib/tor \
 && cd /tmp/tor-$TOR_VERSION \
 && ./configure --disable-asciidoc --with-tor-user=tor --with-tor-group=tor \
 && make -j$(nproc) install \
 && swupd bundle-remove os-core-update-dev \
 && rm -rf /tmp/*

# Execute Tor as user tor
CMD ["/bin/su", "-c", "/usr/local/bin/tor", "tor"]
