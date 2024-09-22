import tkinter as tk
import procesarToken
from tkinter import filedialog
from tkinter import messagebox
import convertirpdf
class AppControlador:
    def __init__(self):
        self.vista = None
        self.modelo = procesarToken.tokenizer() #clase de tokenizado
        self.pdf = convertirpdf.convertirpdf() #clase para generar el histograma de pandas
    def setVIsta(self,vista):
        self.vista = vista

    def seleccionar_txt(self):
        archivo = filedialog.askopenfilename(title="Seleccionar archivo 1")
        if archivo:
            self.modelo.setearTexto(archivo)
            messagebox.showinfo("Archivo seleccionado", f"Archivo 1 seleccionado: {archivo}")

    def seleccionar_binario(self):
        archivo = filedialog.askopenfilename(title="Seleccionar el archivo Binario")
        if archivo:
            numeros = self.modelo.revisar_binario(archivo)
            numeros_x = numeros[:10] #los 10 primeros elementos
            valores_x=self.modelo.traducRegreso(numeros_x)
            valores_y= numeros[10:]#los ultimos 10 elementos
            self.pdf.generarGrafo(valores_x,valores_y)
            messagebox.showinfo("se genero el pdf como grafico.pdf")

    def procesar_txt(self):
        if self.modelo.texti !=None:
            self.modelo.limpiarDic()#limpia primero el diccionario.
            self.modelo.procesarTexto() #procesa el texto
            self.modelo.tradutoNUm() #crea el diccionario de traduccion a numeros
            self.modelo.texto_a_numeros()
            self.modelo.guardar_en_binario()
            #print("el texto procesado es:", procesarTexto.palabras)
            #print("los numeros asignados son:")
            #print(procesarTexto.numeros)
            #print("los numeros del bin son:")
            messagebox.showinfo("Se proceso el archivo correctamente,buscar archivo_nuevo.bin")
        else:
            messagebox.showinfo("no se ha seleccionado ningun archivo")
    

