create database parcial1;
use parcial1;
create table cliente(
	idCliente int(3),
    nombre varchar(40),
    apellido varchar(40),
    direccion varchar(50),
    estatus int(1)
);
alter table cliente add primary key(idCliente);

create table telefonoCliente(
	idCliente int(3),
    telefonoCliente int(8),
    estatus int(1)
);
alter table telefonoCliente add primary key(idCliente,telefonoCliente);
alter table telefonoCliente add constraint fktelcliente foreign key (idCliente) references cliente(idCliente);

create table correoCliente(
	idCliente int(3),
    correoProv varchar(30),
	estatus int(1)
);
alter table correoCliente add primary key(idCliente,correoCliente);
alter table correoCliente add constraint fkcorreocliente foreign key (idCliente) references cliente(idCliente);

create table puesto(
	idPuesto int(3),
    puesto varchar(40),
    salarioBase double(10,2),
    estatus int(1)
);
alter table puesto add primary key(idPuesto);

create table empleado(
	idEmpleado int(3),
    nombre varchar(40),
    apellido varchar(40),
    fechaNacimiento date,
    fechaContratacion date,
    direccion varchar(50),
    idPuesto int(3),
    estatus int(1)
);
alter table empleado add primary key(idEmpleado);
alter table empleado add constraint fkemppuesto foreign key (idPuesto) references puesto(idPuesto);

create table telefonoEmp(
	idEmp int(3),
    telefonoEmp int(8),
    estatus int(1)
);
alter table telefonoEmp add primary key(idEmp,telefonoEmp);
alter table telefonoEmp add constraint fktelemp foreign key (idEmp) references empleado(idEmpleado);

create table correoEmp(
	idEmp int(3),
    correoProv varchar(30),
	estatus int(1)
);
alter table correoEmp add primary key(idEmp,correoEmp);
alter table correoEmp add constraint fkcorreoemp foreign key (idEmp) references empleado(idEmpleado);

create table proveedor(
	idProveedor int(3),
    nombre varchar(40),
    apellido varchar(40),
    direccion varchar(50),
    estatus int(1)
);
alter table proveedor add primary key(idProveedor);

create table telefonoProv(
	idProv int(3),
    telefonoProv int(8),
    estatus int(1)
);
alter table telefonoProv add primary key(idProv,telefonoProv);
alter table telefonoProv add constraint fktelprov foreign key (idProv) references proveedor(idProveedor);

create table correoProv(
	idProv int(3),
    correoProv varchar(30),
	estatus int(1)
);
alter table correoProv add primary key(idProv,correoProv);
alter table correoProv add constraint fkcorreoprov foreign key (idProv) references proveedor(idProveedor);

create table producto(
	idProducto int(3),
    nombre varchar(40),
    descripcion varchar(100),
    precioVenta double(8,2),
    estatus int(1)
);
alter table producto add primary key(idProducto);

create table productoProveedor(
	idProd int(3),
    idProv int(3),
    precioCompra double(8,2)
);
alter table productoProveedor add primary key(idProd,idProv);
alter table productoProveedor add constraint fkprodprov foreign key (idProd) references producto(idProducto);
alter table productoProveedor add constraint fkprov foreign key (idProv) references proveedor(idProveedor);

create table inventarioEncabezado(
	idInv int(3),
    fecha date,
	idEmp int(3)
);
alter table inventarioEncabezado add primary key(idInv);
alter table inventarioEncabezado add constraint fkinvemp foreign key (idInv) references empleado(idEmpleado);

create table inventarioDetalle(
	idInv int(3),
    idProducto int(3),
	cantidad int(8)
);
alter table inventarioDetalle add primary key(idInv,idProducto);
alter table inventarioDetalle add constraint fkinv foreign key (idInv) references inventarioEncabezado(idInv);
alter table inventarioDetalle add constraint fkinvprod foreign key (idProducto) references producto(idProducto);

create table cotizacionEncabezado(
	idCot int(3),
    idEmp int(3),
    fechaRealizada date,
    fechaExpiracion date,
    idCliente int(3),
    estatus int(1)
);
alter table cotizacionEncabezado add primary key(idCot);
alter table cotizacionEncabezado add constraint fkcotemp foreign key (idEmp) references empleado(idEmpleado);
alter table cotizacionEncabezado add constraint fkcotcliente foreign key (idCliente) references cliente(idCliente);

create table cotizacionDetalle(
	idCot int(3),
    idProducto int(3),
	cantidad int(8)
);
alter table cotizacionDetalle add primary key(idCot,idProducto);
alter table cotizacionDetalle add constraint fkcot foreign key (idCot) references cotizacionEncabezado(idCot);
alter table cotizacionDetalle add constraint fkcotprod foreign key (idProducto) references producto(idProducto);

