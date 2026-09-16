from PIL import Image,ImageDraw
import os,glob,math
p=r'C:\Users\zjuat\Desktop\ppt_extract\ppt\media'; fs=glob.glob(p+'/*'); thumbs=[]
for f in fs:
 try:
  im=Image.open(f).convert('RGB'); im.thumbnail((140,100)); thumbs.append((f,im.copy()))
 except: pass
out=Image.new('RGB',(700,math.ceil(len(thumbs)/5)*130),'white'); d=ImageDraw.Draw(out)
for i,(f,im) in enumerate(thumbs):
 x=(i%5)*140;y=(i//5)*130;out.paste(im,(x,y));d.text((x,y+102),os.path.basename(f),fill='black')
out.save(r'C:\Users\zjuat\Desktop\ppt_media_montage.jpg')
