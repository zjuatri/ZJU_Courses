import zipfile, os, re, shutil
ppt=r'C:\Users\zjuat\Desktop\无视频PPT.pptx'; out=r'C:\Users\zjuat\Desktop\ppt_extract'
shutil.rmtree(out,ignore_errors=True); os.makedirs(out)
with zipfile.ZipFile(ppt) as z:z.extractall(out)
files=sorted([f for f in os.listdir(out+'\\ppt\\slides') if f.endswith('.xml')], key=lambda x:int(re.search(r'\d+',x).group()))
from xml.etree import ElementTree as ET
ns={'a':'http://schemas.openxmlformats.org/drawingml/2006/main'}
for f in files:
 root=ET.parse(out+'\\ppt\\slides\\'+f).getroot(); texts=[t.text for t in root.findall('.//a:t',ns) if t.text]
 print('\n###',f); print(' | '.join(texts))
