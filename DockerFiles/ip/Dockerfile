# Use an official base image
FROM ubuntu:latest

# Install cron
RUN apt-get update && \
    apt-get install -y cron curl

# Copy the script into the container
COPY log_ip.sh /usr/local/bin/log_ip.sh

# Make the script executable
RUN chmod +x /usr/local/bin/log_ip.sh

# Set up the cron job to run the script every hour
RUN echo "0 * * * * /usr/local/bin/log_ip.sh" > /etc/cron.d/log_ip_cron && \
    chmod 0644 /etc/cron.d/log_ip_cron && \
    crontab /etc/cron.d/log_ip_cron

# Create the log file
RUN touch /var/log/ip_address.log

# Start cron in the foreground
CMD ["cron", "-f"]
