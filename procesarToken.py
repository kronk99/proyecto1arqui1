import string
import unicodedata

class tokenizer:
    def __init__(self,texto):
        self.texti = texto
        self.contenido = None
        self.palabras=None

    def eliminar_acento(self, texto):
        # Normalizar el texto para descomponer caracteres acentuados
        texto_normalizado = unicodedata.normalize('NFD', texto)
        # Eliminar los caracteres diacríticos (acentos)
        texto_sin_acento = ''.join(c for c in texto_normalizado if unicodedata.category(c) != 'Mn')
        return texto_sin_acento
    def procesarTexto(self): #procesa el texto creando una tabla de traduccion
        #que permite reemplazar los caracteres de puntuacion con espacios vacios
        #considerar ademas utilizar el estandar utf-8 para que reconozca bien
        #tildes y otros signos de puntuación.
        with open(self.texti,'r', encoding='utf-8') as archivo:
            contenido =archivo.read()
            # Crear una tabla de traducción para eliminar la puntuación
            ttraduccion = str.maketrans('', '', string.punctuation)
            contenido = contenido.translate(ttraduccion).lower()
            contenido = self.eliminar_acento(contenido)
            self.palabras= contenido.split()
    def guardarProcesado(self):
        # Abre un nuevo archivo de texto en modo escritura
        with open('archivo_nuevo.txt', 'w', encoding='utf-8') as nuevo_archivo:
            # Escribe cada palabra en una nueva línea en el nuevo archivo
            for palabra in self.palabras:
                nuevo_archivo.write(palabra + '\n')

