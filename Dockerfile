# Use an official base image with Python and Bash (Debian in this case)
FROM python:3.11-buster

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    bash \
    git \
    postgresql \
    postgresql-contrib \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PostgreSQL client tools (optional but useful for accessing the databse)
RUN apt-get install -y postgresql-client

# Set environment variables for PostgreSQL
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password
ENV POSTGRES_DB=mydatabase

# Expose ports
EXPOSE 5432 # Expose the PostgreSQL port for external access
EXPOSE 5000 # Expose for Streamlit Apps (in case...)

# Start PostgreSQL server in the background and the container will stay running
CMD service postgresql start && tail -f /dev/null
