# import necessary libraries
import os
from flask import (
    Flask,
    render_template,
    jsonify,
    request,
    redirect)

#################################################
# Flask Setup
#################################################
app = Flask(__name__)

#################################################
# Database Setup
#################################################


# from file import tablename

@app.route("/")
def home():
    return render_template("index.html")

# query the google database and send the json results


if __name__ == "__main__":
    app.run()