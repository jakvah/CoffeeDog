# -*- coding: utf-8 -*- 
from flask import Flask, request, render_template, Markup

app = Flask(__name__)

NUM_TABS = 3

@app.route("/")
def index():
    navbar_status = [""]*NUM_TABS
    navbar_status[0] = "active"

    return render_template("index.html",
                            navbar_status = navbar_status)

if __name__ == '__main__':
    # Set debug false if it is ever to be deployed
    app.run(debug=True)