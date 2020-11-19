unit uBPTreeEngine;

interface

uses System.SysUtils, System.Generics.Collections;

type
  cNodo = class abstract
  private
    { Private declarations }
  public
    iListaLlaves: TList<Integer>;
    function fnGetCantidadLlaves(): Integer;
    function fnGetValorPorLlave(iLlave: Integer): String; Virtual; Abstract;
    procedure fnEliminarValorPorLlave(iLlave: Integer); Virtual; Abstract;
    procedure fnInsertarLlaveValor(iLlave: Integer; sValor: String); Virtual; Abstract;
    function fnObtenerPrimeraLlave(): Integer; Virtual; Abstract; // Obtener la llave de la primera hoja mas profunda
    procedure fnUnir(nNodoHermano: cNodo); Virtual; Abstract;
    function fnDividir(): cNodo; Virtual; Abstract;
    function fnEstaDesbordado(): Boolean; Virtual; Abstract;
    function fnImprimir(sCumulado: string): string; Virtual; Abstract;
  end;

  cNodoIndice = class(cNodo)
  private
    { Private declarations }
  public
    nNodoHijos: TList<cNodo>;
    constructor fnCreate();
    function fnGetValorPorLlave(iLlave: Integer): String; override;
    procedure fnEliminarValorPorLlave(iLlave: Integer); override;
    procedure fnInsertarLlaveValor(iLlave: Integer; sValor: String); override;
    function fnObtenerPrimeraLlave(): Integer; override;
    procedure fnUnir(nNodoHermano: cNodo); override;
    function fnDividir(): cNodo; override;
    function fnEstaDesbordado(): Boolean; override;
    function fnObtenerHijoPorLlave(iLlave: Integer): cNodo;
    procedure fnEliminarHijoPorLlave(iLlave: Integer);
    procedure fnInsertarHijoEnLLave(iLlave: Integer; child: cNodo);
    function fnObtenerNodoIzquierda(iLlave: Integer): cNodo;
    function fnObtenerNodoDerecha(iLlave: Integer): cNodo;
  end;

  cNodoHoja = class(cNodo)
  private
    { Private declarations }
  public
    sListaValores: TList<String>;
    nNodoHojaSiguiente: cNodoHoja;
    constructor fnCreate();
    function fnGetValorPorLlave(iLlave: Integer): String; override;
    procedure fnEliminarValorPorLlave(iLlave: Integer); override;
    procedure fnInsertarLlaveValor(iLlave: Integer; sValor: String); override;
    function fnObtenerPrimeraLlave(): Integer; override;
    function fnDividir(): cNodo; override;
    function fnEstaDesbordado(): Boolean; override;
  end;

  cArbolBPlus = class
  private
    { Private declarations }
  public
    constructor fnCreate(iOrdenArbol: Integer);
    procedure fnInsertar(iLlave: Integer; sValor: String);
    procedure fnEliminar(iLlave: Integer);
    function fnBuscar(iLlave: Integer): string;
    function fnImprimir(): string;
  end;

var
  iOrden: Integer = 3;
  nRaiz: cNodoIndice;

implementation

{ cNodo }

function cNodo.fnGetCantidadLlaves(): Integer;
begin
  Result := iListaLlaves.Count;
end;

{ cNodoIndice }

constructor cNodoIndice.fnCreate;
begin
  iListaLlaves := TList<Integer>.Create();
  nNodoHijos := TList<cNodo>.Create();
end;

procedure cNodoIndice.fnUnir(nNodoHermano: cNodo);
var
  niNodo: cNodoIndice;
begin
  niNodo := cNodoIndice(nNodoHermano);
  iListaLlaves.add(niNodo.fnObtenerPrimeraLlave());
  iListaLlaves.AddRange(niNodo.iListaLlaves);
  nNodoHijos.AddRange(niNodo.nNodoHijos);
end;

function cNodoIndice.fnDividir: cNodo;
var
  iDesde: Integer;
  iHasta: Integer;
  nNodoHermano: cNodoIndice;
  i: Integer;
begin
  iDesde := (fnGetCantidadLlaves() div 2) + 1;
  iHasta := fnGetCantidadLlaves();

  nNodoHermano := cNodoIndice.fnCreate();

  for i := iDesde to iHasta - 1 do
  begin
    nNodoHermano.iListaLlaves.Add(iListaLlaves[i]);
    nNodoHermano.nNodoHijos.Add(nNodoHijos[i]);
  end;
  nNodoHermano.nNodoHijos.Add(nNodoHijos[iHasta]);

  iListaLlaves.DeleteRange(iDesde - 1, iHasta - iDesde + 1);
  nNodoHijos.DeleteRange(iDesde, iHasta - iDesde + 1);

  Result := nNodoHermano;
end;

