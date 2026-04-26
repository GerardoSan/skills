from flask import Flask, jsonify
import os
import socket

app = Flask(__name__)

@app.route('/')
def home():
    hostname = socket.gethostname()
    pod_name = os.environ.get('POD_NAME', 'unknown')
    node_name = os.environ.get('NODE_NAME', 'unknown')
    
    return f"""
    <html>
    <head>
        <title>Sencillo App Python</title>
        <style>
            body {{
                font-family: Arial, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                text-align: center;
                padding: 50px;
            }}
            .container {{
                background: rgba(255, 255, 255, 0.1);
                padding: 30px;
                border-radius: 10px;
                backdrop-filter: blur(10px);
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            }}
            h1 {{
                font-size: 2.5em;
                margin-bottom: 20px;
            }}
            .info {{
                font-size: 1.2em;
                margin: 10px 0;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🚀 Página Web Sencilla en Python</h1>
            <div class="info">📍 Hostname: {hostname}</div>
            <div class="info">📦 Pod Name: {pod_name}</div>
            <div class="info">🖥️ Node Name: {node_name}</div>
            <div class="info">🌐 ¡Hola desde Kubernetes en GCP!</div>
        </div>
    </body>
    </html>
    """

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "service": "python-web-app"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
