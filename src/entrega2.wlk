object fuerzaOscura {
	var property valor = 5
	method eclipse(){
	valor = valor * 2
	}
}

class Personaje{
	var property hechizoPreferido
	const property artefactos = []
	const valorBaseHechiceria = 3 
	var property baseLucha = 1
	//Punto 1
	method nivelHechiceria() {
		return (valorBaseHechiceria * hechizoPreferido.poder()) + fuerzaOscura.valor()
	}
	method esPoderoso(){
		return hechizoPreferido.esPoderoso()
	}
	
	//Punto 2
	method agregarArtefacto(algunArtefacto) {artefactos.add(algunArtefacto)}
	method removerArtefacto(algunArtefacto) {artefactos.remove(algunArtefacto)}
	
	method listaSinArtefacto(_artefacto){
		var listaAux = artefactos
		listaAux.remove(_artefacto)
		return listaAux
	}
	
	method removerTodosArtefactos(){artefactos.clear()}
	method habilidadLucha() {
		return (baseLucha + artefactos.map({arma => arma.unidadesLucha()}).sum())
	}
	method mayorHabilidadLuchaQueDeHechizeria() {
		return self.nivelHechiceria() > self.habilidadLucha()
	}
	//Punto 3
	method estaCargado() {
		return artefactos.size() >= 5
	}
}

//Hechizos
//espectroMalefico
class Logos inherits Hechizo{
	var property nombre
	var property valorMultiplcacion
	override method esPoderoso() {
		return self.poder() > 15
	}
	override method poder() {
		return nombre.length()*valorMultiplcacion
	}
}

class HechizoBasico inherits Hechizo{
	var poder = 10
	override method esPoderoso() {
		return false
	}
	override method poder() = poder
	method poder(_poder) {poder=_poder}
}

class Hechizo{
	method unidadesLucha() {
		return self.poder()
	}
	method poder()
	method esPoderoso()
}

object libroHechizos{
	var property hechizos = []
	method agregarHechizo(_hechizo) {hechizos.add(_hechizo)}
	method removerHechizo(_hechizo) {hechizos.remove(_hechizo)}
	method poder() {
		return hechizos.filter({hechizo => hechizo.esPoderoso()}).map({hechizo => hechizo.poder()}).sum()
	}
}
//Que libroHechizos se contenga asi mismo romperia al libroHechizo no entender el mensaje esPoderoso
//y ademas que entraria en un caso recursivo al preguntar el poder del libroHechizos

//Artefactos
class Espada{
	method unidadesLucha() {
		return 3
	}
}
class CollarDivino{
	var property perlas
	method unidadesLucha() {
		return perlas
	} 
}
class Mascara{
	var indiceOscuridad
	var minimoPoder
	method unidadesLucha() {
		return ((fuerzaOscura.valor()/2)*indiceOscuridad).max(minimoPoder)
	}
}

class Armadura{
	var property refuerzo
	var property valorBase = 2
	method unidadesLucha(){
		if(refuerzo != null)
		{
			return valorBase + refuerzo.unidadesLucha()
		}
		else
		{
			return valorBase 
		}
	} 
}

class CotaDeMalla{
	var property valorLucha = 1
	method unidadesLucha() {
		return valorLucha
	}	
}

class Bendicion{
	var property luchador 
	method unidadesLucha(){
		return luchador.nivelHechiceria()
	}
}

class EspejoFantastico{
	var property luchador
	method unidadesLucha(){
		if(luchador.artefactos() == [self])
		{
			return 0
		}else{		
			return luchador.listaSinArtefacto(self).max({artefacto => artefacto.unidadesLucha()}).unidadesLucha()
		}
	}
}