from pdf2image import convert_from_path
ims=convert_from_path(r'C:\Users\zjuat\Desktop\template_pdf.pdf',dpi=150,first_page=1,last_page=1)
ims[0].save('template_page1.png')
print(ims[0].size)
