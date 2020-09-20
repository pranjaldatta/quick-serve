from quickserve.web import ServeWeb

from PIL import Image   

def action(x):
    img = Image.open("demo/cat.jpeg")
    return img

sw = ServeWeb("image", action=action, template="default_template", action_input_type="PIL")
sw.serve(debug=True)
