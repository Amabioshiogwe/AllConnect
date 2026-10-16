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



# ==================== PAYSTACK ====================
import requests as _requests
from flask import request as _request

PAYSTACK_SECRET_KEY = os.environ.get("PAYSTACK_SECRET_KEY", "")

@app.route("/paystack/init", methods=["POST"])
def paystack_init():
    data = _request.get_json()
    email = data.get("email", "customer@example.com")
    amount_naira = int(data.get("amount", 500))
    reference = data.get("reference", "AC-" + str(int(__import__("time").time())))

    if not PAYSTACK_SECRET_KEY:
        return jsonify({"error": "Paystack secret key not set"}), 500

    try:
        r = _requests.post(
            "https://api.paystack.co/transaction/initialize",
            headers={
                "Authorization": "Bearer " + PAYSTACK_SECRET_KEY,
                "Content-Type": "application/json",
            },
            json={
                "email": email,
                "amount": amount_naira * 100,
                "reference": reference,
                "currency": "NGN",
            },
            timeout=30,
        )
        result = r.json()
        if result.get("status"):
            actual_ref = result["data"].get("reference", reference)
            return jsonify({
                "checkout_url": result["data"]["authorization_url"],
                "reference": actual_ref,
            })
        return jsonify({"error": result.get("message", "Paystack error")}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/paystack/verify/<reference>")
def paystack_verify(reference):
    if not PAYSTACK_SECRET_KEY:
        return jsonify({"error": "Paystack secret key not set"}), 500
    try:
        r = _requests.get(
            "https://api.paystack.co/transaction/verify/" + reference,
            headers={"Authorization": "Bearer " + PAYSTACK_SECRET_KEY},
            timeout=30,
        )
        result = r.json()
        if result.get("status") and result["data"]["status"] == "success":
            return jsonify({"verified": True, "amount": result["data"]["amount"] / 100})
        return jsonify({"verified": False})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
