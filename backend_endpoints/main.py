import flask
from flask import Flask, jsonify, request
import pandas as pd
import firebase_admin
from firebase_admin import credentials, firestore
import configparser
config  = configparser.ConfigParser()
config.read('key.ini')

cred = credentials.Certificate("mycampuskey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

app = Flask(__name__)


def letter_to_number(arrays: list):
    try:
        numbers = [ord(x) - 65 for x in arrays]
    except TypeError:
        return None
    else:   
        return numbers

class Firestore():
    def __init__(self, collectionn, documentt = None) -> None:
        self.collection = collectionn
        self.document = documentt
    
    def bf(self):
        if self.document == None:
            return db.collection(self.collection)
        return db.collection(self.collection).document(self.document)

    def gtcl(self):
        return db.collection(self.collection).get()

    def update(self, data: list):
        if self.document == None:
            raise ValueError("This is not a valid format!")
        return self.bf().update(data)

    def set(self, data: list):
        return self.bf.add(data)
    
    def get_todict(self):
        return self.bf().get().to_dict()




@app.errorhandler(404)
def id_not_found(error):
    print(error)
    return jsonify(status="error", message="user not available"), 404


@app.errorhandler(403)
def already_in_waiting_list(error):
    return jsonify(status="error", message="this user already in waiting room"), 403


@app.route("/")
def welcomescreen():
    return '<h1>You Have Reached MyCampus Endpoint!</h1>'


@app.route('/favicon.ico')
def favicon():
    return "<link rel='shortcut icon' href='{{ url_for(\'static\', filename=\'favicon.ico\') }}'>"

@app.route("/testkey")
def testkey():
    auth = request.headers.get("X-Api-Key")
    if auth == config['Key']['API_KEY']:
        return jsonify(status="ok"), 200
    else:
        return jsonify(status="error", message="x-api-key"), 404

@app.route("/v1/searchpartner")
def nyot():
    auth = request.headers.get("X-Api-Key")
    if auth == config['Key']['API_KEY']:
        return search_partner()
    else:
        return jsonify(status="error", message="x-api-key"), 404
def search_partner():
    user_id = request.args.get('id')
    get_all_users = [x.id for x in db.collection('userAnswersDummy').get()]
    if user_id not in get_all_users:
        flask.abort(404)

    def get_connected_user(dataframe: pd.DataFrame, userid: str):
        try:
            connected_user = db.collection('userAnswersDummy').document(user_id).get().to_dict()['connected']
            dtfrm = pd.DataFrame(dataframe[userid]).drop([connected_user])
            return dtfrm
        except KeyError:
            return None


    def get_correlation(userid: str):
        all_waitingroom = db.collection('waitingRoom').document('waitinglist').get().to_dict()['ids']
        if user_id in all_waitingroom:
            flask.abort(403)
        db.collection('waitingRoom').document('waitinglist').update({'ids': firestore.ArrayUnion([userid])})
        waiting_room = db.collection('waitingRoom').document('waitinglist').get().to_dict()['ids']
        user_search_partner = userid
        data_look_up = {
            user_search_partner: letter_to_number(db.collection('userAnswersDummy').document(user_search_partner).get().to_dict()['answer'])
        }
        dataframe = pd.DataFrame(data_look_up)

        for waiting_list in waiting_room:
            if waiting_list == userid:
                continue
            newdata = {
                waiting_list: letter_to_number(db.collection('userAnswersDummy').document(waiting_list).get().to_dict()['answer'])
            }
            newdataframe = pd.DataFrame(newdata)
            dataframe = pd.concat([dataframe, newdataframe], axis=1)

        if len(waiting_room) < 2:
            return None
        dataframe = dataframe.corr(method="pearson")
        dtfrm = pd.DataFrame(dataframe[user_search_partner]).drop(index=user_search_partner)

        dtfrm_new = get_connected_user(dtfrm, user_id)
        if dtfrm_new is not None:
            dtfrm = dtfrm_new

        dtfrm.index.name = 'id'

        dtfrm2 = dtfrm[dtfrm[user_search_partner] == dtfrm[user_search_partner].max()]
        partnerfound = dtfrm2.index[0]
        return partnerfound

    partner_found = get_correlation(user_id)
    print(partner_found)

    if partner_found is not None:
        db.collection('waitingRoom').document('waitinglist').update({"ids": firestore.ArrayRemove([partner_found, user_id])})
        db.collection('userAnswersDummy').document(user_id).update({"connected": firestore.ArrayUnion([partner_found])})
        db.collection('userAnswersDummy').document(partner_found).update({"connected": firestore.ArrayUnion([user_id])})
        return jsonify(status="success", partner=partner_found)
    else:
        return jsonify(status="waiting", partner="waiting_idle")


@app.route('/v2/searchpartner')
def index1():
    auth = request.headers.get("X-Api-Key")
    if auth == config['Key']['API_KEY']:
        return partner_lookup()
    else:
        return jsonify(status="error", message="x-api-key"), 404


def partner_lookup():
    user_id = request.args.get('id')
    all_users = Firestore('users')
    get_all_users = [x.id for x in all_users.bf().get()]
    # print(get_all_users)
    if user_id not in get_all_users:
        flask.abort(404)

    mbti = {
        "INFJ": ["INFJ", "INTJ", "ENFP", "ENTP", "ESFP", "INFP", "ESTP"],
        "INTJ": ["INFJ", "INTJ", "ENFP", "ENTP", "ESFP", "INFP", "ESTP", "INTP"],
        "ENTJ": ["ENTJ", "ENFJ", "ENTP", "INTP", "INFP", "ISTP", "ISFP"],
        "ENFJ": ["ENTJ", "ENFJ", "ENFP", "INTP", "INFP", "ISTP", "ISFP"],
        "ENFP": ["INFJ", "INTJ", "ENFJ", "ENFP", "ENTP", "ISFJ", "ISTJ"],
        "ENTP": ["INFJ", "INTJ", "ENTJ", "ENFP", "ENTP", "INTP", "ISFJ", "ISTJ"],
        "INTP": ["INTJ", "ENTJ", "ENFJ", "INTP", "INFP", "ESTJ", "ESFJ"],
        "INFP": ["INFJ", "ENTJ", "ENFJ", "INTP", "INFP", "ESTJ", "ESFJ"],
        "ISFJ": ["ENFP", "ENTP", "ISFJ", "ISTJ", "ESFP", "ESTP", "ISFP"],
        "ISTJ": ["ENFP", "ENTP", "ISFJ", "ISTJ", "ESFP", "ESTP", "ISTP"],
        "ESTJ": ["INTP", "INFP", "ESTJ", "ESFJ", "ESTP", "ISTP", "ISFP"],
        "ESFJ": ["INTP", "INFP", "ESTJ", "ESFJ", "ESFP", "ISTP", "ISFP"],
        "ESFP": ["INFJ", "INTJ", "ISFJ", "ISTJ", "ESFJ", "ESFP", "ESTP"],
        "ESTP": ["INFJ", "INTJ", "ISFJ", "ISTJ", "ESTJ", "ESFP", "ESTP"],
        "ISTP": ["ENTJ", "ENFJ", "ISTJ", "ESTJ", "ESFJ", "ISTP", "ISFP"],
        "ISFP": ["ENTJ", "ENFJ", "ISFJ", "ESTJ", "ESFJ", "ISTP", "ISFP"],
    }
    
    waitingroom = Firestore('waitingRoom', 'waitinglist')
    waiting_room: list = waitingroom.get_todict()['ids']


    if user_id not in waiting_room:
        waitingroom.update({'ids': firestore.ArrayUnion([user_id])})

    if len(waiting_room) < 2:
        return jsonify(status="waiting", partner="waiting_idle")

    userfirestore = Firestore('userAnswers', user_id)

    user_seeker_data = userfirestore.get_todict()
    ufirestore = Firestore('users', user_id)

    user_mbti = ufirestore.get_todict()['mbti']

    if user_mbti == None:
        return jsonify(status="error", message="null_mbti"), 404

    user_partner = [x for x in waiting_room if Firestore('users', x).get_todict()['mbti'] in mbti[user_mbti]]
            
    if 'connected' in user_seeker_data:
        for user_connected in user_seeker_data['connected']:
            if user_connected in user_partner:
                waiting_room.remove(user_connected)


    dtfrmlifestyle = {
        user_id: [int(x) for x in userfirestore.get_todict()['lifestyleAnswer']]
    }
    interestlist = {
        user_id: ufirestore.get_todict()['interests']
    }
    for person in user_partner:
        dtfrmlifestyle[person] = [int(x) for x in Firestore('userAnswers', person).get_todict()['lifestyleAnswer']]
        interestlist[person] = Firestore('users', person).get_todict()['interests']
    
    lifestyle_dataframe = pd.DataFrame(dtfrmlifestyle)
    user_seeker_interest = ufirestore.get_todict()['interests']

    interestpercentage = {}
    for key in interestlist:
        prob = 0
        for interest in user_seeker_interest:
            for otherinterest in interestlist[key]:
                if interest == otherinterest:
                    prob += 1
                    break
        interestpercentage[key] = prob/len(user_seeker_interest)
    
    interestpercentage = pd.Series(interestpercentage, index=interestpercentage.keys())
    dataframe_lifestyle = lifestyle_dataframe.corr(method='pearson').drop(index=user_id).rename(columns={user_id: "lifestyle"})

    table_similarity = pd.concat([dataframe_lifestyle, interestpercentage], axis=1).rename(columns={0: "interest"})
    table_similarity['total'] = table_similarity.sum(axis=1)
    table_similarity = table_similarity.drop(['lifestyle', 'interest'], axis=1)

    get_partner = table_similarity[table_similarity['total'] == table_similarity['total'].max()]
    get_partner = get_partner.index[0]
    if get_partner == user_id:
        return jsonify(status="waiting", partner="waiting_idle")
    ufirestore.update({'alreadyConnect': firestore.ArrayUnion([get_partner])})
    Firestore('users', get_partner).update({'alreadyConnect': firestore.ArrayUnion([user_id])})
    waitingroom.update({'ids': firestore.ArrayRemove([user_id, get_partner])})

    return jsonify(status="success", partner=get_partner)


@app.route('/v2/mbti')
def index2():
    auth = request.headers.get("X-Api-Key")
    if auth == config['Key']['API_KEY']:
        return calculate_mbti()
    else:
        return jsonify(status="error", message="x-api-key"), 404


def calculate_mbti():
    user_id = request.args.get('id')

    data_user = Firestore('userAnswers', user_id)

    get_all_users = [x.id for x in data_user.gtcl()]
    if user_id not in get_all_users:
        return jsonify(status="error", message="user not available"), 404

    def IE(q3, q7, q11, q15, q19, q23, q27, q31):
        total = 30 - q3 - q7 - q11 + q15 - q19 + q23 + q27 - q31
        if total > 24:
            return "E"
        else:
            return "I"


    def SN(q4, q8, q12, q16, q20, q24, q28, q32):
        total = 12 + q4 + q8 + q12 + q16 + q20 - q24 - q28 + q32
        if total > 24:
            return "N"
        else:
            return "S"


    def FT(q2, q6, q10, q14, q18, q22, q26, q30):
        total = 30 - q2 + q6 + q10 - q14 - q18 + q22 - q26 - q30
        if total > 24:
            return "T"
        else:
            return "F"


    def JP(q1, q5, q9, q13, q17, q21, q25, q29):
        total = 18 + q1 + q5 - q9 + q13 - q17 + q21 - q25 + q29
        if total > 24:
            return "P"
        else:
            return "J"


    def mbti_result(n: list):
        ie = IE(n[2], n[6], n[10], n[14], n[18], n[22], n[26], n[30])
        sn = SN(n[3], n[7], n[11], n[15], n[19], n[23], n[27], n[31])
        ft = FT(n[1], n[5], n[9], n[13], n[17], n[21], n[25], n[29])
        jp = JP(n[0], n[4], n[8], n[12], n[16], n[20], n[24], n[28])
        return  ie + sn + ft + jp
    
    print(data_user.get_todict())
    mbti_answer = mbti_result(data_user.get_todict()['personalityAnswer'])
    return jsonify(mbti=mbti_answer)
    
    


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)