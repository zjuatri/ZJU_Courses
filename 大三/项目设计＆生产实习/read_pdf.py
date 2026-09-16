from pypdf import PdfReader
r=PdfReader(r'C:\Users\zjuat\Desktop\template_pdf.pdf'); print('pages',len(r.pages));
for i,p in enumerate(r.pages):
 t=p.extract_text() or ''; print('\nPAGE',i+1,repr(t[:1000]))