procedure cNodoIndice.fnEliminarHijoPorLlave(iLlave: Integer);
var
  iIndiceBuscado: Integer;
begin
  if iListaLlaves.BinarySearch(iLlave, iIndiceBuscado) then
  begin
    iListaLlaves.Delete(iIndiceBuscado);
    //nNodoHijos.Delete(iIndiceBuscado + 1);
    nNodoHijos[iIndiceBuscado + 1].Free();
  end;
end;

function cNodoIndice.fnObtenerNodoIzquierda(iLlave: Integer): cNodo;
var
  iIndiceBuscado: Integer;
begin
  if iListaLlaves.BinarySearch(iLlave, iIndiceBuscado) then
    iIndiceBuscado := iIndiceBuscado + 1;

  if iIndiceBuscado > 0 then
  begin
    Result := nNodoHijos[iIndiceBuscado - 1];
    Exit;
  end;

  Result := nil;
end;

function cNodoIndice.fnObtenerNodoDerecha(iLlave: Integer): cNodo;
var
  iIndiceBuscado: Integer;
begin
  if iListaLlaves.BinarySearch(iLlave, iIndiceBuscado) then
    iIndiceBuscado := iIndiceBuscado + 1;

  if iIndiceBuscado < fnGetCantidadLlaves() then
  begin
    Result := nNodoHijos[iIndiceBuscado + 1];
    Exit;
  end;

  Result := nil;
end;

procedure cNodoIndice.fnEliminarValorPorLlave(iLlave: Integer);
var
  nHijo: cNodo;
  nNodoHermanoIzquierda: cNodo;
  nNodoHermanoDerecha: cNodo;
  nIzquierda: cNodo;
  nDerecha: cNodo;
  nNodoHermano: cNodo;
begin
  nHijo := fnObtenerHijoPorLlave(iLlave);
  nHijo.fnEliminarValorPorLlave(iLlave);

  if nNodoHijos.Count < (iOrden + 1) / 2 then
  begin
    nNodoHermanoIzquierda := fnObtenerNodoIzquierda(iLlave);
    nNodoHermanoDerecha := fnObtenerNodoDerecha(iLlave);

    if Assigned(nNodoHermanoIzquierda) then
      nIzquierda := nNodoHermanoIzquierda
    else
      nIzquierda := nHijo;

    if Assigned(nNodoHermanoIzquierda) then
      nDerecha := nHijo
    else
      nDerecha := nNodoHermanoDerecha;

    nIzquierda.fnUnir(nDerecha);
    fnEliminarHijoPorLlave(nDerecha.fnObtenerPrimeraLlave());

    if nIzquierda.fnEstaDesbordado() then
    begin
      nNodoHermano := nIzquierda.fnDividir();
      fnInsertarHijoEnLLave(nNodoHermano.fnObtenerPrimeraLlave(), nNodoHermano);
    end;

    if nRaiz.fnGetCantidadLlaves() = 0 then
      nRaiz := nIzquierda;
  end;
end;

function cNodoIndice.fnEstaDesbordado: Boolean;
begin
  Result := nNodoHijos.Count > iOrden;
end;

function cNodoIndice.fnGetValorPorLlave(iLlave: Integer): String;
begin
  Result := fnObtenerHijoPorLlave(iLlave).fnGetValorPorLlave(iLlave);
end;

procedure cNodoIndice.fnInsertarHijoEnLLave(iLlave: Integer; child: cNodo);
var
  iIndiceBuscado: Integer;
  bEncontrado : Boolean;
begin
  bEncontrado := iListaLlaves.BinarySearch(iLlave, iIndiceBuscado);

  if bEncontrado then
    iIndiceBuscado := iIndiceBuscado + 1;

  if bEncontrado then
  begin
    nNodoHijos[iIndiceBuscado] := child;
  end
  else
  begin
    iListaLlaves.Insert(iIndiceBuscado, iLlave);
    nNodoHijos.Insert(iIndiceBuscado + 1, child);
  end;
end;

procedure cNodoIndice.fnInsertarLlaveValor(iLlave: Integer; sValor: String);
var
  nHijo        : cNodo;
  nNodoHermano : cNodo;
  niNuevoRaiz  : cNodoIndice;
begin
  nHijo := fnObtenerHijoPorLlave(iLlave);
  nHijo.fnInsertarLlaveValor(iLlave, sValor);

  if nHijo.fnEstaDesbordado() then
  begin
    nNodoHermano := nHijo.fnDividir();
    fnInsertarHijoEnLLave(nNodoHermano.fnObtenerPrimeraLlave(), nNodoHermano);
  end;

  if nRaiz.fnEstaDesbordado() then
  begin
    nNodoHermano := fnDividir();
    niNuevoRaiz := cNodoIndice.fnCreate();
    niNuevoRaiz.iListaLlaves.add(nNodoHermano.fnObtenerPrimeraLlave());
    niNuevoRaiz.nNodoHijos.add(self);
    niNuevoRaiz.nNodoHijos.add(nNodoHermano);
    nRaiz := niNuevoRaiz;
  end;
