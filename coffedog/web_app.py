# -*- coding: utf-8 -*- 
from flask import Flask, request, render_template, Markup,flash,redirect
import requests

app = Flask(__name__)
app.secret_key = "super secret key"
NUM_TABS = 3

@app.route("/")
def index():
    navbar_status = [""]*NUM_TABS
    navbar_status[0] = "active"

    return render_template("index.html",
                            navbar_status = navbar_status)
@app.route("/leaderboard")
def leadboard():
    navbar_status = [""]*NUM_TABS
    navbar_status[1] = "active"

    return render_template("leaderboard.html",
                            navbar_status = navbar_status)


@app.route("/add_card",methods = ["POST"])
def add_card():
    card_id = request.form["card_id"]
    card_name = request.form["card_name"]
    url = f"https://jakvah.pythonanywhere.com/add_new_user/{card_id}/{card_name}"
    r = requests.post(url)
    
    if r.text == 200 or r.text == "200":
        flash_str = f"Successfully added {card_name}s card data!"
        flash(flash_str)
        return redirect("/leaderboard")
    elif r.text == 300 or r.text == "300":
        flash_str = f"A card with that ID has already been registered!"
        flash(flash_str)
        return redirect("/leaderboard")
    else:
        flash_str = f"Could not add {card_name}s card data!"
        flash(flash_str)
        return redirect("/leaderboard")




@app.route("/error")
def error():
    navbar_status = [""]*NUM_TABS
    
    return render_template("error.html",
                            navbar_status = navbar_status)
if __name__ == '__main__':
    # Set debug false if it is ever to be deployed
    app.run(debug=True) 