create table pedidoEncabezado(
	idPed int(3),
    idEmp int(3),
    fechaRealizada date,
    idCliente int(3),
    entregado int(1),
    estatus int(1)
);
alter table pedidoEncabezado add primary key(idPed);
alter table pedidoEncabezado add constraint fkpedemp foreign key (idEmp) references empleado(idEmpleado);
alter table pedidoEncabezado add constraint fkpedcliente foreign key (idCliente) references cliente(idCliente);

create table pedidoDetalle(
	idPed int(3),
    idProducto int(3),
	cantidad int(8)
);
alter table pedidoDetalle add primary key(idPed,idProducto);
alter table pedidoDetalle add constraint fkped foreign key (idPed) references pedidoEncabezado(idPed);
alter table pedidoDetalle add constraint fkpedprod foreign key (idProducto) references producto(idProducto);

create table facturaContadoEncabezado(
	idFacCont int(3),
    idEmp int(3),
    serie varchar(5),
    fechaRealizada date,
    idCliente int(3),
    estatus int(1)
);
alter table facturaContadoEncabezado add primary key(idFacCont);
alter table facturaContadoEncabezado add constraint fkfaccontemp foreign key (idEmp) references empleado(idEmpleado);
alter table facturaContadoEncabezado add constraint fkfaccontcliente foreign key (idCliente) references cliente(idCliente);

create table facturaContadoDetalle(
	idFacCont int(3),
    idProducto int(3),
	cantidad int(8)
);
alter table facturaContadoDetalle add primary key(idFacCont,idProducto);
alter table facturaContadoDetalle add constraint fkfaccont foreign key (idFacCont) references facturaContadoEncabezado(idFacCont);
alter table facturaContadoDetalle add constraint fkfaccontprod foreign key (idProducto) references producto(idProducto);

create table facturaDebitoEncabezado(
	idFacDeb int(3),
    idEmp int(3),
    serie varchar(5),
    plazoDias int(5),
    claveAprobacion varchar(10),
    fechaRealizada date,
    idCliente int(3),
    estatus int(1)
);
alter table facturaDebitoEncabezado add primary key(idFacDeb);
alter table facturaDebitoEncabezado add constraint fkfacdebemp foreign key (idEmp) references empleado(idEmpleado);
alter table facturaDebitoEncabezado add constraint fkfacdebcliente foreign key (idCliente) references cliente(idCliente);

create table facturaDebadoDetalle(
	idFacDeb int(3),
    idProducto int(3),
	cantidad int(8)
);
alter table facturaDebadoDetalle add primary key(idFacDeb,idProducto);
alter table facturaDebadoDetalle add constraint fkfacdeb foreign key (idFacDeb) references facturaDebitoEncabezado(idFacDeb);
alter table facturaDebadoDetalle add constraint fkfacdebprod foreign key (idProducto) references producto(idProducto);


create table tipoComision(
	idTipoCom int(3),
    nombre varchar(20)
);
alter table tipoComision add primary key(idTipoCom);

create table comision(
	idCom int(3),
    idEmp int(3),
    idTipoComision int(3),
	cantidad int(8)
);
alter table comision add primary key(idCom);
alter table comision add constraint fkcomemp foreign key (idEmp) references empleado(idEmpleado);
alter table comision add constraint fkftipocom foreign key (idTipoComision) references tipoComision(idTipoCom);

create table cobros(
	idFacDeb int(3),
    idEmp int(3),
    cantidadAbonada double(8,2)
);
alter table cobros add primary key(idFacDeb,idEmp);
alter table cobros add constraint fkcobrosemp foreign key (idEmp) references empleado(idEmpleado);

create table compraEncabezado(
	idCompra int(3),
    idEmp int(3),
    fechaRealizada date,
    pago int(1),
    idProv int(3),
    estatus int(1)
);
alter table compraEncabezado add primary key(idCompra);
alter table compraEncabezado add constraint fkcompraemp foreign key (idEmp) references empleado(idEmpleado);
alter table compraEncabezado add constraint fkcompracliente foreign key (idProv) references proveedor(idProveedor);

create table compraDetalle(
	idCompra int(3),
    idProducto int(3),
	cantidad int(8)
);
alter table compraDetalle add primary key(idCompra,idProducto);
alter table compraDetalle add constraint fkcompra foreign key (idCompra) references compraEncabezado(idCompra);
alter table compraDetalle add constraint fkcompradetprod foreign key (idProducto) references producto(idProducto);

