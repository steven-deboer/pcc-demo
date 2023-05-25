# Use the latest version of busybox
FROM busybox:latest

# Add the script to the container
ADD pcc_demo.sh /

# Make the script executable
RUN chmod +x /pcc_demo.sh

# Run a command that executes indefinitely
CMD ["tail", "-f", "/dev/null"]