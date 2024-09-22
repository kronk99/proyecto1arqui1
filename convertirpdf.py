import pdfplumber
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
class convertirpdf:
    def __init__(self):
        self.pdf = None#pdf a procesar
        self.texto = None #pdf transformado a txt
    #metodo que lee el pdf, y lo transforma a txt
    #abre el archivo con la biblioteca pdf plumber
    def pdf_a_txt(self,txt_file):
        with pdfplumber.open(self.pdf) as pdf:
            #abre txtfile en modo lectura, basicamente lo crea, txt_file
            #es el nombre que se le va a colocar al archivo txt
            #with open abre el archivo con encodificacion utf-8 como txt
            #si no existe lo crea, si existe sobreescribe
            with open(txt_file, 'w', encoding='utf-8') as txt:
                for pagina in pdf.pages:
                    texto = pagina.extract_text()
                    if texto:
                        txt.write(texto)
    def cambiarpdf(self,pdf):
        self.pdf=pdf
    def generarGrafo(self,posx,posy):
        df = pd.DataFrame({'X': posx, 'Y': posy})
    # Crear un histograma
        plt.figure(figsize=(10, 6))
        plt.bar(df['X'], df['Y'], color='blue')
        plt.xlabel('Palabra exacta')
        plt.ylabel('Concurrencia de los datos')
        plt.title('Histograma de las palabras más frecuentes del texto')
        plt.xticks(df['X'])

    # Guardar el histograma en un PDF
        with PdfPages('histograma.pdf') as pdf:
            pdf.savefig()  # guarda la figura actual en el pdf
            plt.close()    # cierra la figura para evitar que se muestre en pantalla  