end;

function cNodoIndice.fnObtenerHijoPorLlave(iLlave: Integer): cNodo;
var
  bEncontrado: Boolean;
  iIndiceBuscado: Integer;
begin
  bEncontrado := iListaLlaves.BinarySearch(iLlave, iIndiceBuscado);

  if bEncontrado then
    iIndiceBuscado := iIndiceBuscado + 1;

  Result := nNodoHijos[iIndiceBuscado];
end;

function cNodoIndice.fnObtenerPrimeraLlave: Integer;
begin
  Result := nNodoHijos[0].fnObtenerPrimeraLlave();
end;

{ cNodoHoja }

constructor cNodoHoja.fnCreate();
begin
  iListaLlaves := TList<Integer>.Create();
  sListaValores := TList<String>.Create();
end;

function cNodoHoja.fnDividir(): cNodo;
var
  iDesde: Integer;
  iHasta: Integer;
  nNodoHermano: cNodoHoja;
  i: Integer;
begin
  nNodoHermano := cNodoHoja.fnCreate();

  iDesde := (fnGetCantidadLlaves() + 1) div 2;
  iHasta := fnGetCantidadLlaves();

  for i := iDesde to iHasta - 1 do
  begin
    nNodoHermano.iListaLlaves.Add(iListaLlaves[i]);
    nNodoHermano.sListaValores.Add(sListaValores[i]);
  end;

  iListaLlaves.DeleteRange(iDesde, iHasta - iDesde);
  sListaValores.DeleteRange(iDesde, iHasta - iDesde);

  nNodoHermano.nNodoHojaSiguiente := nNodoHojaSiguiente;
  nNodoHojaSiguiente := nNodoHermano;

  Result := nNodoHermano;
end;

procedure cNodoHoja.fnEliminarValorPorLlave(iLlave: Integer);
var
  iIndiceBuscado: Integer;
begin
  if iListaLlaves.BinarySearch(iLlave, iIndiceBuscado) then
  begin
    iListaLlaves.Delete(iIndiceBuscado);
    sListaValores.Delete(iIndiceBuscado);
  end;
end;

function cNodoHoja.fnEstaDesbordado: Boolean;
begin
  Result := sListaValores.Count > iOrden - 1;
end;

function cNodoHoja.fnGetValorPorLlave(iLlave: Integer): String;
var
  iIndiceBuscado: Integer;
begin
  if iListaLlaves.BinarySearch(iLlave, iIndiceBuscado) then
    Result := sListaValores[iIndiceBuscado]
  else
    Result := '';
end;

procedure cNodoHoja.fnInsertarLlaveValor(iLlave: Integer; sValor: String);
var
  iIndiceBuscado: Integer;
  bEncontrado: Boolean;
  nNodoHermano: cNodo;
  niNuevoRaiz: cNodoIndice;
begin
  bEncontrado := iListaLlaves.BinarySearch(iLlave, iIndiceBuscado);

  if bEncontrado then
    sListaValores[iIndiceBuscado] := sValor
  else
  begin
    iListaLlaves.Insert(iIndiceBuscado, iLlave);
    sListaValores.Insert(iIndiceBuscado, sValor);
  end;

  if nRaiz.fnEstaDesbordado() then
  begin
    nNodoHermano := fnDividir();
    niNuevoRaiz :=  cNodoIndice.fnCreate();
    niNuevoRaiz.iListaLlaves.add(nNodoHermano.fnObtenerPrimeraLlave());

    niNuevoRaiz.nNodoHijos.add(Self);
    niNuevoRaiz.nNodoHijos.add(nNodoHermano);
    nRaiz := niNuevoRaiz;
  end;
end;

function cNodoHoja.fnObtenerPrimeraLlave: Integer;
begin
  Result := iListaLlaves[0];
end;

{ cArbolBPlus }

constructor cArbolBPlus.fnCreate(iOrdenArbol: Integer);
begin
  iOrden := iOrdenArbol; // El orden debe ser mayor a 2
  nRaiz := cNodoHoja.fnCreate();
end;

procedure cArbolBPlus.fnEliminar(iLlave: Integer);
begin
  nRaiz.fnEliminarValorPorLlave(iLlave);
end;

procedure cArbolBPlus.fnInsertar(iLlave: Integer; sValor: String);
begin
  nRaiz.fnInsertarLlaveValor(iLlave, sValor);
end;

function cArbolBPlus.fnBuscar(iLlave: Integer): string;
begin
  Result := nRaiz.fnGetValorPorLlave(iLlave);
end;

function cArbolBPlus.fnImprimir(): string;
begin

end;

end.