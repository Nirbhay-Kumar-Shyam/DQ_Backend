FROM python:3.12-slim

#Install system dependencies for ODBC
RUN apt-get update && apt-get install -y \
    gcc \
    unixodbc-dev \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg \
    --no-install-recommends

# Add Microsoft ODBC Driver repository and install driver
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Add Microsoft ODBC Driver repository
RUN curl -fsSL https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Update and install Microsoft ODBC Driver
RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
#set wroking directory 
WORKDIR /app

COPY . /app

#Install any needed packages specified in requirments.txt
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

# Define environment variable 
ENV NAME=env

#RUN testapi.py
CMD [ "python", "testapi.py" ]