FROM python:3.8.6-slim

LABEL NAME=flask-app-image
LABEL VERSION=1.0.0

WORKDIR /app

RUN pip install --upgrade pip
RUN pip install pipfile-requirements

COPY Pipfile* /app/
RUN pipfile2req > requirements.txt \
    && pip install -r requirements.txt

COPY . /app/
RUN chmod +x /app/scripts/*

ENTRYPOINT [ "/app/scripts/run_app_local.sh" ]
