FROM  centos:7

# && yum -y install epel-release \
RUN yum -y update \
 && yum -y install curl iproute lsof net-tools \
 && yum -y install https://centos7.iuscommunity.org/ius-release.rpm \
 && yum -y install python36u python36u-pip \
 && ln -s /usr/bin/python3.6 /usr/bin/python3 \
 && ln -s /usr/bin/pip3.6 /usr/bin/pip3 \
 && yum -y install openldap openldap-servers openldap-clients \
 && yum clean all
RUN pip3 install ldap3

# save system default ldap config and extend it with project-specific files
COPY install/conf/*.conf /etc/openldap/
COPY install/conf/schema/* /etc/openldap/schema/
COPY install/conf/DB_CONFIG /var/db/
COPY install/scripts/* /scripts/
COPY install/tests /tests
RUN chmod -R +x /scripts/* /tests/*

ARG SLAPDPORT=8389
ENV SLAPDPORT $SLAPDPORT

# using the shared grop method from https://docs.openshift.com/container-platform/3.3/creating_images/guidelines.html (Support Arbitrary User IDs)
RUN chown -R ldap:root /etc/openldap /tests /var/db \
 && chmod 600 $(find   /etc/openldap -type f) \
 && chmod 700 $(find   /etc/openldap -type d)
VOLUME /etc/openldap/ /var/db/

CMD /scripts/start.sh
