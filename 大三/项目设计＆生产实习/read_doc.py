from pathlib import Path
p=Path(r'C:\Users\zjuat\Desktop\生产实习报告模板v1.0.doc')
b=p.read_bytes(); print(b[:20]);
for enc in ['gb18030','utf-16','utf-8']:
 try:
  t=b.decode(enc,errors='ignore'); print(enc,len(t),t[:500])
 except: pass
