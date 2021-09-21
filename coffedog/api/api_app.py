from flask import Flask, jsonify,request,redirect,flash
import db_manager as dbm


app = Flask(__name__)

@app.route('/')
def hello_world():
    return "CoffeeDog says sniff sniff"

@app.route("/add_coffee/<id>/<timestamp>", methods=["POST"])
def add_coffee(id,timestamp):
    try:
        if not dbm.user_exists(id):
            return f"Card ID: {id} not registered. Register card before adding to database"
        else:
            dbm.insert_new_coffee(id,timestamp)
            dbm.update_user_stats(id)
            return f"Added ID: {id} @ {timestamp} and updated leaderboard"
    except Exception as e:
        return f"Failed with reason: {str(e)}"


@app.route("/add_new_user/<card_id>/<user_name>",methods = ["POST"])
def add_new_user(card_id,user_name):
    try:
        if not dbm.user_exists(card_id):
            dbm.add_new_user_id(int(card_id),str(user_name))
            return "200"
        else:
            return "300"
    except Exception as e:
        s = str(e)
        return s


@app.route("/get_leaderboard",methods = ["GET"])
def get_leaderboard():
    dataset = dbm.get_sorted_leaderboard()
    scores_list = []
    for i,row in enumerate(dataset):
        score_dict = {}

        score_dict["name"] = row[1]
        score_dict["id"] = row[0]
        score_dict["score"] = row[2]
        score_dict["rank"] = i+1
        scores_list.append(score_dict)
    obj = {"scores" : scores_list}
    return jsonify(obj)

def send_coffee_data(id,timestamp):
    import requests
    url = "https://jakvah.pythonanywhere.com/add_coffee"
    data_obj = {
            "id": id,
            "timestamp" : timestamp}
    r = requests.post(url,data = data_obj)
