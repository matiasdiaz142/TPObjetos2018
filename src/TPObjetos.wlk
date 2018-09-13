object rolando{
	var property hechizoPreferido
	var property fuerzaOscura = 5
	var property habilidadLucha = 1
	var property artefactos = []
	
	//Cosas Punto 1
	method nivelHechiceria() = (3* hechizoPreferido.poder()) + fuerzaOscura
	method eclipse() {fuerzaOscura*=2}
	method soyPoderoso() = hechizoPreferido.esPoderoso()
	//Cosas Punto 2
	method habilidadLucha() = habilidadLucha + artefactos.map({artefacto => artefacto.unidadesLucha()}).sum()  
	method agregarArtefacto(_artefacto) {artefactos.add(_artefacto)}
	method removerArtefacto(_artefacto) {artefactos.remove(_artefacto)}
	method removerTodosArtefactos(){artefactos.clear()}
	method mayorHabilidadLuchaQueNivelDeHechiceria() = self.habilidadLucha() > self.nivelHechiceria()
	//Cosas Punto 3
	method estaCargado() = artefactos.size() >= 5
}
//Cosas Punto 1
//Hechizos posibles para Hechizo Preferido
object espectroMalefico{
	var property nombre = "Espectro malefico"
	var property poder
	method esPoderoso() = nombre.length() > 15
	method poder() = nombre.length()
	//Para punto 3
	method unidadesLucha() = self.poder()
}

object hechizoBasico{
	var property poder = 10
	method esPoderoso() = false
	//Para punto 3
	method unidadesLucha() = poder
}
//Cosas Punto 2
//Artefactos para Rolando
object espadaDelDestino{
	method unidadesLucha() = 3
}
object collarDivino{
	var property perlas
	method unidadesLucha() = perlas
}
object mascaraOscura{
	var property fuerzaOscura = 5
	method eclipse() {fuerzaOscura*=2}
	
	method unidadesLucha() = 4.max(fuerzaOscura/2)
}
//Cosas Punto 3
//Otro artefacto
object armadura{
	var property refuerzo
	method unidadesLucha() {
		if(refuerzo == null)
		{
			return 2
		}
		return 2 + refuerzo.unidadesLucha()
	}
}
//Refuerzos para Armadura
object cotaDeMalla{
	method unidadesLucha() = 1
}
object bendicion{
	var property poseedor = rolando
	method unidadesLucha() = poseedor.nivelHechiceria()
}

object espejoFantastico{
	var property poseedor = rolando
	var unidadesLucha
	method unidadesLucha(){
		if(rolando.artefactos() == [self])
		{
			return 0
		}
		poseedor.removerArtefacto(self)
		unidadesLucha = poseedor.artefactos().map({artefacto => artefacto.unidadesLucha()}).max()
		rolando.agregarArtefacto(self)
		return unidadesLucha
	}
	
}

//Tipo de hechizo preferido
object libroHechizos{
	var property hechizos = []
	var property poder
	method agregarHechizo(_hechizo) {hechizos.add(_hechizo)}
	method poder() = hechizos.filter({hechizo => hechizo.esPoderoso()}).map({hechizo => hechizo.poder()}).sum()
}

