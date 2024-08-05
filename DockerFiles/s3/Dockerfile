# Upload S3
FROM amazonlinux:latest

RUN yum update -y && \
    yum install -y aws-cli cronie

COPY upload_to_s3.sh /usr/local/bin/upload_to_s3.sh

RUN chmod +x /usr/local/bin/upload_to_s3.sh

RUN echo "0 * * * * /usr/local/bin/upload_to_s3.sh" > /etc/cron.d/upload_to_s3_cron && \
    chmod 0644 /etc/cron.d/upload_to_s3_cron && \
    crontab /etc/cron.d/upload_to_s3_cron

CMD crond -f
