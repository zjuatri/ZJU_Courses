from pypdf import PdfReader
r=PdfReader('实习报告.pdf'); print(len(r.pages)); print(len(''.join(p.extract_text() or '' for p in r.pages)))
