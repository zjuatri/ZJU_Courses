from PIL import Image
import numpy as np
f=r'C:\Users\zjuat\AppData\Local\Temp\codex-clipboard-c07564ae-356d-441b-a2a7-e0b22af596f8.png'; im=Image.open(f).convert('RGBA'); a=np.array(im)
# crop logo region
c=a[20:280,170:500,:]; mask=(c[:,:,:3].max(axis=2)<100)
# remove tiny noise by keeping pixels around logo; convert others transparent
out=np.zeros_like(c); out[:,:,:3]=0; out[:,:,3]=mask*255
# black pixels opaque
out[:,:,:3][mask]=0
ys,xs=np.where(mask); out=out[ys.min():ys.max()+1,xs.min():xs.max()+1]
Image.fromarray(out).save('zju_black_logo.png')
print(out.shape)
