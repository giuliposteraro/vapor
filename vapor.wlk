class Juego{
	var logrosQueAporta = []
	var estilo
	var property costo
	var property dificultad
	var cantSangre 
	method tieneLogrosImportantes(){
		if(!self.esRosita()){
			return logrosQueAporta.any{logro => logro.esImportante()}
		}
			return false 
	}
	method esRosita(){
		return cantSangre < 1 || dificultad <= 2
	}
	method otorgarLogrosA(jugador){
		jugador.experienciaGamer() % 100 
		estilo.logrosPor(jugador,self)
	}
	method sangreTotal(jugador){
		return jugador.tiempoJugado() * cantSangre
	}
	method instalarExpansion(){
		dificultad += 1
		estilo = estilo.cambiar()
	}
}

object aventura{
	method logrosPor(jugador,juego){
		return new SecretoDesbloqueado(gemasQueAporta = 1 / jugador.experienciaGamer())
	}
	method cambiar(){
		return pelea
	}
}

object pelea{
	method logrosPor(jugador,juego){
		if (juego.sangreTotal(jugador) < 10){
			jugador.agregarLogro(new Avance()) 
	}
			jugador.agregarLogro(new Avance(), new SecretoDesbloqueado(gemasQueAporta= jugador.tiempoJuego() / 10)) 
	}	
}

object logica{
	method logrosPor(jugador,juego){
		if(jugador.tiempoJuego() * juego.dificultad() > 17){
			jugador.agregarLogro(new ExperienciaAlcanzada(gemasQueAporta = gemasQueAporta * 2 + jugador.cantidadLogros()))
		}
	}
}

object fps{
	method logrosPor(jugador,juego){
	}
}

class Jugador{
	var property logrosObtenidos = []
	var tiempoJuego
	var billeteraVirtual
	var property misJuegos = []
	method agregarLogro(cual){
		logrosObtenidos.add(cual)
	}
	method experienciaGamer(){
		return tiempoJuego * 25 
	}
	method gemas(){
		return logrosObtenidos.sum{logro => logro.gemasQueAporta()}
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
		billeteraVirtual += logrosObtenidos.size()
	}
	method juegosConLogrosImportantes(){
		return misJuegos.filter{juego => juego.tieneLogrosImportantes()}
	}
	method cantidadLogros(){
		return logrosObtenidos.size()
	}
	method jugar(juego,cantHoras){
		juego.otorgarLogrosA(self)
		tiempoJuego += cantHoras
	}
}

class Logro{
	var gemasQueAporta 
	method gemasQueAporta(usuario,juego){
		gemasQueAporta += self.otorgarGemas(usuario,juego)
	} 
	method otorgarGemas(usuario,juego)
	method esImportante(){
		return gemasQueAporta > 500
	}
	
}
class Avance inherits Logro{
	override method otorgarGemas(usuario,juego){
		return usuario.tiempoJuego() * juego.dificultad()
	}
	override method esImportante(){
		return false
	}
}

class SecretoDesbloqueado inherits Logro{
	var logros = []
	override method otorgarGemas(usuario,juego){
		 logros.forEach{logro => logro.gemasQueAporta()}
	}
}

class ExperienciaAlcanzada inherits Logro{
	override method otorgarGemas(usuario,juego){
		return (usuario.experienciaGamer() / 10) * juego.dificultad()
	}
}


