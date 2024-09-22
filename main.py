import controller
from vista import vista
if __name__ == '__main__':
    controlador = controller.AppControlador()
    vistaActual = vista(controlador)  # Se pasa el callback
    controlador.setVIsta(vistaActual)
    vistaActual.mainloop()
   
