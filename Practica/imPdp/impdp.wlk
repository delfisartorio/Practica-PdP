object imPdP{
    var property artistas =#{}
    var property peliculas = #{}

    method agregarPelicula(pelicula){
        peliculas.add(pelicula)
        artistas.add(pelicula.artistas()) // considero artistas solo a los que hayan actuado en alguna peli
    } 
    method artistaMejorPago(){
        const mejorPago = artistas.max({artista => artista.sueldo()})
        return mejorPago
    }

    method peliculasEconomicas(){
      return peliculas.filter({pelicula => pelicula.presupuesto()<500000})
    }
    method nombrePeliculasEconomicas(){
      const economicas = self.peliculasEconomicas()
      return economicas.map({pelicula => pelicula.nombre()})
    }
    method gananciaPeliculasEconomicas() {
      const ganancias = self.peliculasEconomicas().map({pelicula => pelicula.ganancias()})
      return ganancias.sum()
    }
    method recategorizar(artista){
        artista.recategorizar()
    }
}

class Pelicula {
  const property nombre
  const property elenco = #{}

  method presupuesto(){
    const sueldoElenco = elenco.map({artista => artista.sueldo()}).sum()
    return sueldoElenco*1.7
  }
  method ganancias() {
    return self.recaudo()-self.presupuesto()
  }
  method recaudo(){
    return 1000000 + self.recaudoExtra()
  }
  method recaudoExtra()

  method rodarPelicula(){
    elenco.forEach({artista => artista.actuar()})
  } 
}

class GeneroDrama inherits Pelicula{
    override method recaudoExtra(){
        const cantidadLetras = nombre.length()
        return 100000*cantidadLetras
    }
}
class GeneroAccion inherits Pelicula{
    const vidriosRotos
    override method recaudoExtra(){
        const cantidadArtistasElenco = elenco.length()
        return 50000*cantidadArtistasElenco
    }
    override method presupuesto(){
      return super() + 1000*vidriosRotos
    }
}
class GeneroTerror inherits Pelicula{
    const cantidadDeCuchos
    override method recaudoExtra(){
      return 20000*cantidadDeCuchos
    }
}
class GeneroComedia inherits Pelicula{
    override method recaudoExtra(){
      return 0
    }
}

class Artista{
    var peliculasActuadas
    var ahorros
    var experiencia
    
    method nivelDeFama(){
      return peliculasActuadas/2
    }

    method sueldo(){
      if(experiencia=="amateur"){
        return 10000
      } else if(experiencia == "establecido"){
        if(self.nivelDeFama()<15){
            return 15000
        }
        else{
            return 5000*self.nivelDeFama()
        }
      }
      else{ //estoy programando no APB, supongo q el usuario solo ingresa amateur, establecido y estrella
        return 30000*peliculasActuadas
      }
    } 
    method recategorizar(){
      if(experiencia == "amateur" and peliculasActuadas>=10){
        experiencia = "establecido"
      } else if(experiencia == "establecido" && self.nivelDeFama()>=10){
        experiencia = "estrella"
      } else if(experiencia == "establecido"){
        self.error("No puede ser recateforizado, ya es estrella⭐")
      }else{
        self.error("No esta en condiciones de recategorizarse")
      }
    } 

    method actuar(){
        peliculasActuadas+=1
        ahorros += self.sueldo()
    }
}