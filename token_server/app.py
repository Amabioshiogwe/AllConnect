import os
from flask import Flask, request, jsonify
from flask_cors import CORS
from livekit import api

app = Flask(__name__)
CORS(app)  # Allow your Netlify app to call this server

LIVEKIT_API_KEY = os.environ.get("LIVEKIT_API_KEY")
LIVEKIT_API_SECRET = os.environ.get("LIVEKIT_API_SECRET")

@app.route("/health")
def health():
    return jsonify({"status": "ok"})

@app.route("/token")
def get_token():
    room_name = request.args.get("room", "allconnect-main")
    identity = request.args.get("identity", "guest")

    grants = api.VideoGrants(
        room_join=True,
        room=room_name,
        can_publish=True,
        can_subscribe=True,
    )

    token = (api.AccessToken(LIVEKIT_API_KEY, LIVEKIT_API_SECRET)
             .with_identity(identity)
             .with_name(identity)
             .with_grants(grants)
             .to_jwt())

    return jsonify({"token": token, "room": room_name})

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
