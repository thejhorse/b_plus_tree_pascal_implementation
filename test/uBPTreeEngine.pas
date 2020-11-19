unit uBPTreeEngine;

{
  20/10/2020 - Initial write by Angel Aguilar Armendariz
}

interface

uses System.Generics.Collections, System.SysUtils, System.Classes;

type
  TNodo = class abstract
  private
    { Private declarations }
  public
    iListaLlaves: TList<Integer>;
    function fnGetCantidadLlaves(): Integer;
    function fnGetValorPorLlave(iLlave: Integer): String; Virtual; Abstract;
    procedure fnEliminarValorPorLlave(iLlave: Integer); Virtual; Abstract;
    procedure fnInsertarLlaveValor(iLlave: Integer; sValor: String); Virtual; Abstract;
    function fnObtenerPrimeraLlave(): Integer; Virtual; Abstract; // Obtener la llave de la primera hoja mas profunda
    function fnObtenerPrimerValor(): String; Virtual; Abstract; // Obtener el valor de la primera hoja mas profunda
    function fnObtenerUltimoValor(): String; Virtual; Abstract; // Obtener el ultimo valor de la hoja mas profunda
    function fnObtenerPrimerNodo(): TNodo; Virtual; Abstract;
    procedure fnUnir(nNodoHermano: TNodo); Virtual; Abstract;
    function fnDividir(): TNodo; Virtual; Abstract;
    function fnEstaDesbordado(): Boolean; Virtual; Abstract;
    function fnImprimir(var sCumulado: TStringList; iNivel: Integer = 0): string; Virtual; Abstract;
  end;

  TNodoIndice = class(TNodo)
  private
    { Private declarations }
  public
    nNodoHijos: TList<TNodo>;
    constructor fnCreate();
    function fnGetValorPorLlave(iLlave: Integer): String; override;
    procedure fnEliminarValorPorLlave(iLlave: Integer); override;
    procedure fnInsertarLlaveValor(iLlave: Integer; sValor: String); override;
    function fnObtenerPrimeraLlave(): Integer; override;
    function fnObtenerPrimerValor(): String; override;
    function fnObtenerUltimoValor(): String; override;
    function fnObtenerPrimerNodo(): TNodo; override;
    procedure fnUnir(nNodoHermano: TNodo); override;
    function fnDividir(): TNodo; override;
    function fnEstaDesbordado(): Boolean; override;
    function fnObtenerHijoPorLlave(iLlave: Integer): TNodo;
    procedure fnEliminarHijoPorLlave(iLlave: Integer);
    procedure fnInsertarHijoEnLLave(iLlave: Integer; child: TNodo);
    function fnObtenerNodoIzquierda(iLlave: Integer): TNodo;
    function fnObtenerNodoDerecha(iLlave: Integer): TNodo;
    function fnImprimir(var sCumulado: TStringList; iNivel: Integer = 0): string; override;
  end;

  TNodoHoja = class(TNodo)
  private
    { Private declarations }
  public
    sListaValores: TList<String>;
    nNodoHojaSiguiente: TNodoHoja;
    constructor fnCreate();
    function fnGetValorPorLlave(iLlave: Integer): String; override;
    procedure fnEliminarValorPorLlave(iLlave: Integer); override;
    procedure fnInsertarLlaveValor(iLlave: Integer; sValor: String); override;
    function fnObtenerPrimeraLlave(): Integer; override;
    function fnObtenerPrimerValor(): String; override;
    function fnObtenerUltimoValor(): String; override;
    function fnObtenerPrimerNodo(): TNodo; override;
    procedure fnUnir(nNodoHermano: TNodo); override;
    function fnDividir(): TNodo; override;
    function fnEstaDesbordado(): Boolean; override;
    function fnImprimir(var sCumulado: TStringList; iNivel: Integer = 0): string; override;
  end;

  TArbolBPlus = class
  private
    { Private declarations }
  public
    constructor fnCreate(iOrdenArbol: Integer);
    procedure fnInsertar(iLlave: Integer; sValor: String);
    procedure fnEliminar(iLlave: Integer);
    function fnBuscar(iLlave: Integer): string;
    function fnImprimir(): string;
    function fnPrimerValor(): string;
    function fnUltimoValor(): string;
    function fnRecorresHojas(): string;
  end;

var
  nRaiz: TNodo;
  iOrden: Integer = 3; // Maximo nro de hijos que puede terner / Factor de ramificacion

implementation

function fnSiString(bEstado: Boolean; sVerdad: String; sFalso: String): string;
begin
  if bEstado then
    Result := sVerdad
  else
    Result := sFalso;
end;

{ TNode }

function TNodo.fnGetCantidadLlaves(): Integer;
begin
  Result := iListaLlaves.Count;
end;

// -------------------------------------------------------------------------------------

{ TNodoIndice }

constructor TNodoIndice.fnCreate();
begin
  iListaLlaves := TList<Integer>.Create();
  nNodoHijos := TList<TNodo>.Create();
end;

function TNodoIndice.fnGetValorPorLlave(iLlave: Integer): String;
begin
  Result := fnObtenerHijoPorLlave(iLlave).fnGetValorPorLlave(iLlave);
