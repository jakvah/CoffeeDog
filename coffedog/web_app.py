# -*- coding: utf-8 -*- 
from flask import Flask, request, render_template, Markup,flash,redirect
import requests
#from flask_cors import CORS

app = Flask(__name__)
app.secret_key = "super secret key"
#CORS(app)
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
    card_no = request.form["card_id"]
    card_name = request.form["card_name"]
    
    card_id = reverseBytes(int(card_no))
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

# FROM: https://github.com/hermabe/rfid-card
def reverseBytes(number):
    binary = "{0:0>32b}".format(number) # Zero-padded 32-bit binary
    byteList = [binary[i:i+8][::-1] for i in range(0, 32, 8)] # Reverse each byte
    return int(''.join(byteList), 2) # Join and convert to decimal
    # return int(''.join(["{0:0>32b}".format(number)[i:i+8][::-1] for i in range(0, 32, 8)]), 2)


if __name__ == '__main__':
    # Set debug false if it is ever to be deployed
    app.run(debug=True) 