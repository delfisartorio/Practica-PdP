class Jugador{
    const property equipo   
    const property recursos = [
        new Recurso(cantidad = 1000, tipoDeRecurso = oro),
        new Recurso(cantidad = 0, tipoDeRecurso = madera),
        new Recurso(cantidad = 0, tipoDeRecurso = piedra),
        new Recurso(cantidad = 0,  tipoDeRecurso = comida)]

    method explotar(recurso,lugar){
        self.gastarRecurso(oro,50)
        self.aumentarRecurso(recurso, lugar.cantidadQueDa())
    }

    method gastarRecurso(tipoDeRecurso,cantidad){ // entiendo que solo tiene 1 de cada recurso
        const recursoAUsar = recursos.find({recurso => recurso.tipoDeRecurso() == tipoDeRecurso})
        recursoAUsar.gastar(cantidad)
    }
    method aumentarRecurso(tipoDeRecurso,cantidad){
        const recursoAUsar = recursos.find({recurso => recurso.tipoDeRecurso() == tipoDeRecurso})
        recursoAUsar.incrementar(cantidad)
    }
    
}

class Mina{
    const property cantidadQueDa
    
}



class Recurso{
    var cantidad
    const tipoDeRecurso
    method gastar(cantidadAGastar){
        if(cantidad<cantidadAGastar){
            throw new CantidadException (message = "No puede gastar esta cantidad")
        }
        cantidad-=cantidadAGastar
    }
    method incrementar(cantidadAIncorporar){
        cantidad+=cantidadAIncorporar
    }
}

object oro{}
object madera{}
object piedra{}
object comida{}

//Exceptions
 
class CantidadException inherits DomainException{}