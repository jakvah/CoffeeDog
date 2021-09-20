from flask import Flask, jsonify
import db_manager as dbm

app = Flask(__name__)

@app.route('/')
def hello_world():
    return "CoffeeDog says sniff sniff"

@app.route("/add_coffee/<id>/<timestamp>", methods=["POST"])
def add_coffee(id,timestamp):
    try:
        dbm.insert_new_coffee(id,timestamp)
        feedback = dbm.update_user_stats(id)
        return f"Added ID: {id} @ {timestamp} and updated leaderboard, {feedback}"
    except Exception as e:
        return f"Failed with reason: {str(e)}"
        

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
