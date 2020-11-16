unit uBPTreeEngine;

interface

uses System.SysUtils, System.Generics.Collections;

type
  cPNodo = ^cNodo;

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
    function fnDividir(): cNodo; override;
    function fnEstaDesbordado(): Boolean; override;
    function fnObtenerHijoPorLlave(iLlave: Integer): cNodo;
    procedure fnEliminarHijoPorLlave(iLlave: Integer);
    procedure fnInsertarHijoEnLLave(iLlave: Integer; child: cNodo);
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

{ cArbolBPlus }

constructor cArbolBPlus.fnCreate(iOrdenArbol: Integer);
begin
  iOrden := iOrdenArbol;

end;

procedure cArbolBPlus.fnEliminar(iLlave: Integer);
begin

end;

procedure cArbolBPlus.fnInsertar(iLlave: Integer; sValor: String);
begin
  nRaiz.fnInsertarLlaveValor(iLlave, sValor);
end;

function cArbolBPlus.fnBuscar(iLlave: Integer): string;
begin
  result := '';
end;

function cArbolBPlus.fnImprimir(): string;
begin

end;

{ cNodoHoja }

constructor cNodoHoja.fnCreate;
begin
  iListaLlaves := TList<Integer>.Create();
  sListaValores := TList<String>.Create();
end;

function cNodoHoja.fnDividir: cNodo;
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
begin

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

function cNodoIndice.fnDividir: cNodo;
begin

end;

procedure cNodoIndice.fnEliminarHijoPorLlave(iLlave: Integer);
begin

end;

procedure cNodoIndice.fnEliminarValorPorLlave(iLlave: Integer);
begin

end;

function cNodoIndice.fnEstaDesbordado: Boolean;
begin

end;

function cNodoIndice.fnGetValorPorLlave(iLlave: Integer): String;
begin
  Result := fnObtenerHijoPorLlave(iLlave).fnGetValorPorLlave(iLlave);
end;

procedure cNodoIndice.fnInsertarHijoEnLLave(iLlave: Integer; child: cNodo);
begin

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
begin

end;

function cNodoIndice.fnObtenerPrimeraLlave: Integer;
begin
  Result := nNodoHijos[0].fnObtenerPrimeraLlave();
end;

end.