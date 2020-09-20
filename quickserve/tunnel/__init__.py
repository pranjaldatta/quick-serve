from flask import Flask, request, jsonify
from pyngrok import ngrok
import os
from ..web.engine import ServeWeb


__PREFIX__ = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))

_templates = {  
    "test_template" : "web/client/test_templates/templates/",
    "default_template": "web/client/default_template/templates/",
}
_static = {
    "test_template" : "web/client/test_templates/static/", 
    "default_template": "web/client/default_template/static/",
}

class NGROK(object):

    def __init__(self, input_type, action, template="default_template", 
                host="127.0.0.1", port="5001", action_input_type=None):
        
        self.sw = ServeWeb(input_type=input_type, action=action, template=template, 
            host=host, port=port, action_input_type=action_input_type)
        
        self.port = port

    def establish_tunnel(self):
        try:
        
            publicurl = ngrok.connect(port=self.port)
            print(f"The url is : {publicurl}")
            self.sw.serve()
        except KeyboardInterrupt:
            print("Killin tunnels ...")
            ngrok.disconnect(publicurl)