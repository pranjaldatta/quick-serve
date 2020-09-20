from quickserve import tunnel

from quickserve.web import ServeWeb

from PIL import Image   

def action(x):
    img = Image.open("demo/cat.jpeg")
    return img

tn_ngrok = tunnel.NGROK("image", action=action, template="test_template", action_input_type="PIL")
tn_ngrok.establish_tunnel()