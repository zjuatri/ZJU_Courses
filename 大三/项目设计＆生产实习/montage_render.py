from PIL import Image,ImageDraw
import glob,os,math
fs=sorted(glob.glob('render/*.png')); ims=[]
for f in fs:
 im=Image.open(f).convert('RGB'); im.thumbnail((180,250)); ims.append(im)
out=Image.new('RGB',(180*4,270*math.ceil(len(ims)/4)),'white')
for i,im in enumerate(ims):out.paste(im,((i%4)*180,(i//4)*270))
out.save('render_montage.jpg')
