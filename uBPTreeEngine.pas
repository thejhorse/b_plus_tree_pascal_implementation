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

  cNodoRama = class(cNodoHoja)
  private
    { Private declarations }
  public
    sListaValores: TList<String>;
    nNodoHijos: TList<cNodo>;
    constructor fnCreate(pNodoRaiz: cPNodo);
    function fnGetValorPorLlave(iLlave: Integer): String; override;
    procedure fnEliminarValorPorLlave(iLlave: Integer); override;
    procedure fnInsertarLlaveValor(iLlave: Integer; sValor: String); override;
    function fnObtenerHijoPorLlave(iLlave: Integer): cNodo;
  end;

  cArbolBPlus = class
  private
    { Private declarations }
  public
    nRaiz: cNodoRama;
    constructor fnCreate(iOrdenArbol: Integer);
    procedure fnInsertar(iLlave: Integer; sValor: String);
    procedure fnEliminar(iLlave: Integer);
    function fnBuscar(iLlave: Integer): string;
    function fnImprimir(): string;
  end;

var
  iOrden: Integer = 3;

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
  niNuevoRaiz: cNodoRama;
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

{ cNodoRama }

constructor cNodoRama.fnCreate(pNodoRaiz: cPNodo);
begin
  iListaLlaves := TList<Integer>.Create();
  nNodoHijos := TList<cNodo>.Create();
end;

procedure cNodoRama.fnEliminarValorPorLlave(iLlave: Integer);
begin
  inherited;

end;

function cNodoRama.fnGetValorPorLlave(iLlave: Integer): String;
begin
  Result := fnObtenerHijoPorLlave(iLlave).fnGetValorPorLlave(iLlave);
end;

procedure cNodoRama.fnInsertarLlaveValor(iLlave: Integer; sValor: String);
var
  iIndiceBuscado: Integer;
  bEncontrado : Boolean;
begin
  inherited;

  bEncontrado := iListaLlaves.BinarySearch(iLlave, iIndiceBuscado);

  if bEncontrado then
    iIndiceBuscado := iIndiceBuscado + 1;

end;

function cNodoRama.fnObtenerHijoPorLlave(iLlave: Integer): cNodo;
var
  bEncontrado: Boolean;
  iIndiceBuscado: Integer;
begin
  bEncontrado := iListaLlaves.BinarySearch(iLlave, iIndiceBuscado);

  if bEncontrado then
    iIndiceBuscado := iIndiceBuscado + 1;

  Result := nNodoHijos[iIndiceBuscado];
end;

{ cNodo }

function cNodo.fnGetCantidadLlaves(): Integer;
begin
  Result := iListaLlaves.Count;
end;

end.