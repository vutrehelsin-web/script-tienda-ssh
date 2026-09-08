#!/usr/bin/env python3
import json
import os
import secrets
import sqlite3
from datetime import datetime
from http.server import BaseHTTPRequestHandler, HTTPServer

ROOT = "/etc/tiendassh"
DB_PATH = os.environ.get("DB_PATH", f"{ROOT}/data/keys.db")
API_TOKEN = os.environ["KEY_API_TOKEN"]
INSTALLER_URL = os.environ.get("INSTALLER_URL", "https://raw.githubusercontent.com/vutrehelsin-web/script-tienda-ssh/main/install/instalador.sh")

def initialize():
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    with sqlite3.connect(DB_PATH) as connection:
        connection.execute("""CREATE TABLE IF NOT EXISTS keys (id INTEGER PRIMARY KEY AUTOINCREMENT, key TEXT UNIQUE NOT NULL, user_id TEXT NOT NULL, user_name TEXT NOT NULL, plan TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'pendiente', created_at TEXT NOT NULL, activated_at TEXT, expires_at TEXT)""")

class Handler(BaseHTTPRequestHandler):
    def send_json(self, status, payload):
        body = json.dumps(payload).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_POST(self):
        if self.path != "/generatekey":
            self.send_json(404, {"error": "not found"})
            return
        if self.headers.get("Authorization") != f"Bearer {API_TOKEN}":
            self.send_json(401, {"error": "unauthorized"})
            return
        try:
            length = int(self.headers.get("Content-Length", "0"))
            data = json.loads(self.rfile.read(length))
            user_id = str(data["user_id"])
            user_name = str(data["user_name"])[:100]
            plan = str(data.get("plan", "30"))[:20]
            key = secrets.token_hex(16)
            created_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            with sqlite3.connect(DB_PATH) as connection:
                connection.execute("INSERT INTO keys (key,user_id,user_name,plan,status,created_at) VALUES (?,?,?,?,?,?)", (key, user_id, user_name, plan, "pendiente", created_at))
            self.send_json(200, {"key": key, "plan": plan, "created_at": created_at, "installer_url": INSTALLER_URL})
        except (KeyError, ValueError, json.JSONDecodeError, sqlite3.Error) as error:
            self.send_json(400, {"error": str(error)})

    def log_message(self, *_):
        return

initialize()
HTTPServer(("0.0.0.0", int(os.environ.get("KEY_API_PORT", "8890"))), Handler).serve_forever()
