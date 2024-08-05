FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y cron curl

COPY log_ip.sh /usr/local/bin/log_ip.sh

RUN chmod +x /usr/local/bin/log_ip.sh
RUN echo "0 * * * * /usr/local/bin/log_ip.sh" > /etc/cron.d/log_ip_cron && \
    chmod 0644 /etc/cron.d/log_ip_cron && \
    crontab /etc/cron.d/log_ip_cron
RUN touch /var/log/ip_address.log

VOLUME ["/data"]

CMD ["cron", "-f"]
