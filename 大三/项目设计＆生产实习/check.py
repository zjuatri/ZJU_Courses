from pypdf import PdfReader
r=PdfReader('实习报告.pdf'); print('pages',len(r.pages)); txt=''.join(p.extract_text() or '' for p in r.pages); print('chars',len(txt)); print(txt[:200])
