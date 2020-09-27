#!/bin/bash

gunicorn --version
gunicorn --bind 0.0.0.0:5500 --workers=2 app.main:app
