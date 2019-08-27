# s2i-clojure
FROM openshift/base-centos7
MAINTAINER Timo Friman <tfriman@redhat.com>

ENV BUILDER_VERSION 1.0

LABEL io.k8s.description="Platform for building Clojure apps with GraalVM" \
      io.k8s.display-name="Clojure s2i 1.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,clojure"

RUN yum -y install java-1.8.0-openjdk-devel && yum clean all

RUN curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o ${HOME}/lein
RUN chmod 775 ${HOME}/lein
RUN ${HOME}/lein

COPY ./s2i/bin/ /usr/libexec/s2i

RUN chown -R 1001:1001 /opt/app-root

ENV GRAALVM_VERSION 19.2.0
ENV GRAALVM_HOME="/opt/graalvm"
RUN curl https://github.com/oracle/graal/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-linux-amd64-${GRAALVM_VERSION}.tar.gz -o graalvm.tar.gz
RUN tar -xzvf graalvm.tar.gz -C /opt && mv /opt/graalvm-ce-${GRAALVM_VERSION} /opt/graalvm
RUN ${GRAALVM_HOME}/bin/gu --auto-yes install native-image

# https://github.com/quarkusio/quarkus-images/blob/master/modules/graalvm/19.2.0/configure

# This default user is created in the openshift/base-centos7 image
USER 1001

EXPOSE 8080

CMD ["/usr/libexec/s2i/usage"]
