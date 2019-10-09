FROM debian:buster-slim

EXPOSE 7657 4444 4445 6668


RUN apt-get update && \
	apt-get install --no-install-recommends -y ca-certificates apt-transport-https curl gnupg procps && \
	echo "deb https://deb.i2p2.de/ buster main" >> /etc/apt/sources.list.d/i2p.list && \
	echo "deb-src https://deb.i2p2.de/ buster main" >> /etc/apt/sources.list.d/i2p.list && \
	cd /tmp && \
	mkdir -p /usr/share/man/man1 && \
	curl -o i2p-debian-repo.key.asc https://geti2p.net/_static/i2p-debian-repo.key.asc && \
	apt-key add i2p-debian-repo.key.asc && \
	apt-get update && \
	apt-get install -y i2p=0.9.42* i2p-keyring && \
	mkdir /i2p && \
	groupadd -g 999 i2p && \
    useradd -r -u 999 -g i2p i2p --home /i2p && \
	chown -R i2p:i2p /i2p && \
	apt-get purge -y gnupg && \
	apt-get autoremove -y && \
	rm -rf /*.zip /tmp/* /var/tmp/* /var/lib/apt/lists/* 	

RUN sed -i 's/127\.0\.0\.1/0.0.0.0/g' /usr/share/i2p/i2ptunnel.config && \
    sed -i 's/::1,127\.0\.0\.1/0.0.0.0/g' /usr/share/i2p/clients.config && \
    echo "i2cp.tcp.bindAllInterfaces=true\n" >> /usr/share/i2p/router.config && \
    echo "i2np.ipv4.firewalled=true\ni2np.ntcp.ipv6=false\n" >> /usr/share/i2p/router.config && \
    echo "i2np.udp.ipv6=false\ni2np.upnp.enable=false\n" >> /usr/share/i2p/router.config
	
VOLUME /i2p

USER i2p

ENTRYPOINT ["/usr/bin/i2prouter", "console"]