end;

procedure TNodoIndice.fnEliminarValorPorLlave(iLlave: Integer);
var
  nHijo: TNodo;
  nNodoHermanoIzquierda: TNodo;
  nNodoHermanoDerecha: TNodo;
  nIzquierda: TNodo;
  nDerecha: TNodo;
  nNodoHermano: TNodo;
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

procedure TNodoIndice.fnInsertarLlaveValor(iLlave: Integer; sValor: String);
var
  nHijo        : TNodo;
  nNodoHermano : TNodo;
  niNuevoRaiz  : TNodoIndice;
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
    niNuevoRaiz := TNodoIndice.fnCreate();
    niNuevoRaiz.iListaLlaves.add(nNodoHermano.fnObtenerPrimeraLlave());
    niNuevoRaiz.nNodoHijos.add(self);
    niNuevoRaiz.nNodoHijos.add(nNodoHermano);
    nRaiz := niNuevoRaiz;
  end;
end;

function TNodoIndice.fnObtenerPrimeraLlave(): Integer;
begin
  Result := nNodoHijos[0].fnObtenerPrimeraLlave();
end;


function TNodoIndice.fnObtenerPrimerNodo(): TNodo;
begin
  Result := nNodoHijos[0].fnObtenerPrimerNodo();
end;

function TNodoIndice.fnObtenerPrimerValor(): String;
begin
  Result := nNodoHijos[0].fnObtenerPrimerValor();
end;

function TNodoIndice.fnObtenerUltimoValor(): String;
begin
  Result := nNodoHijos[nNodoHijos.Count - 1].fnObtenerUltimoValor();
end;

procedure TNodoIndice.fnUnir(nNodoHermano: TNodo);
var
  niNodo: TNodoIndice;
begin
  niNodo := TNodoIndice(nNodoHermano);
  iListaLlaves.add(niNodo.fnObtenerPrimeraLlave());
  iListaLlaves.AddRange(niNodo.iListaLlaves);
  nNodoHijos.AddRange(niNodo.nNodoHijos);
end;

function TNodoIndice.fnDividir(): TNodo;
var
  iDesde: Integer;
  iHasta: Integer;
  nNodoHermano: TNodoIndice;
  i: Integer;
begin
  iDesde := (fnGetCantidadLlaves() div 2) + 1;
  iHasta := fnGetCantidadLlaves();

  nNodoHermano := TNodoIndice.fnCreate();

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

function TNodoIndice.fnEstaDesbordado(): Boolean;
begin
  Result := nNodoHijos.Count > iOrden;
end;

function TNodoIndice.fnObtenerHijoPorLlave(iLlave: Integer): TNodo;
var
  bEncontrado: Boolean;
  iIndiceBuscado: Integer;
begin
  bEncontrado := iListaLlaves.BinarySearch(iLlave, iIndiceBuscado);

  if bEncontrado then
    iIndiceBuscado := iIndiceBuscado + 1;

  Result := nNodoHijos[iIndiceBuscado];
end;

procedure TNodoIndice.fnEliminarHijoPorLlave(iLlave: Integer);
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

procedure TNodoIndice.fnInsertarHijoEnLLave(iLlave: Integer; child: TNodo);
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

function TNodoIndice.fnObtenerNodoIzquierda(iLlave: Integer): TNodo;
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

function TNodoIndice.fnObtenerNodoDerecha(iLlave: Integer): TNodo;
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

function TNodoIndice.fnImprimir(var sCumulado: TStringList; iNivel: Integer): string;
var
  i: Integer;
  sLinea1: string;
begin
  if iListaLlaves.Count > 0 then
  begin
    for i := 0 to iListaLlaves.Count - 1 do
      sLinea1 := sLinea1 + fnSiString(i = 0, '', ', ') + IntToStr(iListaLlaves[i]);
    sLinea1 := '(' + sLinea1 + ')';
  end;

  if iNivel > sCumulado.Count then
    sCumulado.Add(sLinea1)
  else
    sCumulado[iNivel - 1] := sCumulado[iNivel - 1] + sLinea1;

  for i := 0 to nNodoHijos.Count - 1 do
  begin
    nNodoHijos[i].fnImprimir(sCumulado, iNivel + 1);
  end;

  Result := '';
end;


// XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
// NODO HOJA
// XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
{ TNodoHoja }

constructor TNodoHoja.fnCreate();
begin
  iListaLlaves := TList<Integer>.Create();
  sListaValores := TList<String>.Create();
end;

function TNodoHoja.fnGetValorPorLlave(iLlave: Integer): String;
var
  iIndiceBuscado: Integer;
begin
  if iListaLlaves.BinarySearch(iLlave, iIndiceBuscado) then
    Result := sListaValores[iIndiceBuscado]
  else
    Result := '';
end;

procedure TNodoHoja.fnEliminarValorPorLlave(iLlave: Integer);
var
  iIndiceBuscado: Integer;
begin
  if iListaLlaves.BinarySearch(iLlave, iIndiceBuscado) then
  begin
    iListaLlaves.Delete(iIndiceBuscado);
    sListaValores.Delete(iIndiceBuscado);
  end;
