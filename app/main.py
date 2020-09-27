from flask import Flask, make_response

app = Flask(__name__)


@app.route("/")
def root():
    data = {"a": 1, "b": 2}
    return make_response(data)
