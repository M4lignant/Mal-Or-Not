from tkinter import *
from tkinter import ttk
import whois

rootentry = Tk()
rootentry.title('Mal-Or-Not')
rootentry.geometry("350x200+670+300")
bg= PhotoImage(file="matrixbg.png")
my_canvas = Canvas(rootentry, width=200, height=100, bd=0, highlightthickness=0, bg="green")
my_canvas.pack(fill="both", expand=True)

my_canvas.create_image(0,0, image=bg, anchor="nw")
my_canvas.create_text(180,45, text="Enter Domain name:", font=("Helvetica", 18,'bold'), fill="white")
entry = Entry(rootentry, font=("Helvitica",12),width=13, fg="black", bd=0)
entry_window = my_canvas.create_window(115,80,anchor='nw', window=entry)
typeid='Domain'
def store():
    global inp
    inp=entry.get()
    print(typeid+":"+inp)
    rootentry.destroy()

buttonentry=Button(rootentry, text="Done",font=("times",12),width=5,padx=15, pady=7, fg='white', bg='black', bd=0, command=store)
buttonentry_window = my_canvas.create_window(145,130, anchor='nw', window=buttonentry)

rootentry.mainloop()

w = whois.whois(inp)

rootentry = Tk()
rootentry.title('Domain info')
rootentry.geometry("410x600+670+300")

main_frame=Frame(rootentry)
main_frame.pack(fill=BOTH, expand=1)

my_canvas=Canvas(main_frame, bg='black', bd=0, highlightthickness=0, relief='ridge')
my_canvas.pack(side=LEFT, fill=BOTH, expand=1)

my_scrollbar=ttk.Scrollbar(main_frame, orient=VERTICAL, command=my_canvas.yview)
my_scrollbar.pack(side=RIGHT, fill=Y)

my_canvas.configure(yscrollcommand=my_scrollbar.set)
my_canvas.bind('<Configure>', lambda e:my_canvas.configure(scrollregion=my_canvas.bbox("all")))

second_frame=Frame(my_canvas, bg='black')

my_canvas.create_window((0,0), window=second_frame, anchor='nw')

row=0
col=0
for i in w.keys():
    if i != 'status':
        col=0
        text_key= Label(second_frame, text=i.capitalize().replace("_", " ")+":", font='"Helvetica" 12', bg='black', fg='lime').grid(row=row, column=col)
        col+=1
        if (w[i]!=None):
            if (type(w[i]) is list):
                dlen=len(w[i])
                for j in range(0,dlen):
                    text_value= Label(second_frame, text=w[i][j], font='"Helvetica" 12', bg='black', fg='lime').grid(row=row, column=col)
                    row+=1

            else:
                text_value= Label(second_frame, text=w[i], font='"Helvetica" 12', bg='black', fg='lime').grid(row=row, column=col)
                row+=1
        else:
            text_value= Label(second_frame, text='Not listed', font='"Helvetica" 12', bg='black', fg='lime').grid(row=row, column=col)
            row+=1

rootentry.mainloop()
