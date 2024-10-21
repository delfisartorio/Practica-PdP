/////////////////////////
//////// PIRATAS ////////
/////////////////////////
class Pirata {
  // 1
  const property items = [] // mapa , brujula, loro, cuchillo, botella de grogXD
  var property nivelEbriedad
  var property monedas = 0 // la cantidad de monedas es el dinero de un pirata

  // 3
  method tieneItem (item) = items.contains(item)
  method cantidadItems() = self.items().size()

  method seAnimaASaquear(objetivo) = objetivo.pirataSeAnimaASaquear(self)
  method pasadoDeGrogXD() = nivelEbriedad >= 90 && self.tieneItem("botellaDeGrog")

  // 5
  method puedePagarTrago(ciudadCostera) = monedas >= ciudadCostera.valorDelTrago()
  method tomarTrago(ciudadCostera) {
    if(not self.puedePagarTrago(ciudadCostera))
        self.error("No tiene sufente modedas para pagar el trago")
        
    nivelEbriedad += 5
    monedas -= ciudadCostera.cuantoSaleElTrago()
  }

}

//////////////////////////
//////// MISIONES ////////
//////////////////////////
class Mision {
  // 1
  method esUtil(pirata)

  // 3
  method puedeRealizarMision(barco) = barco.tieneSuficienteTripulacion() && self.cumpleRequisitos(barco)
		
  method cumpleRequisitos(barco) = true

}

class BusquedaDelTesoro inherits Mision {
  // 1
  // los piratas que tengan una brujula, un mapa y una botella de grogXD y no tengas mas de 5 monedas
  override method esUtil(pirata) = ["brujula", "mapa", "botellaDeGrog"].any {item => pirata.tieneItem(item)} 
    && pirata.monedas() <= 5

  // 3
  override method cumpleRequisitos(barco) = barco.alguienTiene("llaveDeCofre")
}

class ConvertirseEnLeyenda inherits Mision {
    // 1
    const property itemObligatorio 
    // tener al menos 10 items y tener un item obligatorio
    override method esUtil(pirata) = pirata.cantidadItems() >= 10 && pirata.tieneItem(itemObligatorio)
}

class Saqueo inherits Mision {
    // 1
    const property objetivo // es la victima: un barco o una ciudad costera
    const property cantidadMonedasMinimo = 0
    override method esUtil(pirata) = pirata.monedas() > cantidadMonedasMinimo 
        && pirata.seAnimaASaquear(objetivo)

    // 3
    override method cumpleRequisitos(barco) = objetivo.esVulnerableA(barco)
}


//////////////////////////////////////
//////// OBJETIVOS O VICTIMAS ////////
//////////////////////////////////////
class NoSePudoAgregarElPirata inherits DomainException {}

class BarcoPirata {
    const property capacidad 
    var property mision
    const property tripulacion = #{}

    // 2A
    method pirataSeAnimaASaquear(pirata) = pirata.pasadoDeGrogXD()
    method pirataPuedeFormarParte(pirata) = self.hayLugarParaUnoMas() 
        && mision.esUtil(pirata)
    
    method hayLugarParaUnoMas() = capacidad > self.cantidadTripulantes()
    method cantidadTripulantes() = tripulacion.size()

    // 2B
    method incorporarATripulacion(pirata) {
        if (not self.pirataPuedeFormarParte(pirata)){
            self.error("No se pudo agregar el pirata")
        }
        tripulacion.add(pirata)
    }

    // 2C
    method mision(nuevaMision){
        mision = nuevaMision
        const piratasQueNoSirven = tripulacion.filter({pirata => not nuevaMision.esUtil(pirata)})
        tripulacion.removeAll(piratasQueNoSirven)
 	}

    // 3 - saber si el barco es temible
    method esTemible() = mision.puedeRealizarMision(self) && self.cantidadTripulantesUtiles() >= 5

    method cantidadTripulantesUtiles() = tripulacion.filter {pirata => mision.esUtil(pirata)}.size()

    method tieneSuficienteTripulacion() = self.cantidadTripulantes() >= capacidad * 0.9

    method alguienTiene(item) = self.tripulacion().any {pirata => pirata.tieneItem(item)}

    method esVulnerableA(otroBarco) = otroBarco.cantidadTripulantes() /2 >= self.cantidadTripulantes()

    method estanPasadosDeGrogXD() = tripulacion.all {pirata => pirata.pasadoDeGrogXD()}

    // 4 - item mas raro es el que menos piratas lo tienen dentro de la tripulacion
    method itemMasRaro() {
        const todosLosItems = tripulacion.flatMap {pirata => pirata.items().asSet()}
        return todosLosItems.min {item => tripulacion.count {pirata => pirata.tieneItem(item)} }
    }

    // 5 - aclar en ciudad costera
    method anclarEn(ciudadCostera) {
        const piratasQuePuedenTomar = tripulacion.filter({pirata => pirata.puedePagarTrago(ciudadCostera)})
        piratasQuePuedenTomar.forEach {pirata => pirata.tomarTrago("grogXD")}

		tripulacion.remove(self.elMasEbrio())
		ciudadCostera.sumarHabitanteMasEbrio()
    }
    method elMasEbrio() = tripulacion.max {pirata => pirata.nivelEbriedad()}
}

class CiudadCostera {
    var property cantidadHabitantes
    const property valorDelTrago

    // 2A
    method pirataSeAnimaASaquear(pirata) = pirata.nivelEbriedad() >= 50

    // 3
    method esVulnerableA(barco) = barco.cantidadTripulantes() >= 0.4 * self.cantidadHabitantes() ||
        barco.estanPasadosDeGrogXD()

    // 5
    method sumarHabitanteMasEbrio() { // sumamos al habitante que se queda de la tripulacion por ser el mas ebrio
      cantidadHabitantes += 1 
    }
}

////////////////////////////////////
//////// TRIPULANTES ESPIAS ////////  punto 6
////////////////////////////////////
class TripulanteEspia inherits Pirata {
    // nunca estan pasados de Grog
    override method pasadoDeGrogXD() = false
    // se animan a saquear a la victima si ademas de las condiciones anteriores tiene el item "permiso de la corona"
	override method seAnimaASaquear(victima) = super(victima) && self.tieneItem("permiso de la corona")
}