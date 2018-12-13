FROM  centos:centos7
LABEL version="0.5.0" \
      didi_dir="https://raw.githubusercontent.com/identinetics/docker-openldap/master/didi" \
      capabilities='--cap-drop=all --cap-add=setgid --cap-add=setuid'

ENV UID 343006
ENV GID 0
RUN useradd --gid $GID --uid $UID ldap \
 && chown $UID:$GID /run

RUN yum -y update \
 && yum -y install epel-release \
 && yum -y install curl iproute lsof net-tools \
 && yum -y install python34-devel \
 && curl https://bootstrap.pypa.io/get-pip.py | python3.4 \
 && pip install ldap3 \
 && yum -y install openldap openldap-servers openldap-clients \
 && yum clean all

# save system default ldap config and extend it with project-specific files
RUN mkdir -p /opt/sample_data/etc/openldap/data/
COPY install/conf/*.conf /etc/openldap/
COPY install/conf/schema/* /etc/openldap/schema/
COPY install/data/* /opt/sample_data/etc/openldap/data/
COPY install/conf/DB_CONFIG /var/db/
COPY install/scripts/*.sh /
COPY install/tests/* /tests/
RUN chmod +x /*.sh /tests/*

ARG SLAPDPORT=8389
ENV SLAPDPORT $SLAPDPORT

# using the shared grop method from https://docs.openshift.com/container-platform/3.3/creating_images/guidelines.html (Support Arbitrary User IDs)
RUN mkdir -p /var/log/openldap \
 && chown -R ldap:root /etc/openldap /var/db /var/log/openldap /opt/sample_data \
 && chmod 600 $(find   /etc/openldap /var/db /var/log/openldap -type f) \
 && chmod 700 $(find   /etc/openldap /var/db /var/log/openldap -type d)
VOLUME /etc/openldap/ \
       /var/db/ \
       /var/log/openldap

CMD /start.sh
