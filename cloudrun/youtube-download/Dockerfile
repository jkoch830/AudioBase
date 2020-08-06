FROM python:3.7-slim

ENV PYTHONUNBUFFERED True

RUN apt-get update -y && apt-get install -y \
  ffmpeg \
  && apt-get clean

# Copy application dependency manifests to the container image.
# Copying this separately prevents re-running pip install on every code change.
COPY requirements.txt ./

# Install production dependencies.
RUN pip install -r requirements.txt

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app