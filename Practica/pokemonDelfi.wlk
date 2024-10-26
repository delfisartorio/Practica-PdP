class Pokemon{
    var property vida 
    const vidaMaxima 
    var movimientos = #{}

    method aumentarVida(numero){
      vida += numero.max(vidaMaxima)
    }
    method curar(movimientoCurativo){
        movimientoCurativo.sanar(self)
    }
}

class MovimientoCurativo{
    const vidaACurar

    method sanar(unPokemon){
        unPokemon.aumentarVida(vidaACurar)
    }
}