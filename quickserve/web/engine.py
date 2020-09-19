from flask import Flask, render_template, request, jsonify
import sys  
import os  
import numpy as np
from PIL import Image 
import cv2
import base64
import io

__PREFIX__ = os.path.dirname(os.path.realpath(__file__))

_templates = {  
    "test_template" : "client/test_templates/templates/",
    "default_template": "client/default_template/templates/",
}
_static = {
    "test_template" : "client/test_templates/static/", 
    "default_template": "client/default_template/static/",
}

_input_types = ["image"]


class ServeWeb(object):

    def __init__(self, input_type, action, template="default_template", 
                host="127.0.0.1", port="5001", action_input_type=None):
        

        if input_type == "image" and action_input_type is None:
            raise ValueError(f"input_type={input_type} but action_input_type={action_input_type}; needs to be either cv2 or PIL format")
        if action_input_type not in ["PIL", "cv2"]:
            raise ValueError(f"got action_input_type as {action_input_type} but only PIL or cv2 allowed")
    
        self.input_type = input_type
        self.action = action 
        self.host = host 
        self.port = port
        self.template = template
        self.action_input_type = action_input_type


    def serve(self, debug=False):

        app = Flask(__name__, template_folder=os.path.join(__PREFIX__, _templates[self.template]),
                static_folder=os.path.join(__PREFIX__, _static[self.template]))

        @app.route("/")
        def home():
            return render_template("index.html")

        @app.route("/infer", methods=['POST'])
        def run_action_pre_hook():
            
            _file = request.files['image'].read()
            
            # converting base64 encoding to PIL format 
            npimage = np.fromstring(_file, np.uint8)
            img = cv2.imdecode(npimage, cv2.IMREAD_COLOR)

            img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

            #print(self.action_input_type)
            if self.action_input_type == "PIL":
                img = Image.fromarray(img.astype("uint8"))
            
            #pil_img.save("test.jpg")
            
            # result needs to a [H, W, C] image in either
            # cv2 or PIL format
            result = self.action(img) 

            # if numpy, then convert to uint8 and then to PIL
            if isinstance(result, np.ndarray):
                result = result.astype(np.uint8)
                result = Image.fromarray(result)
            elif isinstance(result, Image.Image):
                result = np.array(result).astype(np.uint8)
                result = Image.fromarray(result)
            else:
                raise TypeError(f"{type(result)} not supported as return types from inference function")
            
            buff = io.BytesIO()
            result.save(buff, "JPEG")
            encoding = base64.b64encode(buff.getvalue())

            # check return stuff
            return str(encoding)
            

        @app.after_request
        def after_request(response):
            print("log: setting cors" , file = sys.stderr)
            response.headers.add('Access-Control-Allow-Origin', '*')
            response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
            response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
            return response        
        
        app.run(host=self.host, port=self.port, debug=debug)

        