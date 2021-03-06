
FROM alpine:3.15

RUN apk add --update \
        tzdata \
        bash \
        tini \
        runit \
        rsyslog \
        logrotate \
    && rm -rf /var/cache/apk/*

ENV TZ=


## runit settings

RUN mkdir -p /runit/service/cron \
 && mkdir -p /runit/service/rsyslog

COPY service/cron.run    /runit/service/cron/run
COPY service/rsyslog.run /runit/service/rsyslog/run

RUN chmod +x /runit/service/*/run


## rsyslog & logrotate settings

RUN mkdir -p /etc/rsyslog.d \
 && mkdir -p /rsyslog/run \
 && mv /etc/logrotate.d /etc/logrotate.d.orig \
 && mkdir -p /etc/logrotate.d

COPY config/rsyslog.conf /etc/rsyslog.conf


## publish settings

EXPOSE 514

VOLUME /rsyslog/run
VOLUME /var/log

VOLUME /etc/rsyslog.d
VOLUME /etc/logrotate.d


## entrypoint setting

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

