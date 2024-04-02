object casaDePepeYJulian {

	var property porcentajeDeViveres = 0
	var costosDeReparacion = 0
	var cuentaGestion = cuentaCorriente
	var estrategiaDeAhorro = minimoEIndispensable
	
	method cuentaGestion(cuenta){
		cuentaGestion = cuenta
	}
	
	method cuentaGestion(){
		return cuentaGestion
	}
	method costosDeReparacion(){
		return costosDeReparacion
	}
	
	method repararCasa(){
		cuentaGestion.extraer(costosDeReparacion)
		costosDeReparacion = 0
	}
	
	method mantenimiento(){
		estrategiaDeAhorro.mantenimiento(self)
	}
	
	method estrategiaDeAhorro(estrategia,calidad){
		estrategiaDeAhorro = estrategia
		estrategiaDeAhorro.calidad(calidad)
	}

	method romperEnCosto(cantidad) {
		costosDeReparacion += cantidad
	}

	method viveresSuficientes() {
		return porcentajeDeViveres > 40
	}

	method comprarViveres(porcentaje,calidad) {
		porcentajeDeViveres += porcentaje
		cuentaGestion.extraer(porcentaje*calidad)
	}

	method necesitaReparacion() {
		return costosDeReparacion > 0
	}

	method estaEnOrden() {
		return (not self.necesitaReparacion()) && self.viveresSuficientes()
	}
	
	

}

object minimoEIndispensable{
	var calidad = 0
	method calidad(_calidad){
		calidad = _calidad
	}
	method mantenimiento(casa){
		self.rellenarViveres(casa)
	}
	method rellenarViveres(casa){
		if (casa.porcentajeDeViveres() < 40) casa.comprarViveres(40-casa.porcentajeDeViveres(),calidad)
	}
}

object full{
	const calidad = 5
	method calidad(_calidad){}
	method mantenimiento(casa){
		self.rellenarViveres(casa)
		if (casa.cuentaGestion().saldo() >= (casa.costosDeReparacion() + 1000)) casa.repararCasa()
	}
	
	method rellenarViveres(casa){
		if (casa.estaEnOrden()) casa.comprarViveres(100-casa.porcentajeDeViveres(),calidad)
		else casa.comprarViveres(40,calidad)
	}
}

object cuentaCorriente {

	var saldo = 0
	
	method saldo(){
		return saldo
	}

	method depositar(cantidad) {
		saldo += cantidad
	}

	method extraer(cantidad) {
		saldo -= cantidad
	}

}

object cuentaConGastos {

	var saldo = 0
	var costosPorOperacion = 20
	
	method costosPorOperacion(costo){
		costosPorOperacion = costo
	}

	method saldo() {
		return saldo
	}

	method depositar(cantidad) {
		saldo += cantidad - costosPorOperacion
		saldo = saldo.max(0)
	}

	method extraer(cantidad) {
		saldo -= cantidad
	}

}

object cuentaCombinada {

	var cuentaPrimaria = cuentaConGastos
	var cuentaSecundaria = cuentaCorriente

	method cuentaPrimaria(cuenta) {
		cuentaPrimaria = cuenta
	}

	method cuentaSecundaria(cuenta) {
		cuentaSecundaria = cuenta
	}

	method depositar(cantidad) {
		cuentaPrimaria.depositar(cantidad)
	}

	method extraer(cantidad) {
		if (cuentaPrimaria.saldo() >= cantidad) cuentaPrimaria.extraer(cantidad) else cuentaSecundaria.extraer(cantidad)
	}

	method saldo() {
		return cuentaPrimaria.saldo() + cuentaSecundaria.saldo()
	}

}

