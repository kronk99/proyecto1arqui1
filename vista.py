import tkinter as tk
class vista(tk.Tk):
    #se pasa la referencia del controlador
    def __init__(self, controlador):
        super().__init__()

        self.controlador = controlador
        self.title('Interfaz MVC con Tkinter')
        self.geometry('300x200')

        # Botones
        self.boton_archivo1 = tk.Button(self, text="Seleccionar el archivo txt", command=self.controlador.seleccionar_txt)
        self.boton_archivo1.pack(pady=10)
        self.btn_procesar_txt = tk.Button(self, text="procesar archivo selecionado", command=self.controlador.procesar_txt)
        self.btn_procesar_txt.pack(pady=10)

        self.btn_proc_bin = tk.Button(self, text="Seleccionar archivo .bin", command=self.controlador.seleccionar_binario)
        self.btn_proc_bin.pack(pady=10)
        
        self.btn_salir = tk.Button(self, text="Salir", command=self.salir)
        self.btn_salir.pack(pady=10)

    def salir(self):
        self.quit()  # Cierra la aplicación
