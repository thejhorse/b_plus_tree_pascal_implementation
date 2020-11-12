unit uBPTreeEngine;

interface

uses System.SysUtils, System.Generics.Collections;

type
  cPNodo = ^cNodo;

  cNodo = class abstract
  private
    iListaLlaves: TList<Integer>;
  public
    function fnGetValorPorLlave(iLlave: Integer): String; Virtual; Abstract;
    procedure fnEliminarValorPorLlave(iLlave: Integer); Virtual; Abstract;
    procedure fnInsertarLlaveValor(iLlave: Integer; sValor: String); Virtual; Abstract;
  end;

  cNodoHoja = class(cNodo)
  private
    { Private declarations }
  public
    sListaValores: TList<String>;
    constructor fnCreate(pNodoRaiz: cPNodo);
    function fnGetValorPorLlave(iLlave: Integer): String; override;
    procedure fnEliminarValorPorLlave(iLlave: Integer); override;
    procedure fnInsertarLlaveValor(iLlave: Integer; sValor: String); override;
  end;

  cNodoRama = class(cNodoHoja)
  private
    { Private declarations }
  public
    sListaValores: TList<String>;
    constructor fnCreate(pNodoRaiz: cPNodo);
    function fnGetValorPorLlave(iLlave: Integer): String; override;
    procedure fnEliminarValorPorLlave(iLlave: Integer); override;
    procedure fnInsertarLlaveValor(iLlave: Integer; sValor: String); override;
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

procedure cNodoHoja.fnEliminarValorPorLlave(iLlave: Integer);
begin

end;

function cNodoHoja.fnGetValorPorLlave(iLlave: Integer): String;
begin

end;

procedure cNodoHoja.fnInsertarLlaveValor(iLlave: Integer; sValor: String);
var
  iIndiceBuscado: Integer;
  bEncontrado: Boolean;
begin
  bEncontrado := iListaLlaves.BinarySearch(iLlave, iIndiceBuscado);

  if bEncontrado then
    sListaValores[iIndiceBuscado] := sValor
  else
  begin
    iListaLlaves.Insert(iIndiceBuscado, iLlave);
    sListaValores.Insert(iIndiceBuscado, sValor);
  end;

end;

{ cNodoRama }

constructor cNodoRama.fnCreate(pNodoRaiz: cPNodo);
begin

end;

procedure cNodoRama.fnEliminarValorPorLlave(iLlave: Integer);
begin
  inherited;

end;

function cNodoRama.fnGetValorPorLlave(iLlave: Integer): String;
begin

end;

procedure cNodoRama.fnInsertarLlaveValor(iLlave: Integer; sValor: String);
begin
  inherited;

end;

end.
