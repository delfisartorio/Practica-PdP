class Pokemon {
  var vida
  const vidaMaxima
  const movimientos = #{}
  var property condicionEspecial = normal
  
  method validarQueEstaVivo() {
    if (vida == 0) {
      throw new NoPuedeMoverseException(message = "El pokemon no está vivo")
    }
  }
  
  method movimientoDisponible() = movimientos.findOrElse(
    { movimiento => movimiento.estaDisponible() },
    { throw new NoPuedeMoverseException(
        message = "No tiene movimientos disponibles"
      ) }
  )
  
  method sumaDePoder() = movimientos.map({ movimiento => movimiento.poder() }).sum()
  
  method grositud() = vidaMaxima * movimientos.sumaDePoder()
  
  method usarMovimiento(contrincante) {
    self.validarQueEstaVivo()
    contrincante.validarQueEstaVivo()
    
    const movimientoAUsar = self.movimientoDisponible()
   
    condicionEspecial.intentaMoverse(self)
    movimientoAUsar.usarEntre(self, contrincante)
  }
  
  method curar(puntosDeSalud) {
    vida = (vida + puntosDeSalud).min(vidaMaxima)
  }
  
  method recibirDanio(danio) {
    vida = 0.max(vida - danio)
  }
  
  method estaImposibilitado() = 0.randomUpTo(2).roundUp().even()

  method normalizar(){
 		condicionEspecial = normal
 	}
}

 class Movimiento {
 	var usosPendientes = 0
 	method usarEntre(usuario, contrincante){
 		if(! self.estaDisponible())
 			throw new CantidadDeUsosException (message = "El movimiento no está disponible")
 		usosPendientes -= 1 
 		self.afectarPokemones(usuario, contrincante)
 	}
 	method estaDisponible() = usosPendientes > 0
	method afectarPokemones(usuario, contrincante)
 }
 class MovimientoCurativo inherits Movimiento {
 	const puntosDeSalud
	method poder() = puntosDeSalud
	override method afectarPokemones(usuario, contrincante){
		usuario.curar(puntosDeSalud)
	}
 }
 
 class MovimientoDanino inherits Movimiento {
 	const danioQueProduce
 	method poder() = 2 * danioQueProduce
 	override method afectarPokemones(usuario, contrincante){
		contrincante.recibirDanio(danioQueProduce)
	}
 }

class MovimientoEspecial inherits Movimiento {
  const efectoQueProvoca
  
  method poder() = efectoQueProvoca.poder()
  
  override method afectarPokemones(usuario, contrincante){
		contrincante.condicionEspecial(efectoQueProvoca)}
}
class CondicionEspecial {
	method intentaMoverse(pokemon){
		if(! self.lograMoverse())
			throw new NoPuedeMoverseException(message = "El pokemon no pudo moverse")
	}
	
	method lograMoverse() = 0.randomUpTo(2).roundUp().even()
	
	method poder()
}

object normal {
  const property poder = 0
  
  method estaImposibilitado() = false
}

object paralisis inherits CondicionEspecial {
  const property poder = 30
}

object suenio inherits CondicionEspecial{
  const property poder = 50
  
  override method intentaMoverse(pokemon){
		super(pokemon)
		pokemon.normalizar()
	}
}

class CantidadDeUsosException inherits DomainException {
  
}
class NoPuedeMoverseException inherits Exception {}