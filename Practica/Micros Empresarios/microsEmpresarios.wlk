class MicroEmpresario {
    var property asientosLibres
    var property lugarParado
    const volumenMicro

    method subirPasajero(pasajero){
        if(pasajero.seSubeAlMicro(self)){
           if(asientosLibres>0){
            asientosLibres -=1} 
           else {
            if (lugarParado>0){
                lugarParado-=1
            }
           } 
        }
        else self.error('No se puede subir al micro')
    }
}
class Empleado{
    const jefe
    method seSubeAlMicro()
}

class Apurado inherits Empleado {
  override method seSubeAlMicro(){
    true
  }
}

class Claustrofobico inherits Empleado {
    method seSubeAlMicro(micro){
        micro.volumenMicro() > 120
    }
}

class Fiaca inherits Empleado {
   method seSubeAlMicro(micro){
    micro.asientosLibres() >= 1
  }
}

class Moderado inherits Empleado {
    const condicionModerado
   method seSubeAlMicro(micro){
    (micro.asientosLibres() + micro.lugarParado()) > condicionModerado
  }
}

class Obsecuente inherits Empleado {
   method seSubeAlMicro(micro){
    jefe.seSubeAlMicro(micro)
  }
}


