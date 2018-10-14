object fuerzaOscura {
	var property valor = 5
	method eclipse(){
	valor = valor * 2
	}
}

class Personaje{
	var property hechizoPreferido
	var property artefactos = []
	var property baseLucha = 1
	var property monedasOro = 100
	const valorBaseHechiceria = 3 
	
	constructor(_artefactos){
          artefactos = _artefactos
    }
	constructor(_hechizoPreferido,_artefactos){
          hechizoPreferido = _hechizoPreferido
          artefactos = _artefactos
    }
    constructor(_hechizoPreferido,_monedasOro,_artefactos){
          hechizoPreferido = _hechizoPreferido
          monedasOro = _monedasOro
          artefactos =_artefactos
    }
	method nivelHechiceria() {
		return (valorBaseHechiceria * hechizoPreferido.poder()) + fuerzaOscura.valor()
	}
	method esPoderoso(){
		return hechizoPreferido.esPoderoso()
	}

	method agregarArtefacto(algunArtefacto) {artefactos.add(algunArtefacto)}
	method removerArtefacto(algunArtefacto) {artefactos.remove(algunArtefacto)}
	
	method listaSinArtefacto(otroArtefacto) = artefactos.filter({artefacto => artefacto != otroArtefacto})
	
	method removerTodosArtefactos(){artefactos.clear()}
	method habilidadLucha() {
		return (baseLucha + artefactos.map({arma => arma.unidadesLucha()}).sum())
	}
	method mayorHabilidadLuchaQueDeHechizeria() {
		return self.nivelHechiceria() > self.habilidadLucha()
	}

	method estaCargado() {
		return artefactos.size() >= 5
	}
	
	//Segunda Entrega
	method meSaleGratis(nuevoHechizo) = hechizoPreferido.precioCanje() > nuevoHechizo.precio() 
	method pagoCanje() {
		return (hechizoPreferido.precioCanje() + self.monedasOro())
	}
	method puedoCanjear(nuevoHechizo){
		return self.pagoCanje() > nuevoHechizo.precio()
	}
	method canjear(nuevoHechizo){
		if(self.puedoCanjear(nuevoHechizo))
		{
			if(self.meSaleGratis(nuevoHechizo))
			{
				//Gratis
				hechizoPreferido = nuevoHechizo
			}else{
				monedasOro = monedasOro + hechizoPreferido.precioCanje() - nuevoHechizo.precio()  
				hechizoPreferido = nuevoHechizo
			}
		}else{
			throw new Exception("No puede Canjear el hechizo") 
		}		
	}
	method comprar(artefacto){
		if(self.monedasOro() >= artefacto.precio()){
			self.agregarArtefacto(artefacto)
			monedasOro = monedasOro - artefacto.precio()
		}else{
			throw new Exception("No puede Comprar el artefacto")
		}
	}
}

//Hechizos
class Logos{
	var property nombre
	var property multiplicador
	method esPoderoso() {
		return self.poder() > 15
	}
	method poder() {
		return nombre.length() * self.multiplicador()
	}
	method precio(){
		return self.poder()
	}
	method precioCanje() = self.precio() /2
}

object hechizoBasico{
	var property poder = 10
	
	method esPoderoso() {
		return false
	}
	
	method precio(){
		return 10
	}
	method precioCanje() = self.precio() /2
}

class LibroHechizos{
	var property hechizos = []
	method agregarHechizo(_hechizo) {hechizos.add(_hechizo)}
	method removerHechizo(_hechizo) {hechizos.remove(_hechizo)}
	method poder() {
		return hechizos.filter({hechizo => hechizo.esPoderoso()}).sum({hechizo => hechizo.poder()})
	}
	method precio(){
		return (10 * hechizos.size()) + self.poder()  
	}
}

//Artefactos

class Artefacto { 
	method unidadesLucha()
}
class Arma inherits Artefacto{
	override method unidadesLucha() {
		return 3
	}
	method precio(){
		return 5 * self.unidadesLucha()
	}
}
class CollarDivino inherits Artefacto{
	var property perlas
	override method unidadesLucha() {
		return perlas
	} 
	method precio(){
		return 2 * self.perlas()
	}
}
class Mascara inherits Artefacto{
	var property indiceOscuridad
	var property minimo = 4
	constructor(_indiceOscuridad, _minimo) {
          indiceOscuridad = _indiceOscuridad
          minimo = _minimo
     }
     constructor(_indiceOscuridad) {
          indiceOscuridad = _indiceOscuridad
     }
	override method unidadesLucha() {
		return ((fuerzaOscura.valor()/2)*indiceOscuridad).max(minimo)
	}
}

class Espejo inherits Artefacto{
	var property personaje
	override method unidadesLucha(){
		if(personaje.listaSinArtefacto(self).isEmpty())
		{
			return 0
		}else{		
			return personaje.listaSinArtefacto(self).max({artefacto => artefacto.unidadesLucha()}).unidadesLucha()
		}
	}
	method precio(){
		return 90
	}
}

class Armadura inherits Artefacto{
	var property refuerzo
	const property baseArmadura
	constructor(_refuerzo, _baseArmadura) {
          refuerzo = _refuerzo
          baseArmadura = _baseArmadura
    }
    constructor(_baseArmadura) {
          baseArmadura = _baseArmadura
    }

	override method unidadesLucha()= baseArmadura + refuerzo.unidadesLucha()

	method precio() = refuerzo.precioCon(self)	

}
class Refuerzo{
	method unidadesLucha()
	method precioCon(unaArmadura) 
}
class CotaDeMalla inherits Refuerzo{
	var property unidadesLucha
	constructor(_unidadesLucha) {
          unidadesLucha = _unidadesLucha
    }
	override method unidadesLucha() {
		return unidadesLucha
	}
	override method precioCon(armadura){
		return self.unidadesLucha() / 2 
	}
}

class Bendicion inherits Refuerzo{
	var property luchador
	constructor(_luchador) {
          luchador = _luchador
    }
	override method unidadesLucha(){
		return luchador.nivelHechiceria()
	}
	override method precioCon(armadura){
		return  armadura.baseArmadura()
	}
}

class Hechizo inherits Refuerzo{
	var property hechizo
	override method unidadesLucha() {
		return hechizo.poder()
	}
	override method precioCon(unaArmadura) = hechizo.precio() + unaArmadura.baseArmadura()
}

object ninguno inherits Refuerzo{
	
	override method unidadesLucha(){
		return 0
	}
	
	override method precioCon(armadura){
		return 2
	}
}