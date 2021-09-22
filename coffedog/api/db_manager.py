import MySQLdb

DATABASE_LOGIN_DETAILS = {
	"host":"jakvah.mysql.pythonanywhere-services.com",
	"user":"jakvah",
	"password":"passord123",
	"database":"jakvah$coffeedog"
}


# Returns a datbase connection object.
def get_database_connection():
    try:
        db_conn = MySQLdb.connect(DATABASE_LOGIN_DETAILS["host"],DATABASE_LOGIN_DETAILS["user"],DATABASE_LOGIN_DETAILS["password"],DATABASE_LOGIN_DETAILS["database"],use_unicode=True, charset="utf8")
        return db_conn
    except Exception as e:
        #print("Could not establish connection to the database. Is the server running?")
        return f"Failed, {e}"

def insert_new_coffee(id,timestamp,table_name = "history"):
    conn = get_database_connection()
    cur = conn.cursor()
    query = f"INSERT INTO {table_name} (id,timestamp) VALUES (%s,%s)"
    cur.execute(query,(int(id),str(timestamp)))
    conn.commit()
    cur.close()
    conn.close()

def user_exists(id):
    conn = get_database_connection()
    cur = conn.cursor()
    query = "SELECT * FROM user_stats"
    cur.execute(query)
    set = cur.fetchall()
    for row in set:
        if int(row[0]) == int(id):
            cur.close()
            conn.close()
            return True
    else:
        cur.close()
        conn.close()
        return False

def add_new_user_id(id,name,num_coffees= 0):
    conn = get_database_connection()
    cur = conn.cursor()
    query = "INSERT INTO user_stats (id,name,num_coffees) values (%s,%s,%s)"
    cur.execute(query,(int(id),str(name),int(num_coffees)))
    conn.commit()
    cur.close()
    conn.close()

def set_user_name(id,new_name):
    conn = get_database_connection()
    cur = conn.cursor()
    query = f"UPDATE user_stats SET name = {new_name} WHERE id = {id}"
    cur.execute(query)
    conn.commit()
    cur.close()
    conn.close()


def update_user_stats(id):
    conn = get_database_connection()
    cur = conn.cursor()
    if not user_exists(id):
        add_new_user_id(id,"Unknown user")
    query = f"UPDATE user_stats SET num_coffees = num_coffees + 1 WHERE id = {id}"
    cur.execute(query)
    conn.commit()
    cur.close()
    conn.close()

def get_sorted_leaderboard():
    conn = get_database_connection()
    cur = conn.cursor()
    query = "SELECT * FROM user_stats ORDER BY num_coffees DESC"

    cur.execute(query)
    data = cur.fetchall()
    cur.close()
    conn.close()
    return data