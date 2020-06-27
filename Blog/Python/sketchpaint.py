# This was written in 2006 and released as a micro open-source project for education purpose in 2009. 
# It's one of my first python pet project
# All variable and function names are in Italian.

#SketchPynt -v 0.1, Paolo Frigo 
import Tkinter, tkColorChooser, string, tkMessageBox, cPickle, tkFileDialog

VERSIONE="SketchPynt! v0.1"
AUTORE="SketchPynt!\n[PF] Paolo Frigo"
#DEFAULT, Impostazioni predefinite
COLORE="#000000"     #Colore della matita 
SFONDO="#FFFFFF"     #Colore di sfondo e della gomma
SIZE=[500,500]       #Dimensione Area di Disegno
MATITA=6             #Dimensione della matita
GOMMA=20             #Dimensione della gomma

def clean():
    canvas.delete('all') 
    initCanvas()    
def infoPro():
    tkMessageBox.showinfo(title=VERSIONE, message=AUTORE)    
def initCanvas():    
    Lavagna=canvas.create_rectangle(5, 5, SIZE[0]-5, SIZE[0]-5, fill=SFONDO, outline=COLORE )
    canvas.config(cursor='crosshair')
    canvas.tag_bind(Lavagna,'<B1-Motion>', onCanvasMov1)     
    canvas.tag_bind(Lavagna,'<B3-Motion>', onCanvasMov2)
    canvas.tag_bind(Lavagna,'<Button-2>', impostaColore)    
def impostaColore( event):    
    coloreNuovo=tkColorChooser.askcolor()
    global COLORE
    COLORE=coloreNuovo[1]    
def onCanvasMov1(event):  
    canvas.create_oval(event.x-(MATITA/2), event.y-(MATITA/2), event.x+(MATITA/2),  event.y+(MATITA/2), fill=COLORE, outline=COLORE)    
def onCanvasMov2(event):                  
    canvas.create_rectangle(event.x-(GOMMA/2), event.y-(GOMMA/2), event.x+(GOMMA/2),  event.y+(GOMMA/2), fill=SFONDO, outline=SFONDO)    
def stampa():
    file_da_salvare=tkFileDialog.asksaveasfilename(title='Esporta Disegno', filetypes=[ ('File PostScript!','*.ps')])
    canvas.postscript(file=file_da_salvare)
finestra=Tkinter.Tk()
finestra.title(VERSIONE)
canvas=Tkinter.Canvas(bg='white', width=SIZE[0], height=SIZE[1])
canvas.pack(side=Tkinter.BOTTOM)    
initCanvas()
menu=Tkinter.Menu(finestra)
finestra.config(menu=menu)
filemenu=Tkinter.Menu(menu)
menu.add_cascade(label="File", menu=filemenu)
filemenu.add_command(label="Nuovo", command=clean)
filemenu.add_command(label="Stampa", command=stampa)
filemenu.add_command(label="Esci",command=finestra.quit)
aboutmenu = Tkinter.Menu(menu)
menu.add_cascade(label="?", menu=aboutmenu)
aboutmenu.add_command(label="Info", command=infoPro)
finestra.mainloop()
