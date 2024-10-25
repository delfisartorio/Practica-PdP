class Pajaro{
    const nombre 
    var property ira = 1

    method enojarse() { 
        ira=ira*2}

    method fuerza(){
        return ira*2
    }
    method tranquilizar(){
        ira-=5
    }
    method puedeDerribar(obstaculo) {
      return self.fuerza()>obstaculo.resistencia()
    }
    method impactar(isla){
        const obstaculoAImpactar = isla.obstaculos().first()
        if(self.puedeDerribar(obstaculoAImpactar)){
            isla.obstaculos().remove(obstaculoAImpactar)
        }
    }
   
}

class PajaroReencoroso inherits Pajaro{
    var contadorEnojos = 0

    override method enojarse(){
      super()
      contadorEnojos+=1
    }
}

object red inherits PajaroReencoroso(nombre = "Red"){
    
    override method fuerza() = ira * 10 * contadorEnojos
    
}

object bomb inherits Pajaro(nombre = "Bomb")  {
    var fuerzaMax = 9000

    override method fuerza() = super().min(fuerzaMax)    
}

object chuck inherits Pajaro(nombre = "Chuck"){
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

    override method tranquilizar(){
        ira = self.ira()
    }
}

object terence inherits PajaroReencoroso(nombre= "Terence"){
    var multiplicador = 1

    override method fuerza(){
        return ira*multiplicador*contadorEnojos
    }
}

object matilda inherits Pajaro (nombre= "Matilda"){
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

object islaPajaro{
    var pajarosDeLaIsla = [red,bomb,chuck,terence,matilda]

    method pajarosMasFuertes(){
        const losFuertes = pajarosDeLaIsla.filter({pajaro=> pajaro.fuerza()>50})
        return losFuertes
    }
    method fuerzaDeLaIsla(){
        const losFuertes = pajarosDeLaIsla.pajarosMasFuertes()
        return losFuertes.map({pajaro => pajaro.fuerza()}).sum()
    }
    method sesionDeManejoDeIraConMatilda(){
        pajarosDeLaIsla.forEach({pajaro => pajaro.tranquilizar()})
    }

    method invasionDeCerditos(cerditos){
        const cteEnojo = cerditos/100
        pajarosDeLaIsla.forEach({pajaro => cteEnojo.times(pajaro.enojar())})
    }
    method fiestaSorpresa(homenajeados){
        if(homenajeados.isEmpty()){
            throw new SinHomenajeadosExeption(message ="No hay homenajeados")
        }
        pajarosDeLaIsla.forEach({pajaro => if(homenajeados.tienePajaro(pajaro)){ pajaro.enojarse()}})
    }

    method tienePajaro(pajaro){
        pajarosDeLaIsla.any({pajaroEnLista => pajaroEnLista.nombre()== pajaro.nombre()})
    }

    method serieDeEventosDesafortunados(eventos){
        eventos.forEach({ evento => evento.ejecutar(self)})
    }

    method atacar(isla){
        pajarosDeLaIsla.forEach({pajaro=> pajaro.atacar(isla) && pajarosDeLaIsla.remove(pajaro)})
    }
    method recuperaronHuevos(isla){
        return isla.obstaculos().isEmpty()
    }
}

class Evento {
    method ejecutar(isla)
}

class InvasionDeCerditos inherits Evento {
    var cantidadDeCerditos

    override method ejecutar(isla) {
        isla.invasionDeCerditos(cantidadDeCerditos)
    }
}

object sesionDeManejoDeIra inherits Evento {
    override method ejecutar(isla) {
        isla.sesionDeManejoDeIraConMatilda()
    }
}

class FiestaSorpresa inherits Evento {
    var homenajeados

    override method ejecutar(isla) {
        isla.fiestaSorpresa(homenajeados)
    }
}

// Guerra porcina
class Obstaculo {
    method resistencia()
}
class Material inherits Obstaculo{
    const property tipoMaterial
    const anchoPared
    override method resistencia(){
        return tipoMaterial.multiplicador()*anchoPared
    }
}
object Vidrio {
    const property multiplicador = 10
}
class Madera{
     const property multiplicador = 25
}
class Piedra{
     const property multiplicador = 50
}
class CerditoObrero inherits Obstaculo{
    override method resistencia(){
        return 50
    } 
}
class CerditoArmado inherits Obstaculo{
    const resistenciaArmadura
    override method resistencia(){
        return 10*resistenciaArmadura    
    }
}

object islaCerdito{
    var property obstaculos = []

}

class SinHomenajeadosExeption inherits DomainException{}
