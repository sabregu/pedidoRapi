//cliente
class Cliente{
    const property nombre
    const property dni
    var property historialCompras
    var property tipoCliente    
    var property criterio

    method comprar(compra){
        if(compra.sePuedeRealizar()){historialCompras.add(compra)}
    }
    method compraMasCara() = historialCompras.max{compra => compra.precio(self)}

    method productoMas() = historialCompras.max{compra => criterio.cantidad(compra)}
    
    method compraGratisCada(num) = historialCompras.size() % num == 0

    method beneficio() = tipoCliente.beneficio(self)

    method montoAhorrado() = historialCompras.sum{compra => compra.ahorrado(self)}
}
//tipoClientes
object clienteComun{
    method beneficio(cliente) = 1
}

object clienteSilver{
    method beneficio(cliente) = 0.5
}

object clienteGold{
    var property num = 5

    method beneficio(cliente){
        if(cliente.compraGratisCada(num)){
            return 0
        }else{return 0.1}
    }
}
//criterio producto Mas caro
object criterioProductoMasCaro{
    method cantidad(compra){compra.productoMasCaro()}
}

object criterioCantidad{
    method cantidad(compra){compra.productoMasPedido()}
}

// pedido
class Pedido{
    var property items
    var property local

    method valorRealEnvio(cliente) = valorEnvio.valorEnvio(cliente,local)

    method valorEnvio(cliente) = valorEnvio.valorEnvio(cliente,local) * cliente.beneficio(cliente)
    
    method precioBruto() = items.sum{item => item.precio()}
    
    method precioNeto(cliente) = self.precioBruto() + valorEnvio.valorEnvio(cliente,local) * cliente.beneficio()
    
    method agregarProducto(producto){
        items.forEach{item => if(item.nombre()== producto.nombre()){item.aumentarCantidad(producto.cantidad())}}
    }
    
    method localTieneTodosLosProductos(){local.localTieneTodosLosProductos(items)}
    
    method productoMasCaro()= items.max{item => item.precioUnitario()}
    
    method productoMasPedido() = items.max{item => item.cantidad()}
}

// item
class Item{
    var property nombre
    var property cantidad
    var property precioUnitario

    method precio() = precioUnitario * cantidad
    method aumentarCantidad(num){self.cantidad(cantidad+num)}
}

//calculadora

object valorEnvio{
    method valorEnvio(cliente,local){return aux.min(300,otraEmpresa.cantCuadras(cliente,local)*15)}
}

//aux
object aux{
    method min(a,b){if(a>b)return b else return a}
    method max(a,b){if(a>b)return a else return b}
}

//local
class Local{
    var property productos

    method localTieneTodosLosProductos(items){
    items.all{item => productos.any{producto => producto.nombre() == item.nombre() and producto.cantidad() >= item.cantidad()}}}
}

//compra
class Compra{
    const property pedido
    var valorEnvio
    const property fechaActual

    method sePuedeRealizar() = pedido.localTieneLosProductos()
    
    method precio(cliente) = pedido.precioNeto(cliente)
    
    method productoMasCaro(){pedido.productoMasCaro()}
    
    method productoMasPedido(){pedido.productoMasPedido()}
    
    method valorEnvio(cliente){valorEnvio = pedido.valorEnvio(cliente)}

    method ahorrado(cliente){pedido.valorRealEnvio(cliente) - valorEnvio}
}