end;

procedure TNodoHoja.fnInsertarLlaveValor(iLlave: Integer; sValor: String);
var
  iIndiceBuscado: Integer;
  bEncontrado: Boolean;
  nNodoHermano: TNodo;
  niNuevoRaiz: TNodoIndice;
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
    niNuevoRaiz :=  TNodoIndice.fnCreate();
    niNuevoRaiz.iListaLlaves.add(nNodoHermano.fnObtenerPrimeraLlave());

    niNuevoRaiz.nNodoHijos.add(Self);
    niNuevoRaiz.nNodoHijos.add(nNodoHermano);
    nRaiz := niNuevoRaiz;
  end;
end;

function TNodoHoja.fnObtenerPrimeraLlave(): Integer;
begin
  Result := iListaLlaves[0];
end;

function TNodoHoja.fnObtenerPrimerNodo(): TNodo;
begin
  Result := Self;
end;

function TNodoHoja.fnObtenerPrimerValor: String;
begin
  Result := sListaValores[0];
end;

function TNodoHoja.fnObtenerUltimoValor(): String;
begin
  Result := sListaValores[sListaValores.Count - 1];
end;

procedure TNodoHoja.fnUnir(nNodoHermano: TNodo);
var
  niNodo: TNodoHoja;
begin
  niNodo := TNodoHoja(nNodoHermano);
  iListaLlaves.AddRange(niNodo.iListaLlaves);
  sListaValores.AddRange(niNodo.sListaValores);

  nNodoHojaSiguiente := niNodo.nNodoHojaSiguiente;
end;

function TNodoHoja.fnDividir(): TNodo;
var
  iDesde: Integer;
  iHasta: Integer;
  nNodoHermano: TNodoHoja;
  i: Integer;
begin
  nNodoHermano := TNodoHoja.fnCreate();

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

function TNodoHoja.fnEstaDesbordado(): Boolean;
begin
  Result := sListaValores.Count > iOrden - 1;
end;

function TNodoHoja.fnImprimir(var sCumulado: TStringList; iNivel: Integer): string;
var
  i: Integer;
  sLinea1: string;
begin
  if iListaLlaves.Count > 0 then
  begin
    for i := 0 to iListaLlaves.Count - 1 do
      sLinea1 := sLinea1 + fnSiString(i = 0, '', ', ') + IntToStr(iListaLlaves[i]);
    sLinea1 := '(' + sLinea1 + ')';
  end;

  if iNivel > sCumulado.Count then
    sCumulado.Add(sLinea1)
  else
    sCumulado[iNivel - 1] := sCumulado[iNivel - 1] + sLinea1;

  Result := '';
end;

// XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
// ARBOL
// XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
{ TArbolBPlus }

constructor TArbolBPlus.fnCreate(iOrdenArbol: Integer);
begin
  iOrden := iOrdenArbol; // El orden debe ser mayor a 2
  nRaiz := TNodoHoja.fnCreate();
end;

procedure TArbolBPlus.fnEliminar(iLlave: Integer);
begin
  nRaiz.fnEliminarValorPorLlave(iLlave);
end;

procedure TArbolBPlus.fnInsertar(iLlave: Integer; sValor: String);
begin
  nRaiz.fnInsertarLlaveValor(iLlave, sValor);
end;

function TArbolBPlus.fnBuscar(iLlave: Integer): string;
begin
  Result := nRaiz.fnGetValorPorLlave(iLlave);
end;

function TArbolBPlus.fnImprimir(): string;
var
  sResultado: TStringList;
begin
  sResultado := TStringList.Create();
  //Result := nRaiz.fnImprimir(sResultado, 1);
  nRaiz.fnImprimir(sResultado, 1);
  Result := sResultado.Text;
  sResultado.Free();
end;

function TArbolBPlus.fnPrimerValor(): string;
begin
  Result := nRaiz.fnObtenerPrimerValor();
end;

function TArbolBPlus.fnUltimoValor(): string;
begin
  Result := nRaiz.fnObtenerUltimoValor();
end;

function TArbolBPlus.fnRecorresHojas(): string;
var
  nNodoSiguiente: TNodoHoja;
  sLinea: string;
  function fniValores(nHojita: TNodoHoja): string;
  var
    i: Integer;
    sResultado: string;
  begin
    if nHojita.sListaValores.Count > 0 then
    begin
      for i := 0 to nHojita.sListaValores.Count - 1 do
        sResultado := sResultado + fnSiString(i = 0, '', ', ') + nHojita.sListaValores[i];

      Result := '(' + sResultado + ')';
    end;
  end;
begin
  nNodoSiguiente := TNodoHoja(nRaiz.fnObtenerPrimerNodo());

  Result := fniValores(nNodoSiguiente);

  while Assigned(nNodoSiguiente.nNodoHojaSiguiente) do
  begin
    nNodoSiguiente := nNodoSiguiente.nNodoHojaSiguiente;

    sLinea := '->' + fniValores(nNodoSiguiente);
    Result := Result + sLinea;
  end;
end;

end.
