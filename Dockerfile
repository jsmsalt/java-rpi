FROM alpine:3.9

MAINTAINER José Morales <jsmsalt@gmail.com>

# Set environment.
ENV PATH=$PATH:${PATH}:/opt/jdk/bin \
	JAVA_HOME=/opt/jdk \
    JAVA_VERSION=8 \
    JAVA_UPDATE=201 \
    JAVA_BUILD=09 \
    JAVA_PATH=42970487e3af4f5aa5bca3f542482c60 \
    GITHUB=https://github.com/leannenorthrop/alpine-pkg-glibc/releases/download/glibc-2.22-r1-armhf-beta

# Full installation.
RUN echo "********** [INSTALLING DEPENDENCIES] **********" && \
	apk --update --no-cache add xz tar curl ca-certificates && \
	\
	\
	echo "********** [INSTALLING GLIB] **********" && \
	cd /tmp && \
    curl -s -OJL ${GITHUB}/glibc-2.22-r1.apk && \
    curl -s -OJL ${GITHUB}/glibc-bin-2.22-r1.apk && \
    curl -s -OJL ${GITHUB}/libgcc_s.so && \
    curl -s -OJL ${GITHUB}/libgcc_s.so.1 && \
    apk add --allow-untrusted glibc-2.22-r1.apk && \
    apk add --allow-untrusted glibc-bin-2.22-r1.apk && \
    mv libgcc* /lib && \
    chmod a+x /lib/libgcc_s.so* && \
    cp /usr/glibc-compat/lib/ld-linux-armhf.so.3 /lib && \
    \
    \
    echo "********** [INSTALLING JAVA] **********" && \
    cd /tmp && \
    curl -s -OJL --cookie "oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_PATH}/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-arm32-vfp-hflt.tar.gz" && \
    tar -xzf jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-arm32-vfp-hflt.tar.gz && \
    mv jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE} /opt/jdk && \
    ln -s /opt/jdk/jre/bin/java /usr/bin/java && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
    /opt/jdk/lib /opt/jdk/jre/lib \
    /opt/jdk/jre/lib/arm /opt/jdk/jre/lib/arm/jli && \
    echo "hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4" >> /etc/nsswitch.conf && \
    \
    \
    echo "********** [CLEAN UP] **********" && \
    apk del xz tar curl ca-certificates bash && \
	cd /tmp && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/* && \
    rm -f glibc-*.apk jdk*.tar.gz $JAVA_HOME/src.zip && \
	rm -rf $JAVA_HOME/*src.zip \
		$JAVA_HOME/lib/missioncontrol \
		$JAVA_HOME/lib/visualvm \
		$JAVA_HOME/lib/*javafx* \
		$JAVA_HOME/jre/bin/jjs \
		$JAVA_HOME/jre/bin/keytool \
		$JAVA_HOME/jre/plugin \
		$JAVA_HOME/jre/bin/javaws \
		$JAVA_HOME/jre/bin/orbd \
		$JAVA_HOME/jre/bin/pack200 \
		$JAVA_HOME/jre/bin/policytool \
		$JAVA_HOME/jre/bin/rmid \
		$JAVA_HOME/jre/bin/rmiregistry \
		$JAVA_HOME/jre/bin/servertool \
		$JAVA_HOME/jre/bin/tnameserv \
		$JAVA_HOME/jre/bin/unpack200 \
		$JAVA_HOME/jre/lib/javaws.jar \
		$JAVA_HOME/jre/lib/deploy* \
		$JAVA_HOME/jre/lib/desktop \
		$JAVA_HOME/jre/lib/*javafx* \
		$JAVA_HOME/jre/lib/*jfx* \
		$JAVA_HOME/jre/lib/arm/libdecora_sse.so \
		$JAVA_HOME/jre/lib/arm/libprism_*.so \
		$JAVA_HOME/jre/lib/arm/libfxplugins.so \
		$JAVA_HOME/jre/lib/arm/libglass.so \
		$JAVA_HOME/jre/lib/arm/libgstreamer-lite.so \
		$JAVA_HOME/jre/lib/arm/libjavafx*.so \
		$JAVA_HOME/jre/lib/arm/libjfx*.so \
		$JAVA_HOME/jre/lib/ext/jfxrt.jar \
		$JAVA_HOME/jre/lib/oblique-fonts \
		$JAVA_HOME/jre/lib/plugin.jar

# Define default command.
CMD ["/bin/sh"]
