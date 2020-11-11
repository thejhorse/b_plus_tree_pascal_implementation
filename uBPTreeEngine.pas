unit uBPTreeEngine;

interface

uses Winapi.Windows, System.SysUtils;

type
  cNodo = class
  private
    { Private declarations }
  public
    { Public declarations }
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

implementation

{ cArbolBPlus }

constructor cArbolBPlus.fnCreate(iOrdenArbol: Integer);
begin

end;

procedure cArbolBPlus.fnEliminar(iLlave: Integer);
begin

end;

procedure cArbolBPlus.fnInsertar(iLlave: Integer; sValor: String);
begin

end;

function cArbolBPlus.fnBuscar(iLlave: Integer): string;
begin
  result := '';
end;

function cArbolBPlus.fnImprimir(): string;
begin

end;

end.
