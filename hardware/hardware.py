import rdm6300
import time
import datetime
from gpiozero import TonalBuzzer, LED
from gpiozero.tones import Tone



blue_led = LED(18)
b = TonalBuzzer(23)
red_led = LED(24)
queue = {}

# ---------- SETUP ----------#

VERSION = 0.3
COFFEE_TIMEOUT = 5 # Time to wait until you can dog another coffee


# ---------------------------#

def send_coffee_data(id,timestamp):
    import requests
    url = f"https://jakvah.pythonanywhere.com/add_coffee/{id}/{timestamp}"
    #data_obj = {"id":id,"timestamp":timestamp}
    r = requests.post(url)
    now = datetime.datetime.now()
    print (str(now.hour) + ":" + str(now.minute) + ":" + str(now.second) + " - " + r.text)

def play_tune(cardvalue):
    #customTone = (str(cardvalue)[-4:])
    #for number in customTone:
    #    b.play(Tone(int(220+int(number)*66)))
    #    time.sleep(0.1)
    b.play(Tone(int(220+66*2)))
    time.sleep(0.05)
    b.play(Tone(int(220+66*4)))
    time.sleep(0.05)
    b.play(Tone(int(220+66*6)))
    time.sleep(0.05)
    b.play(Tone(int(220+66*8)))
    time.sleep(0.05)
    b.play(Tone(int(220+66*6)))
    time.sleep(0.05)
    b.play(Tone(int(220+66*4)))
    time.sleep(0.05)
    b.play(Tone(int(220+66*2)))
    time.sleep(0.05)
    b.stop()

def play_declined():
    b.play(Tone(220))
    time.sleep(0.5)
    b.stop()

def get_timestamp():
    dato = str(datetime.datetime.now())
    date = dato.split(' ')[0]
    klokkeslett = dato.split(' ')[1]
    dog = klokkeslett.split('.')[0]
    fulltimestamp = date+'T'+dog
    return fulltimestamp

# check_dict - Checks whether a card is in the dictionary, and if enough time has passed since the last read. If not in the dictionary, the card is added.
def check_dict(card_id):
    if card_id in queue: #Recently registered
        currenttime = int(time.time())
        if (currenttime - int(queue[card_id])) < COFFEE_TIMEOUT:
            print("")
            print("Litegranne snøgg, please wait " + str(COFFEE_TIMEOUT - (currenttime - int(queue[card_id]))) + " seconds.")
            return False
        else: #Refresh time
            queue[card_id] = str(int(time.time()))
            return True
    else: # Kort har ikke blitt sett nylig
        queue[card_id] = str(int(time.time()))
        return True

# read_card() - reads a card and sends data to website if valid.
def read_card():
    reader = rdm6300.Reader('/dev/ttyS0')
    card = reader.read(10)
    if card:
        print("---------------")
        print("Card detected. ID: " + str(card.value))
        reader.stop()
        if card.is_valid:
                if (check_dict(str(card.value))):
                    blue_led.off()
                    blue_led.blink(0.075,0.075,30)
                    play_tune(card.value)
                    send_coffee_data(card.value,get_timestamp())
                    print("---------------")
                else:
                    blue_led.off()
                    red_led.on()
                    play_declined()
                    time.sleep(1)
                    red_led.off()
                    print("---------------")

# clean_dict() - periodically cleans out old cards from the dictionary. 
def clean_dict():
    removallist = []
    currenttime = int(time.time())
    for key in queue:
        if (currenttime - int(queue[str(key)])) > COFFEE_TIMEOUT:
            removallist.append(str(key))
    for item in removallist:
        del queue[str(item)]
    removallist.clear()




print ("---------------------")
print ("   COFFEEDOG V." + str(VERSION) )
print ("---------------------")

print("       ▄      ▄  \n      ▐▒▀▄▄▄▄▀▒▌   \n    ▄▀▒▒▒▒▒▒▒▒▓▀▄  sniff\n  ▄▀░█░░░░█░░▒▒▒▐   sniff - hunden Sverre\n  ▌░░░░░░░░░░░▒▒▐  \n ▐▒░██▒▒░░░░░░░▒▐  \n ▐▒░▓▓▒▒▒░░░░░░▄▀  \n  ▀▄░▀▀▀▀░░░░▄▀     \n    ▀▀▄▄▄▄▄▀▀       ")
print("----------------------")
while True:
    blue_led.on()
    read_card()
    clean_dict()




