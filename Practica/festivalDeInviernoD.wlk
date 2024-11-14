// VIKINGOS

class Vikingo{
    const property peso
    const property inteligencia
    const property velocidad
    const property barbarosidad
    var hambre = 0
    var item

    method item() = item
    method hambre() = hambre.min(100).max(0)
    method hambreQueSiente(posta) = posta.hambreQueLeDa(self) 
     method puedeParticipar(posta) = self.hambre() + self.hambreQueSiente(posta) < 100

    method participarEn(torneo){
        if(!torneo.puedeParticipar(self)){
            throw new ParticipacionException (message = "No puede participar")
        }
        torneo.inscribir(self)
    }

    method participar(posta){
        self.modificarHambre(self.hambreQueSiente(posta))
        return posta.puntaje(self)
    }

    method cantidadDePescados() = peso/2 + barbarosidad
    method modificarHambre(valor){ hambre = 100.min(hambre+valor)}
    method danio() = barbarosidad + item.danio()

    method puedeMontar(dragon){
       return dragon.permiteMonturaDe(self)
    }

    method montar(dragon){
        if(!self.puedeMontar(dragon)){
            throw new DragonException (message = "No puede montarlo")
        }
        const jinete = new Jinete(dragon=dragon, vikingo=self)
    }

    method conveniencia(dragones,posta){
        const losQuePuedeMontar = dragones.filter({d => self.puedeMontar(d)})
        const jinetes = losQuePuedeMontar.map({d => self.montar(d)})
        const mejorJinete= posta.max({jinete => posta.puntaje(jinete)})
        if(posta.esMejor(mejorJinete,self)){
            return mejorJinete
        }
        else{ 
            return self
        }
    }

}
object hipo inherits Vikingo(
    peso =10,
    inteligencia =10,
    velocidad =10,
    barbarosidad =10,
    item = sistemaDeVuelo){}
object astrid inherits Vikingo(
    peso =10,
    inteligencia =10,
    velocidad =10,
    barbarosidad =10,
    item = hacha){} 
object patan inherits Vikingo(
    peso =10,
    inteligencia =10,
    velocidad =10,
    barbarosidad =10,
    item = masa){}

object patapez inherits Vikingo(
    peso =10,
    inteligencia =10,
    velocidad =10,
    barbarosidad =10,
    item = comestible){
        override method hambreQueSiente(posta) = posta.hambreQueLeDa()*2
        method comer(comestible) {
            self.modificarHambre(-comestible.hambreSaciada())
    }
}

// ITEMS

class Item{
    method danio() = 0
}
class Arma inherits Item{
    const danio
    override method danio()= danio
}
object comestible inherits Item{
    const property hambreSaciada = 5
}

const sistemaDeVuelo = new Item()
const hacha = new Arma(danio=30)
const masa = new Arma(danio=100)
// POSTAS

class Torneo{
    const postas
    const participantes = #{}

    method puedeParticipar(vikingo){

        const hambreTorneo = postas.sum({posta => vikingo.hambreQueSiente(self)}) 
        hambreTorneo + vikingo.hambre() < 100
    } 

    method inscribir(vikingo) = participantes.add(vikingo)
    method jugarTorneo(){
        postas.forEach({posta => posta.jugarPosta(participantes)})
    }
}

class Posta{
    method puntaje(vikingo)
    method hambreQueLeDa()
    method jugarPosta(participantes){
        const resultados = participantes.forEach({vikingo => vikingo.participar(self)})
        return resultados.sortedBy({a,b => a>b})
    }
    method esMejor(unVikingo,otroVikingo) {
        return self.puntaje(unVikingo)>self.puntaje(otroVikingo)
    }
    
}
object pesca{
    method hambreQueLeDa() = 5
    method puntaje(vikingo) = vikingo.cantidadDePescados()
}

object combate{
    method hambreQueLeDa() = 10
    method puntaje(vikingo) = vikingo.danio()
}

class Carrera{
    const cantidadKm
    method hambreQueLeDa() = cantidadKm
    method puntaje(vikingo) = vikingo.velocidad()
}
// DRAGONES

class Dragon {
  const property peso
  const requisitosMontura = #{requisitoBase}

  method velocidadBase() = 60
  method danio()
  method velocidad() = self.velocidadBase() - peso
  method pesoMaximo() = peso*0.2

  method puedeCargar(vikingo){
    vikingo.peso()<= self.pesoMaximo()
  }

  method permiteMonturaDe(vikingo){
    requisitosMontura.all({requisito => requisito.cumpleRequisito(self, vikingo)})
  }
}

class FuriaNocturna inherits Dragon{
    const danio
    override method danio() = danio
    override method velocidad() = super()*3
}
class NadderMortifero inherits Dragon(requisitosMontura= #{requisitoBase,requisitoInteligencia}){

    override method danio() = 150
}

class Gronckle inherits Dragon{
    override method velocidadBase() = super()/3
    override method danio() = 5*peso 
}

object requisitoBase{
    method cumpleRequisito(dragon,vikingo) = dragon.peso()*0.2 > vikingo.peso()
}

class RequisitoBarbarosidad{
    const barbarosidadNecesaria
    method cumpleRequisito(dragon,vikingo) = vikingo.barbarosidad()>barbarosidadNecesaria
}

class RequisitoItem{
    const itemNecesario
    method cumpleRequisito(dragon,vikingo) = vikingo.item() == itemNecesario
}

object requisitoInteligencia{
    method cumpleRequisito(dragon,vikingo) = vikingo.inteligencia() < dragon.inteligencia()
}

// JINETE

class Jinete{
    const property dragon
    const property vikingo

    method cantidadDePescado() =  vikingo.peso() - dragon.pesoMaximo()
    method danio() = vikingo.danio() + dragon.danio()
    method velocidad() = dragon.velocidad() - vikingo.peso()
    method hambreQueSiente(posta) = 5
}



//EXCEPTIONS

class ParticipacionException inherits DomainException{}
class DragonException inherits DomainException{}