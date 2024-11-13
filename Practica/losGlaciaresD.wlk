class Tempano {
    var property pesoTotal

    method esGrande() = pesoTotal>=500
    method parteVisible() = pesoTotal*0.15
    method esAzul()= self.parteVisible()>100
    method poderDeEnfriamiento() = pesoTotal/100
}

class TempanoAireado inherits Tempano{
    override method esAzul() = false
    override method poderDeEnfriamiento() = 0.5
}

class MasaDeAgua{
    const tempanosFlotando = #{}
    var temperaturaDelAmbiente

    method cantidadDeTempanos() = tempanosFlotando.size()
    method esAtractiva(){
        self.cantidadDeTempanos()>5 && tempanosFlotando.all({tempano => tempano.esGrande() || tempano.esAzul()})
    }
    method temperaturaTempanos() = tempanosFlotando.sum({tempano=>tempano.poderDeEnfriamiento()})
    method temperatura() = temperaturaDelAmbiente - self.temperaturaTempanos()
    method agregarTempano(tempano){
      tempanosFlotando.add(tempano)
    }
}

class Rio inherits MasaDeAgua{
    const velocidadBase
    override method temperatura() = super() + velocidadBase - self.glaciaresGrandes()
    method glaciaresGrandes() = tempanosFlotando.filter({tempano => tempano.esGrande()}).size()
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
      const tempano = new Tempano(pesoTotal = pesoNuevoTempano)
      self.perderMasa(pesoNuevoTempano)
      desembocadura.agregarTempano(tempano)
    }
}

class Embarcacion {
  const tamanio
  const fuerzaMotor
}