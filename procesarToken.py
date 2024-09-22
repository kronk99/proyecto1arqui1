import string
import unicodedata

import struct
class tokenizer:
    def __init__(self):
        self.texti = None #texto a procesar
        self.contenido = None #contenido del texto a procesar
        self.palabras=None #palabras procesadas sin mayusculas o signos de puntuacion
        self.palabras_dict = {} #diccionario de palabras que permite transformar letras a numeros
        self.numeros=None #variable que almacena el texto en formato de numeros
#funcion que elimina el acento , tildes y demas cuestiones
    def setearTexto(self,texto):
        self.texti=texto
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
    #funcion que fungirá como tabla de traduccion del diccionario
    #considerar que lo almacenado en el diccionario es el conjunto
    #palabra,valor
    def tradutoNUm(self):
        valor = 1
        for palabra in self.palabras:
            if palabra not in self.palabras_dict:
                self.palabras_dict[palabra] = valor
                valor += 1
    def limpiarDic(self):
        self.palabras_dict={}
    #obtiene el valor asociado a la palabra
    def obtener_valor_palabra(self, palabra):
        # Obtener el valor asignado a una palabra
        return self.palabras_dict.get(palabra, None)
    
    #funcion que permite transformar todo el texto en numeros 
    #en base al diccionario generado.
    def texto_a_numeros(self):
        # Transformar el texto a números utilizando el diccionario
        self.numeros = [self.obtener_valor_palabra(palabra) for palabra in self.palabras]
    
    #función que crea el archivo binario con el contenido del texto.
    def guardar_en_binario(self):
        with open('archivo_nuevo.bin', 'wb') as f:
            for numero in self.numeros:
                # Escribir el número como un entero de 4 bytes en formato binario
                f.write(struct.pack('I', numero)) 
    #funcion que convierte los numeros en binario en un arreglo de 20
    #numeros en ints, donde los primeros 10 numeros son las palabras como tal
    #y los ultimos 10 numeros son las frecuencias
    def revisar_binario(self,binario):
        numeros = []
        with open(binario, 'rb') as f:
            while True:
                data = f.read(4)  # Lee 4 bytes (1 entero de 4 bytes)
                if not data:
                    break
                numero = struct.unpack('I', data)[0]  # Desempaca el número
                numeros.append(numero)
        return numeros
    #traduce una lista de numeros de regreso a palabras
    def traducRegreso(self,numerosGrafo):
        palabrasGraf=[self.obtener_valor_numero(numeroG) for numeroG in numerosGrafo]
        return palabrasGraf
    #funcion que genera el grafo con pandas.
    def obtener_valor_numero(self, valor):
    # Invertir el diccionario palabras_dict (las claves se vuelven valores y los valores, claves)
        palabras_invertido = {v: k for k, v in self.palabras_dict.items()}
        #para cada valor v (letra) hay un valor k (palabra) , por cada numero
        #de la letra en el diccionario de palabras.
    
    # Obtener la palabra correspondiente al valor
        return palabras_invertido.get(valor, "Valor no encontrado")
