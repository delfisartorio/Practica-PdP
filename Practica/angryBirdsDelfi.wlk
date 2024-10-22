class Pajaro{
    var ira = 1

    method enojarse() { 
        ira=ira*2}

    method fuerza(){
        return ira*2
    }
}

class PajaroReencoroso inherits Pajaro{
    var contadorEnojos = 0

    override method enojarse(){
      super()
      contadorEnojos+=1
    }
}

object red inherits PajaroReencoroso{
    override method fuerza() = ira * 10 * contadorEnojos
}

object bomb inherits Pajaro {
    var fuerzaMax = 9000

    override method fuerza() = super().min(fuerzaMax)    
}

object chuck inherits Pajaro{
    var velocidadVuelo =10

  override method fuerza() {
    if (velocidadVuelo <= 80)
    {
        return 150
    }
    return 150 + 5 * (velocidadVuelo - 80)
  }

    override method enojarse(){
        velocidadVuelo*=2
    }
}

object terence inherits PajaroReencoroso{
    var multiplicador = 1

    override method fuerza(){
        return ira*multiplicador*contadorEnojos
    }
}

object matilda inherits Pajaro{
    var huevos = #{}

    method fuerzaHuevos(){
        return huevos.map({huevo=>huevo.fuerza()}).sum()
    }
    override method fuerza(){
        return super() + self.fuerzaHuevos()
    }
    override method enojarse(){
        const huevo = new Huevo(fuerza=1, peso=2)
        huevos.add(huevo)
    }
}

class Huevo{
    var fuerza
    var peso
}

object isla{
    var pajarosDeLaIsla = [red,bomb,chuck,terence,matilda]

    method pajarosMasFuertes(){
        const losFuertes = pajarosDeLaIsla.filter({pajaro=> pajaro.fuerza()>50})
        return losFuertes
    }
    method fuerzaDeLaIsla(){
        const losFuertes = pajarosDeLaIsla.pajarosMasFuertes()
        return losFuertes.map({pajaro => pajaro.fuerza()}).sum()
    }
}