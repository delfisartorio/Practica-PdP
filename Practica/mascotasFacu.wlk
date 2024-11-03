//  FAMILIAS //
class Familia {
    const personas = []
    const mascotas = []
    const familia = personas + mascotas // concatenacion de colecciones
    const tamanioCasa

    method ocupanPersonas() = personas.sum{ persona => persona.tamanioPersona() } 
    method ocupanMascotas() = mascotas.sum{ mascota => mascota.tamanioAnimal() } 

    method lugarDisponible() = tamanioCasa - self.ocupanPersonas() - self.ocupanMascotas()

    // punto 1A: familia.tieneLugarParaUnAnimal(animal)
    method tieneLugarParaUnAnimal(animal) = self.lugarDisponible() > animal.tamanioAnimal() 

    // punto 1B: familia.alguienTieneProblemasConAnimal(animalProblematico)
    method alguienTieneProblemasConAnimal(animalProblematico) = 
        familia.any{personaOMascota => personaOMascota.tieneProblemasConAnimal(animalProblematico)} 

    // punto 1C: familia.puedeAdoptarUnAnimal(animal)
    method puedeAdoptarUnAnimal(animal) = 
        self.lugarDisponible() > animal.tamanioAnimal() && not self.alguienTieneProblemasConAnimal(animal)

    // Extras del punto 2
    method hayAlMenosUnMenor() = personas.any{persona => persona.edad() < 18} 
    method noTieneMascota() = mascotas.isEmpty()

    method puedeAdoptarACualquiera() = 
        veterinaria.animalesEnAdopcion.all{animal => self.puedeAdoptarUnAnimal(animal)} 

    // punto 3: familia.adoptar(animal)
    method adoptar(animal) {
        if (not self.puedeAdoptarUnAnimal(animal)) {
            throw new NoPuedeAdoptarAAnimal(message = "No se puede adoptar a este animal")
        } else {
            mascotas.add(animal)
            veterinaria.animalAdoptado(animal)
        }
    }
}

//  PERSONAS DE LA FAMILIA //
class Persona {
    var property edad
    // var animalQueNoLeCaeBien = []   // animalQueNoLeCaeBien.add(new ...)
    method edad() = edad

    method tamanioPersona() {
        if (edad >= 13) {
            return 1
        } else {
            return 0.75
        }
    }

    method tieneProblemasConAnimal(animal) = animal.noLeCaeBien() || self.esAlegica(animal)

    method esAlegica(animal) = animal.esPeludo()

}

//  ANIMALES //
class Animal {
    // var property tipo // perro, gato, pez
    // composicion no es porque un perro no se puede convertir en un gato
    // entonces uso herencia
    const property nombre

    method tieneProblemasConAnimal(animalProblematico) = 
        animalProblematico.esAgresivo(self) || animalProblematico.esMalaOnda(self)

}

// PERRO
class Perro inherits Animal {
    var property tipo // chico, grande, nuevo: salvaje

    method tamanioAnimal() = tipo.tamanioPerro()
}

object perroChico {
    var property tamanioPerro = 0.5

    method tamanioPerro() = tamanioPerro

    method esAgresivo(animal) = animal.tamanioAnimal() > tamanioPerro
}

class PerroGrande {
    var property raza 
    method tamanioPerro() = raza.tamanio()

    method esAgresivo(animal) = animal.tamanioAnimal().between(0.5, self.tamanioPerro())
}

class PerroSalvaje inherits Perro {   // punto 4
    method esPeludo() = true // revisar esto
    override method tamanioAnimal() = super() / 2
}

class Raza {
    var property raza
    const tamanio

    method tamanio() = tamanio

    method esPeludo() = true // revisar esto
}

// GATO
class Gato inherits Animal  {
    
    method tamanioAnimal() = 0.5

    method esPeludo() = true // revisar esto 

    method esMalaOnda(animal) = true // revisar esto
}

// PEZ
class PezDorado inherits Animal  {

    method tamanioAnimal() = 0
}

//  VETERINARIAS //
object veterinaria {
    const familias = []
    const animalesEnAdopcion = []

    // punto 2A: veterinaria.familiasConMenoresSinMascota()
    method familiasConMenoresSinMascota() = 
        familias.count{familia => familia.hayAlMenosUnMenor() && familia.noTieneMascota()}
    
    // punto 2B: veterinaria.animalesQueNoPuedenSerAdoptados
    method animalesQueNoPuedenSerAdoptados() {
        const animalesNoAdoptados = animalesEnAdopcion.filter{animal => self.ningunaFamiliaLoPuedeAdoptar(animal)}
        return animalesNoAdoptados.nombre()
    } 
        
    method ningunaFamiliaLoPuedeAdoptar(animal) = 
        familias.all{familia => not familia.puedeAdoptarUnAnimal(animal)
    }

    // punto 2C: veterinaria.familiasQuePudenAdoptarACualquiera()
    method familiasQuePudenAdoptarACualquiera() = familias.filter{familia => familia.puedeAdoptarACualquiera()}

    // extra punto 3
    method animalAdoptado(animal) = animalesEnAdopcion.remove(animal)
}

// EXCEPTIONS //
class NoPuedeAdoptarAAnimal inherits DomainException {}