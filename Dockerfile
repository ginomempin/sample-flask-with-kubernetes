FROM python:3.8.6-slim

LABEL NAME=my-flask-app
LABEL VERSION=1.0.0

WORKDIR /workspace
COPY . /workspace
RUN chmod +x /workspace/scripts/*

RUN python -m pip install pipenv
RUN pipenv install --dev

ENTRYPOINT [ "/workspace/scripts/entrypoint.sh" ]
