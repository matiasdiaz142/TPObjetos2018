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
	method mayorHabilidadLuchaQueNivelDeHechiceria() = self.habilidadLucha() > self.nivelHechiceria()
	//Cosas Punto 3
	
}
//Cosas Punto 1
object espectroMalefico{
	var property nombre = "Espectro malefico"
	var property poder
	method esPoderoso() = nombre.length() > 15
	method poder() = nombre.length()
}

object hechizoBasico{
	var property poder = 10
	method esPoderoso() = false
	
}
//Cosas Punto 2
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
object armadura{
	
}