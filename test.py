import pyimgur

CLIENT_ID = "891e1beff3d3fb1"
PATH = "image/lena.png"

im = pyimgur.Imgur(CLIENT_ID)
uploaded_image = im.upload_image(PATH, title="Uploaded with PyImgur")
print(uploaded_image.title)
print(uploaded_image.link)
print(uploaded_image.size)
print(uploaded_image.type)