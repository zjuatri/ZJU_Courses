from pypdf import PdfReader
r=PdfReader('实习报告.pdf'); print('pages',len(r.pages))
