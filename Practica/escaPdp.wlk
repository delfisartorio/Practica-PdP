class SalaDeEscape {
  const nombre
  const nivelDificultad
  
  method precio() = 10000
  
  method esDificil() = nivelDificultad > 7
}

class SalaAnime inherits SalaDeEscape {
  override method precio() = super() + 7000
}

class SalaHistoria inherits SalaDeEscape {
  const basadaEnHechosReales
  
  override method precio() = super() + (nivelDificultad * 0.314)
  
  override method esDificil() = basadaEnHechosReales
}

class SalaTerror inherits SalaDeEscape {
  const cantidadDeSustos
  
  override method precio() {
    if (cantidadDeSustos > 5) {
      return super() + (cantidadDeSustos * 0.2)
    }
    return super()
  }
  
  override method esDificil() = super() || (cantidadDeSustos > 5)
}

class Escapista {
  var property maestria
  const salasDeLasQueSalio
  var saldo
  
  method hizoMuchasSalas() = salasDeLasQueSalio.size()

  method subirMaestria(){
    maestria.siguienteNivel()
  }
  method nombreDeLasSalasQueSalio(){
    const nombres = salasDeLasQueSalio.asSet().map({sala => sala.nombre()})
    return nombres
  }
  method puedeEscapar(){
    maestria.puedeEscapar()
  }
  method puedePagar(precio) = saldo>=precio
  method pagar(precio) {
    saldo-=precio
  }
  
}

object profesional {
  method puedeEscapar(escapista, sala) = true
  method subirDeNivel(escapista){
    throw new MaestriaException (message = "No puede subir de maestria")
  }
}

object amateur {
  method puedeEscapar(escapista,sala) = (!sala.esDificil()) && escapista.hizoMuchasSalas()
  method subirDeNivel(escapista){
    if (escapista.hizoMuchasSalas()){
        escapista.maestria(profesional)
    }
  }
}

class MaestriaException inherits DomainException{}
class SinSaldoException inherits DomainException{}

class Grupo{
    const escapistas
    method puedeEscapar(sala) = escapistas.any({integrante => integrante.puedeEscapar()})
    method losQuePuedenPagar(sala){
        const precio = sala.precio()/escapistas.size()
      return escapistas.filter({escapista => escapista.puedePagar(precio)})
    }
    
    method puedenPagar(sala){
      const precio = sala.precio()
      const precioCU = precio/escapistas.size()
      const plataDelGrupo = escapistas.losQuePuedenPagar().map({escapista => escapista.saldo()}).sum()
      return plataDelGrupo>precio || escapistas.all({escapista => escapista.puedePagar(precioCU)})
    }
    method pagar(sala){
      const precioCU = sala.precio()/escapistas.size()
      if(escapistas.puedenPagar(sala)){
        escapistas.forEach({integrante => integrante.pagar(precioCU)})
        }
        throw new SinSaldoException (message = "No tienen suficiente dinero")
    }

    method escapar(sala){
      if(self.puedenPagar(sala) and self.puedeEscapar(sala)){
        self.pagar(sala)
        escapistas.forEach({escapista => escapista.salasDeLasQueSalio().add(sala)})
      }
    }
}