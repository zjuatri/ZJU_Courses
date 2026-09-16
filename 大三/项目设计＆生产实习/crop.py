from PIL import Image
f=r'C:\Users\zjuat\AppData\Local\Temp\codex-clipboard-c07564ae-356d-441b-a2a7-e0b22af596f8.png'; im=Image.open(f); im.crop((170,20,470,290)).save('template_logo_crop.png')
