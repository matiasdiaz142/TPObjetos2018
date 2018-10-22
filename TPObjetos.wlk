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
	const cargaMaxima
	const valorBaseHechiceria = 3 
	
	constructor(_artefactos,_cargaMaxima){
          artefactos = _artefactos
          cargaMaxima = _cargaMaxima
    }
	constructor(_hechizoPreferido,_artefactos,_cargaMaxima){
          hechizoPreferido = _hechizoPreferido
          artefactos = _artefactos
          cargaMaxima = _cargaMaxima
    }
    constructor(_hechizoPreferido,_monedasOro,_artefactos,_cargaMaxima){
          hechizoPreferido = _hechizoPreferido
          monedasOro = _monedasOro
          artefactos =_artefactos
          cargaMaxima = _cargaMaxima
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
	//Tercera Entrega
	method pesoTotalCarga() = artefactos.sum({artefacto => artefacto.pesoTotal()})
	method comprarAlgoA(artefacto,comerciante){
		if(self.monedasOro() >= comerciante.vender(artefacto)){
			self.agregarArtefacto(artefacto)
			monedasOro = monedasOro - comerciante.vender(artefacto)
		}else{
			throw new Exception("No puede Comprar el artefacto")
		}
	}
}
class PersonajeNoControlado inherits Personaje{
	var property nivel
	override method habilidadLucha() = super()*nivel.multiplicador()
}
object facil{
	method multiplicador() = 1
}
object moderado{
	method multiplicador() = 2
}
object dificil{
	method multiplicador() = 4
}

//Hechizos
class Hechizo{
	method poder()
	method esPoderoso() = self.poder() > 15
	method pesoTotal() = 0
	method precio() = self.poder()

}
class HechizoComercial inherits Hechizo{
	var nombre = "el hechizo comercial"
	var property multiplicador = 2
	var property porcentaje = 20
	override method poder() = nombre.length()*(porcentaje/100)*multiplicador
}
class Logos inherits Hechizo{
	var property nombre
	var property multiplicador
	override method poder() {
		return nombre.length() * self.multiplicador()
	}

	method precioCanje() = self.precio() /2
}

object hechizoBasico inherits Hechizo{
	var property poder = 10
	override method poder() = poder
	//Si no ponemos el getter de poder, wollok no reconoce que existe
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
	method pesoTotal() = 0
}

//Artefactos
class Artefacto { 
	var peso
	var fechaDeCompra
	var fechaHoy = new Date()
	method unidadesLucha()
	method pesoTotal() = peso - self.factorDeCorreccion() 
	method factorDeCorreccion() = 1.min(self.diasDesdeCompra()/100)
	method diasDesdeCompra() = fechaHoy - fechaDeCompra
}
class Arma inherits Artefacto{
	override method unidadesLucha() {
		return 3
	}
	method precio(){
		return 5 * peso
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
	override method pesoTotal() = super() + 0.5 * perlas
}
class Mascara inherits Artefacto{
	var property indiceOscuridad
	var property minimo = 4

	override method unidadesLucha() {
		return ((fuerzaOscura.valor()/2)*indiceOscuridad).max(minimo)
	}
	override method pesoTotal(){
		if(indiceOscuridad != 0){
			return super() + 0.max(self.unidadesLucha()-3) 
		}
		return super()
	}
	method precio() = 10*indiceOscuridad
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
	const property baseArmadura = 2
	
	override method unidadesLucha()= baseArmadura + refuerzo.unidadesLucha()

	method precio() = refuerzo.precioCon(self)
	override method pesoTotal() = super() + refuerzo.peso()
}
class Refuerzo{
	method unidadesLucha()
	method precioCon(unaArmadura) 
	method peso() = 0
}
class CotaDeMalla inherits Refuerzo{
	var unidadesLucha
	constructor(_unidadesLucha) {
          unidadesLucha = _unidadesLucha
    }
	override method unidadesLucha() = unidadesLucha
	override method precioCon(armadura){
		return self.unidadesLucha() / 2 
	}
	override method peso() = 1
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

class HechizoRefuerzo inherits Refuerzo{
	var property hechizo
	override method unidadesLucha() {
		return hechizo.poder()
	}
	override method precioCon(unaArmadura) = hechizo.precio() + unaArmadura.baseArmadura()
	override method peso() = if(hechizo.poder().even()) 2 else 1 
}

object ninguno inherits Refuerzo{
	
	override method unidadesLucha(){
		return 0
	}
	
	override method precioCon(armadura){
		return 2
	}
}
class Comerciante{
	var tipo
	method vender(artefacto) = tipo.vender(artefacto)
}
class ComercianteIndependiente{
	const comisionInicial
	var comision
	constructor(_comision){
		comisionInicial =_comision
		comision=_comision
	}
	method vender(artefacto) = artefacto.precio() + self.impuesto()*artefacto.precio()
	method impuesto() = (21.min(comision))/100
	method recategorizar(){comision*=2}
}
class ComercianteRegistrado{
	const iva = 21
	method vender(artefacto) = artefacto.precio() + self.impuesto()*artefacto.precio()
	method impuesto() = iva/100
	method recategorizar(){}
	//Nose como pasarlo a ComercianteConImpuestoAGanancias
}
class ComercianteConImpuestoAGanancias{
	const impuestoGanancias = 35
	var minimoImponible
	method vender(artefacto) {
		if(artefacto.precio() < minimoImponible)
		{
			return artefacto.precio()
		}
		else
		{
			return artefacto.precio() + (artefacto.precio()-minimoImponible)*self.impuesto()
		}
	}
	method impuesto() = impuestoGanancias/100
	method recategorizar(){}
}