from PIL import Image
for f in [r'C:\Users\zjuat\AppData\Local\Temp\codex-clipboard-c07564ae-356d-441b-a2a7-e0b22af596f8.png',r'C:\Users\zjuat\AppData\Local\Temp\codex-clipboard-0a490afe-2b5e-43af-a0bb-662c714dc225.png']:
 im=Image.open(f); print(f,im.size)
