class Chico {
    const elementos = #{}
    const actitud // dice que va del 1 al 10 pero no se si tengo que poner algun between
    var caramelos
    
    method cantidadDeCaramelos() = caramelos
    method sumaDeDelSusto() = elementos.sum({elemento => elemento.asusta()})
    method capacidadDeAsustar() = self.capacidadDeAsustar() * actitud
    method recibirCaramelos(nuevosCaramelos) {
        caramelos+= nuevosCaramelos
    }
}


object maquillaje {
    var property asusta = 3
}

class Traje{
    method asusta()
}

class TrajeTierno inherits Traje{
  override method asusta()= 2 
}

class TrajeTerrorifico inherits Traje{
  override method asusta()= 5
}

class Adulto{ // supongo que tienen caramelos infinitos
    const chicosQueIntentaronAsustarlo

    method agregarChicoALaListaDeIntentos(chico){
      chicosQueIntentaronAsustarlo.add(chico)
    }
    method tolerancia() {
      const chicosConMasDe15Caramelos = chicosQueIntentaronAsustarlo.filter({chico => chico.cantidadDeCaramelos()>15})
      return chicosConMasDe15Caramelos.size() * 10
    }

    method caramelosQueEntrega() = self.tolerancia()/2 
    method darCaramelos(chico){
        if(self.seAsustaPor(chico)){
            chico.recibirCaramelos(self.caramelosQueEntrega())
        }
    }

    method seAsustaPor(chico) = chico.capacidadDeAsustar()>self.tolerancia()
}
class Abuelo inherits Adulto {
    override method seAsustaPor(chico) = true
    override method caramelosQueEntrega() = super()/2

}