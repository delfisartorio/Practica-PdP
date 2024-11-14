class Tempano {
    var property pesoTotal
    var tipoDeTempano

    method esGrande() = pesoTotal>=500
    method parteVisible() = pesoTotal*0.15
    method esAzul()= tipoDeTempano.esAzul(self)
    method poderDeEnfriamiento() = tipoDeTempano.poderDeEnfriamiento(self)
    method cambioDeEstado(estadoNuevo){ tipoDeTempano = estadoNuevo}  
    method perderMasa(valor) {
      pesoTotal = 0.max(pesoTotal-valor)
    } 
}

object tempanoAireado {
   method esAzul(tempano) = false
   method poderDeEnfriamiento(tempano) = 0.5
}
object tempanoCompacto{
  method esAzul(tempano)= tempano.parteVisible()>100
  method poderDeEnfriamiento(tempano) = tempano.pesoTotal()/100

}

class MasaDeAgua{
    const tempanosFlotando = #{}
    const temperaturaDelAmbiente

    method cantidadDeTempanos() = tempanosFlotando.size()
    method esAtractiva(){
        self.cantidadDeTempanos()>5 && tempanosFlotando.all({tempano => tempano.esGrande() || tempano.esAzul()})
    }
    method temperaturaTempanos() = tempanosFlotando.sum({tempano=>tempano.poderDeEnfriamiento()})
    method temperatura() = temperaturaDelAmbiente - self.temperaturaTempanos()
    method agregarTempano(tempano){
      tempanosFlotando.add(tempano)
    }
    method permiteNavegacion(barco)
    method serNavegadoPor(barco){
      tempanosFlotando.forEach({tempano => tempano.perderMasa(1)})
      tempanosFlotando.filter({tempano=>!tempano.esGrande()}).forEach({tempano=> tempano.cambiarEstado(tempanoAireado)})
    }
}

class Lago inherits MasaDeAgua{
  override method permiteNavegacion(barco){
    tempanosFlotando.size({tempano => tempano.esGrande()}) && barco.tamanio()<10 && self.temperatura()>0
  }
}

class Rio inherits MasaDeAgua{
    const velocidadBase
    method velocidad() = velocidadBase - self.glaciaresGrandes()
    override method temperatura() = super() + self.velocidad()
    method glaciaresGrandes() = tempanosFlotando.filter({tempano => tempano.esGrande()}).size()
    override method permiteNavegacion(barco){
      barco.fuerzaMotor()<self.velocidad()
    }
}


class Glaciar{
    const desembocadura
    var masa

    method agregarTempano(tempano){
      masa += tempano.pesoTotal()
    }
    method perderMasa(valor){
        masa = 0.max(masa-valor)
    }
    method temperatura() = 1
    method pesoInicialDelTempanoDesprendido() = masa/1000000 * desembocadura.temperatura()
    method desprendimiento(){
      const pesoNuevoTempano = self.pesoInicialDelTempanoDesprendido()
      const tempano = new Tempano(pesoTotal = pesoNuevoTempano, tipoDeTempano= tempanoCompacto)
      self.perderMasa(pesoNuevoTempano)
      desembocadura.agregarTempano(tempano)
    }
}

class Embarcacion {
  const tamanio
  const property fuerzaMotor

  method navegar()
}