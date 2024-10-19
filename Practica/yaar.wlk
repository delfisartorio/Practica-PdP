class Barco{
    var property  mision //puede cambiar de misión en cualquier momento
    var property tripulantes = #{}
    const property  capacidad

    method puedeRealizarMision(){
      return mision.puedeSerRealizadaPor(self)
    }

    method esTemible(){
      const capaces = tripulantes.filter({tripulante => tripulante.puedeRealizarMision(mision)})
      return self.puedeRealizarMision() and capaces.length()>=5
    } 
    
    method tripulacionSuficiente(){
      return tripulantes.lenght().between(capacidad*0.9, capacidad)
    }

    method condicionSaqueo(pirata){ // Tengo dudas de si esto tiene que estar aca o en pirata pero estoy quemada ya
      pirata.pasadoDeGrogXD()
    }
    method esVulnerbleA(otroBarco){
      return tripulantes.length()<= (otroBarco.tripulantes().length())/2
    }

    method incorporarTripulante(pirata){
      if(pirata.puedeSerTripulante(self)){
        tripulantes.add(pirata) and self.hayLugar()
      }
    }

    method hayLugar(){
      return capacidad > self.tripulantes().length()
    }
    method cambiarDeMision(nuevaMision){
        mision = nuevaMision
        tripulantes = tripulantes.filter({tripulante => nuevaMision.tripulanteUtil(tripulante)})
      
    }

    method itemMasRaro(){ 
      const todosLosItems = tripulantes.flatMap({ tripulante => tripulante.items() })
      return todosLosItems.min({ item => todosLosItems.count({ it => it == item }) })
    }

    method anclarEnCiudadCostera(ciudad){
      tripulantes.forEach({tripulante => tripulante.beberGrogXDen(ciudad)})
      const elMasEbrio = tripulantes.max({tripulante => tripulante.nivelEbriedad()})
      tripulantes.remove(elMasEbrio)
      ciudad.aumentarPoblacion(1)
    }
}

class Pirata{
    var property items  
    var nivelEbriedad
    var dinero

    method pasadoDeGrogXD(){
      return nivelEbriedad>=90 && items.contains("botella de grogXD")
    }

    method puedeSerTripulante(barco){
      return barco.tripulantes().length()<barco.capacidad() && barco.mision().tripulanteUtil(self)
    }

    method puedeRealizarMision(mision){
      return mision.tripulanteUtil(self)
    }

    method seAnimaASaquear(victima){ // siento que deberia ir aca
      return victima.condicionSaqueo(self)
    }

    method beberGrogXDen(ciudad){
      if(dinero>=ciudad.precio()){
        dinero-=ciudad.precio()
        nivelEbriedad+=5
      }
      else self.error("No puede pagarlo")
    }
}

class Espia inherits Pirata{
  override method pasadoDeGrogXD() = false
  
  override method seAnimaASaquear(victima){
    return super(victima) && items.contains("permiso de la corona")
  }
}

class Mision{
    method puedeSerRealizadaPor(barco) {
      const cantidadDeTripulantes = barco.tripulantes().lenght()
      return cantidadDeTripulantes.between(barco.capacidad()*0.9, barco.capacidad())
    }
}

class BusquedaDelTesoro inherits Mision{
    method tripulanteUtil(pirata){
      const itemsDelPirata = pirata.items()
      const itemsBuscados = ["brújula", "mapa", "botella de grogXD "]
        
      return itemsBuscados.any({item => itemsDelPirata.contains(item)}) and pirata.dinero()<=5
    }
    override method puedeSerRealizadaPor(barco){
      super(barco)
      return barco.tripulantes().any({tripulante=> tripulante.items().contains("llave de cofre")})
    }
}

class ConvertirseEnLeyenda inherits Mision{
    const itemObligatorio
    method tripulanteUtil(pirata){
        const itemsPirata = pirata.items()

        return itemsPirata.length()>=10 and itemsPirata.contains(itemObligatorio)
    }
}

class Saqueo inherits Mision{
    const victima
    var property dineroLimite

    method tripulanteUtil(pirata){
      return pirata.dinero()<dineroLimite and pirata.seAnimaASaquear()
    }
    override method puedeSerRealizadaPor(barco){
        super(barco)
        return victima.vulnerableA(barco)
    }
} 

class CiudadCostera{
    var property cantidadHabitantes
    const property precio // en el resuelto esta como const property pero no se bien porque
    method condicionSaqueo(pirata){
      pirata.nivelEbriedad()>=50
    }
    method esVulnerableA(barco){
      return barco.tripulantes().length()>= cantidadHabitantes*0.4 || 
      barco.tripulantes().all({tripulante => tripulante.pasadoDeGrogXD()}) // podria haber delegado
    }
    method aumentarPoblacion(cantidad){
      cantidadHabitantes+=cantidad
    }
}