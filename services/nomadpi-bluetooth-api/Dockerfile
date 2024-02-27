FROM python:3.11-slim

RUN apt-get update \
  && apt-get install -y \
    bluez \
    build-essential \
    libdbus-glib-1-dev \
    libgirepository1.0-dev \
    libcairo2 \
    libcairo2-dev

WORKDIR /app

COPY ./requirements.txt /app/requirements.txt

RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 5000