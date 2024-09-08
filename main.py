import procesarToken
if __name__ == '__main__':
    procesarTexto= procesarToken.tokenizer('texto.txt')

    procesarTexto.procesarTexto()
    procesarTexto.guardarProcesado()
