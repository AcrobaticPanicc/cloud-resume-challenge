import os
import requests
from flask import Flask
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)


@app.route('/increment_visitor_count', methods=['GET'])
def main():
    url = os.getenv("CLOUD_FUNCTION_URL")
    return requests.post(url).json


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
