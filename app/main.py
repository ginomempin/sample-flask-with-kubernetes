from flask import Flask, render_template

app = Flask(__name__, template_folder='templates')


@app.route('/')
def root():
    return render_template('index.html', message='You accessed the app.')
