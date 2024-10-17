class Vaca {
    var property peso
    var property sed 

    method comer(comida){ // en kg
        peso+= comida/3
        sed = true
    }
    method beber() {
      sed = false
      peso -= 0.5
    }
    method hambriento() {
        peso<200
    }
    method caminar(){
        peso-=3
    }
}

class Cerdo{
    var property peso
    var property sed
    var property hambriento = true 
    var contadorComidas=0
    const vacunar = true

    method comer(comida){
        if (comida > 0.2) {
            peso += comida - 0.2
            contadorComidas += 1
            if (comida > 1) {
                hambriento = false
            }
            if (contadorComidas > 3) {
                sed = true
            }
        }
    }
    method beber(){
      sed = false
      hambriento = true
      contadorComidas = 0
    }
}

class Gallina{
    var property peso = 4
    const hambriento = true 
    const sed = false
    var property contadorComidas=0

    method comer() {
      contadorComidas+=1
    }
}

class Comedero{
    const alimento
    const pesoSoportado
    var property raciones 

    method necesitaRecarga(){
        raciones<10
    }
    method recargar(){
        raciones+=30
    }
    method puedeAtender(animal) {
        animal.hambriento() && animal.peso()<pesoSoportado
    }
    method atender(animal) {
      if(animal.hambriento() && animal.peso()<pesoSoportado){
        raciones-=alimento
      }
    }
}

class ComederoInteligente{
    var property alimento
    const capacidadMaxima
    
    method necesitaRecarga() {
     alimento<15 
    }
    method recargar() {
      alimento += capacidadMaxima-alimento
    }
    method puedeAtender(animal){
        animal.hambriento()
    }
    method atender(animal){
        if(animal.hambriento()){
            const comida = animal.peso()/100
            animal.comer(comida)
            alimento-=comida
        }
    }
}

class Bebedero{
    var property contadorAnimales = 0
    method puedeAtender(animal){
        animal.sed()
    }
    method atender(animal){
        if(animal.sed()){
            contadorAnimales+=1
        }
    } 
    method recargar(){
      if(contadorAnimales==20){
        contadorAnimales=0
      }
    }
}

class Vacunatorio{
    var property vacunas 
    method necesitaVacunas() {
      vacunas=0
    } 
    method recargar(){
      vacunas+=50
    }
    method puedeAtender(animal){
      animal.vacunar()
    }
}

const comederoNormal = new Comedero(alimento = 3, pesoSoportado = 500, raciones = 10)
const comederoInteligente = new ComederoInteligente(alimento = 20, capacidadMaxima = 30)
const bebedero = new Bebedero()
object estacion {
  const dispositivos = [comederoNormal,comederoInteligente,bebedero]
  method puedeSerAtendido(animal){
    dispositivos.any({unDispositivo => unDispositivo.puedeAtender(animal)})
  }
  method atender(animal){
    const dispositivoAtencion = dispositivos.anyOne()
    if(dispositivoAtencion.puedeAtender(animal)){
        dispositivoAtencion.atender(animal)
    }
  }
  method recargar(dispositivo){
    if(dispositivos.contains(dispositivo)&& dispositivo.necesitaRecarga()){
        dispositivo.recargar()
    }
  }
}
