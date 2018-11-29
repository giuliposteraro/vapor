class Juego{
	var logros = []
	var property costo
	var property dificultad
	var cantSangre 
	method tieneLogrosImportantes(){
		if(!self.esRosita()){
			return logros.any{logro => logro.esImportante()}
		}
			return false 
	}
	method esRosita(){
		return cantSangre < 1 || dificultad <= 2
	}
}

class Jugador{
	var property logros = []
	var tiempoJuego
	var billeteraVirtual
	var property misJuegos = []
	method experienciaGamer(){
		return tiempoJuego * 25 
	}
	method gemas(){
		return logros.sum{logro => logro.gemasQueAporta()}
	}
	method yaLoTiene(juego){
		return misJuegos.contains(juego)
	}
	method puedeComprarJuego(juego){
		if(billeteraVirtual + self.gemas() < juego.costo() || self.yaLoTiene(juego)){
			error.throwWithMessage("No puede comprar el juego")
		}
			self.tieneDineroSuficientePara(juego)
	}
	
	method tieneDineroSuficientePara(juego){
		if(billeteraVirtual > juego.costo()){
			self.comprarJuego(juego)
		}
			self.transformarLogros()
			self.comprarJuego(juego)
	}
	method comprarJuego(juego){
		billeteraVirtual -= juego.costo()
		misJuegos.add(juego)
	}
	
	method transformarLogros(){
		billeteraVirtual += logros.size()
	}
	method juegosConLogrosImportantes(){
		return misJuegos.filter{juego => juego.tieneLogrosImportantes()}
	}
}

class Logro{
	var juego
	var property gemasQueAporta
	method otorgarGemasA(usuario) 
	method esImportante(){
		return gemasQueAporta > 500
	}
	
}
class Avance inherits Logro{
	override method otorgarGemasA(usuario){
		return usuario.tiempoJuego() * juego.dificultad()
	}
	override method esImportante(){
		return false
	}
}

class SecretoDesbloqueado inherits Logro{
	var logros
	override method otorgarGemasA(usuario){
		 logros.forEach{logro => logro.gemasQueAporta()}
	}
}

class ExperienciaAlcanzada inherits Logro{
	override method otorgarGemasA(usuario){
		return (usuario.experienciaGamer() / 10) * juego.dificultad()
	}
}



