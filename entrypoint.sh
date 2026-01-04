FROM debian:stable-slim

# Install curl and ca-certificates (Required for the script to download playit)
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the script to the container
COPY entrypoint.sh /app/entrypoint.sh

# Make the script executable
RUN chmod +x /app/entrypoint.sh

# Set working directory
WORKDIR /app

# Run the script
CMD ["./entrypoint.sh"]
