object rolando{
	var property hechizoPreferido
	var property artefactos = []
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
	
	method listaSinEspejo(){
		var listaAux = artefactos
		listaAux.remove(espejoFantastico)
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

object fuerzaOscura {
	var property valor = 5
	method eclipse(){
	valor = valor * 2
	}
}

//Hechizos
object espectroMalefico{
	var property nombre = "Espectro Malefico"
	method esPoderoso() {
		return self.poder() > 15
	}
	method poder() {
		return nombre.length()
	}
}

object hechizoBasico{
	var property poder = 10
	method esPoderoso() {
		return false
	}
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
object espada{
	method unidadesLucha() {
		return 3
	}
}
object collarDivino{
	var property perlas
	method unidadesLucha() {
		return perlas
	} 
}
object mascaraOscura{
	method unidadesLucha() {
		return (fuerzaOscura.valor()/2).max(4)
	}
}

object armadura{
	var property refuerzo
	method unidadesLucha(){
		if(refuerzo != null)
		{
			return 2 + refuerzo.unidadesLucha()
		}
		else
		{
			return 2 
		}
	} 
}

object cotaDeMalla{
	method unidadesLucha() {
		return 1
	}	
}

object bendicion{
	var property luchador = rolando
	method unidadesLucha(){
		return luchador.nivelHechiceria()
	}
}

object hechizo{
	var property hechizo
	method unidadesLucha() {
		return hechizo.poder()
	}
}

object espejoFantastico{
	var property luchador = rolando
	method unidadesLucha(){
		if(luchador.artefactos() == [self])
		{
			return 0
		}else{		
			return luchador.listaSinEspejo().max({artefacto => artefacto.unidadesLucha()}).unidadesLucha()
		}
	}
	
}