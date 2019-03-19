FROM intra/centos7_py36_base

RUN yum -y update \
 && yum -y install curl iproute lsof net-tools wget \
 && wget -q https://repo.symas.com/configs/SOFL/rhel7/sofl.repo -O /etc/yum.repos.d/sofl.repo \
 && yum -y install symas-openldap-clients symas-openldap-servers \
 && yum clean all
RUN pip3 install ldap3

# save system default ldap config and extend it with project-specific files
COPY install/conf/*.conf /etc/openldap/
COPY install/conf/schema/* /etc/openldap/schema/
COPY install/conf/DB_CONFIG /var/db/
COPY install/bin/* /opt/bin/
COPY install/tests /tests
RUN chmod -R +x /opt/bin/* /tests/*

RUN chown -R ldap:ldap /etc/openldap /tests /var/db \
 && chmod 600 $(find   /etc/openldap -type f) \
 && chmod 700 $(find   /etc/openldap -type d)
VOLUME /etc/openldap/ /var/db/

CMD /opt/bin/start.sh
