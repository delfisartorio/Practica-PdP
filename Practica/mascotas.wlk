object veterinaria {
  const familiasInscriptas = #{}
  const animalesDisponibles = #{}

  method familiasConMenoresSinMascotas(){
    const familias = familiasInscriptas.filter({familia => familia.any({integrante => integrante.esMenorDeEdad()}) && familia.noTieneMascotas()})
    return familias.size()
  }
  method animalesDesamparados(){
    animalesDisponibles.filter({animal => !familiasInscriptas.any({familia=>familia.puedeAdoptar(animal)})})
  }
  method familiasBondadosas() = familiasInscriptas.filter({familia => animalesDisponibles.all({animal => animal.puedeSerAdoptadoPor(familia)})})

  method adoptar(animal,familia){ // obvio el hecho de que el animal tiene que estar en el set y no puede ser uno x
    if(familia.puedeAdoptar(animal)){
        familia.mascotasQueTienen().add(animal)
        animalesDisponibles.remove(animal)
    } throw new AdopcionException(message = "No se pudo concretar la adopcion")
  }
}

class Familia {
  const integrantes = #{}
  const mascotasQueTienen = #{}
  const tamanioDeLaCasa
  
  method espacioDisponible() {
    const espacioIntegrantes = integrantes.sum({ integrante => integrante.tamanoQueOcupa()})
    const espacioMascotas = mascotasQueTienen.sum({mascota => mascota.tamanoQueOcupa()})
    return 0.max(tamanioDeLaCasa - espacioIntegrantes - espacioMascotas)
  }
  
  method tieneLugarPara(animal) = (self.espacioDisponible() - animal.tamanoQueOcupa()) > 0
  method algunoTieneProblemasCon(animal) = integrantes.any({integrante => integrante.tieneProblemasCon(animal)}) 
                                            || mascotasQueTienen.any({mascota => mascota.tieneProblemasCon(animal)}) 

  method puedeAdoptar(animal) = self.tieneLugarPara(animal) && !self.algunoTieneProblemasCon(animal)

  method noTieneMascotas() = mascotasQueTienen.size() == 0
}

class Persona {
  const edad
  const esAlergica
  const animalesQueOdia
  
  method tamanoQueOcupa() {
    if (edad >= 13) {
      return 1
    }
    return 0.75
  }
  
  method tieneProblemasCon(animal) {
    animalesQueOdia.any({ unAnimal => unAnimal.nombre() == animal.nombre() }) || (esAlergica && animal.esPeludo())
  }
  method esMenorDeEdad() = edad<18
}

class Animal {
  const nombre
  method tieneProblemasCon(animal)
  method tamanoQueOcupa()
  
  method esPeludo()
  method puedeSerAdoptadoPor(familia) = familia.puedeAdoptar(self)
}

class Gato inherits Animal {
  const property esMalaOnda

  override method tamanoQueOcupa() = 1
  override method esPeludo() = true
  override method tieneProblemasCon(animal) = self.esMalaOnda()

}

class Perro inherits Animal {
  const raza
  override method esPeludo()= raza.esPeludo()
  override method tamanoQueOcupa() = raza.tamanoQueOcupa()
  
  override method tieneProblemasCon(animal)= raza.tieneProblemasCon(animal)
}

class PezDorado inherits Animal {
  override method tamanoQueOcupa() = 0
  override method esPeludo() = false
  override method tieneProblemasCon(animal)= false
}

class PerroSalvaje inherits Perro{
    override method esPeludo() = true
    override method tamanoQueOcupa() = super()*2
}

class Raza {
  const property esAgresivo
  const property esPeludo
  
  method tamanoQueOcupa()
}

class PerroRazaChica inherits Raza {
  override method tamanoQueOcupa() = 0.5
  
  method tieneProblemasCon(animal) {
    self.esAgresivo() && (animal.tamanoQueOcupa() > self.tamanoQueOcupa())
  }
}

class PerroRazaGrande inherits Raza {
  const tamanoQueOcupa
  
  override method tamanoQueOcupa() = tamanoQueOcupa
  
  method tieneProblemasCon(animal) {
    self.esAgresivo() && animal.tamanoQueOcupa().between(0.5,self.tamanoQueOcupa())
  }
}

// EXCEPTIONS

class AdopcionException inherits DomainException{}