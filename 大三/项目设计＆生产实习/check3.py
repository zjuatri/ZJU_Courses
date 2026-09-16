from pypdf import PdfReader
r=PdfReader('实习报告.pdf'); print('pages',len(r.pages)); print('chars',len(''.join(p.extract_text() or '' for p in r.pages)))
