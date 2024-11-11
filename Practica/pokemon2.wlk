class Movimiento{
    var cantidadUsos
    method poder()

    method usoDeMovimiento(){
        cantidadUsos-=1
        cantidadUsos.max(0)
    }

    method puedeUsarMovimiento(){
        return cantidadUsos>0
    }
    method aplicarMovimiento(lanzador,oponente){
        if(!self.puedeUsarMovimiento()){
            throw new MovimientoException(message = "No tiene mas usos")
        }
        self.efectoMovimiento(lanzador,oponente)
        self.usoDeMovimiento()
    }

    method efectoMovimiento(lanzador,oponente)
}

class MovimientoCurativo inherits Movimiento{
    const puntosCurativos

    override method poder() = puntosCurativos

    override method efectoMovimiento(lanzador,oponente){
        lanzador.modificarVida(puntosCurativos)
    }
}

class MovimiendoDanino inherits Movimiento{
    const puntosDanio

    override method poder() = 2*puntosDanio

    override method efectoMovimiento(lanzador,oponente){
        oponente.modificarVida(-puntosDanio)
    }
}

class MovimientoEspecial inherits Movimiento{
    const condicionEspecial

    override method poder() = condicionEspecial.poder()
    method condicionPermiteMovimiento() = condicionEspecial.puedeMoverse()
    method puedeMoverse() =  0.randomUpTo(2).roundUp().even()
    override method efectoMovimiento(lanzador,oponente){
        oponente.condicionEspecial(condicionEspecial)
    }

}
object suenio{
    method poder() = 50
    method puedeMoverse() =  0.randomUpTo(2).roundUp().even()
}

object paralisis{
    method poder() = 50
    method puedeMoverse() =  0.randomUpTo(2).roundUp().even()
}

object normal{}

class Pokemon {
    const vidaMaxima
    var vida
    const movimientos
    var property condicionEspecial = normal

    method grositud() = vidaMaxima* movimientos.sum({movimiento => movimiento.poder()})

    method estaVivo() = vida>0
    method modificarVida(puntos){
        vida+=puntos
        vida.max(0).min(vidaMaxima)
    }
    
    method usarMovimiento(oponente){
        const movimientoAUsar = movimientos.findOrElse({movimiento => movimiento.puedeUsarMovimiento()},
        throw new SinMovimientosException (message = "No tiene mas movimientos"))
        movimientoAUsar.aplicarMovimiento(self, oponente)
    }
}

// exceptions
class MovimientoException inherits DomainException{}
class SinMovimientosException inherits DomainException{}