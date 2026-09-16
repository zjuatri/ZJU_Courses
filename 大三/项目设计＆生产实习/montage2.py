from PIL import Image
import glob,math
fs=sorted(glob.glob('render2/*.png')); ims=[]
for f in fs:
 im=Image.open(f).convert('RGB'); im.thumbnail((180,250)); ims.append(im)
out=Image.new('RGB',(180*4,270*math.ceil(len(ims)/4)),'white')
for i,im in enumerate(ims):out.paste(im,((i%4)*180,(i//4)*270))
out.save('render2_montage.jpg')
