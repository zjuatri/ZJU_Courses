import importlib.util
for m in ['olefile','win32com','docx','lxml']:
 print(m,importlib.util.find_spec(m))
