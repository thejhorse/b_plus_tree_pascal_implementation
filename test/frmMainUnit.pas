unit frmMainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBPTreeEngine, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    txtResultado: TMemo;
    Panel1: TPanel;
    Label3: TLabel;
    seOrden: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    txtLlave: TEdit;
    txtValor: TEdit;
    btnInsertar: TButton;
    btnEliminar: TButton;
    btnConsultar: TButton;
    btnTesteo: TButton;
    btnPrimero: TButton;
    btnUltimo: TButton;
    btnCrearArbol: TButton;
    btnDestruirArbol: TButton;
    btnImprimir: TButton;
    btnRecorrerHojas: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnInsertarClick(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnCrearArbolClick(Sender: TObject);
    procedure btnDestruirArbolClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnPrimeroClick(Sender: TObject);
    procedure btnUltimoClick(Sender: TObject);
    procedure btnRecorrerHojasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure fnHabilitarTodo();
    procedure fnDeshabilitarTodo();
    procedure fnAgregarLog(sMensaje: string);
  end;

var
  frmMain: TfrmMain;
  ArbolBP: TArbolBPlus;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  txtResultado.Align := alClient;
  fnDeshabilitarTodo();
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
end;

procedure TfrmMain.btnCrearArbolClick(Sender: TObject);
begin
  seOrden.Enabled := False;
  ArbolBP := TArbolBPlus.fnCreate(seOrden.Value);
  fnHabilitarTodo();
  txtLlave.SetFocus();
  fnAgregarLog('Arbol B+ Creado');
end;

procedure TfrmMain.btnDestruirArbolClick(Sender: TObject);
begin
  ArbolBP.Free();
  seOrden.Enabled := True;
  fnDeshabilitarTodo();
  seOrden.SetFocus();
  fnAgregarLog('--------------------------------------------------------');
  fnAgregarLog('Arbol B+ Destruido');
end;

procedure TfrmMain.fnAgregarLog(sMensaje: string);
begin
  txtResultado.Lines.Add(sMensaje)
end;

procedure TfrmMain.fnDeshabilitarTodo();
begin
  txtLlave.Enabled := False;
  txtValor.Enabled := False;
  btnCrearArbol.Enabled := True;
  btnDestruirArbol.Enabled := False;
  btnInsertar.Enabled := False;
  btnEliminar.Enabled := False;
  btnConsultar.Enabled := False;
  btnPrimero.Enabled := False;
  btnUltimo.Enabled := False;
  btnImprimir.Enabled := False;
  btnRecorrerHojas.Enabled := False;
end;

procedure TfrmMain.fnHabilitarTodo();
begin
  txtLlave.Enabled := True;
  txtValor.Enabled := True;
  btnCrearArbol.Enabled := False;
  btnDestruirArbol.Enabled := True;
  btnInsertar.Enabled := True;
  btnEliminar.Enabled := True;
  btnConsultar.Enabled := True;
  btnPrimero.Enabled := True;
  btnUltimo.Enabled := True;
  btnImprimir.Enabled := True;
  btnRecorrerHojas.Enabled := True;
end;

procedure TfrmMain.btnInsertarClick(Sender: TObject);
begin
  ArbolBP.fnInsertar(StrToInt(txtLlave.Text), txtValor.Text);
  fnAgregarLog('Insertado Llave='+txtLlave.Text+' Valor='+txtValor.Text);
  //txtLlave.Clear();
  txtLlave.Text := IntToStr(StrToInt(txtLlave.Text) + 1);
  //txtValor.Clear();
  txtValor.Text := 'Valor_' + txtLlave.Text;
  txtLlave.SetFocus();
end;

procedure TfrmMain.btnEliminarClick(Sender: TObject);
begin
  ArbolBP.fnEliminar(StrToInt(txtLlave.Text));
  fnAgregarLog('Eliminado llave=' + txtLlave.Text);
  txtLlave.Clear();
  txtValor.Clear();
  txtLlave.SetFocus();
end;

procedure TfrmMain.btnConsultarClick(Sender: TObject);
begin
  fnAgregarLog('Buscar Llave=' + txtLlave.Text + ' Resultado:' + ArbolBP.fnBuscar(StrToInt(txtLlave.Text)));
  txtLlave.SetFocus();
end;

procedure TfrmMain.btnImprimirClick(Sender: TObject);
begin
  fnAgregarLog('Imprimir arbol ' + sLineBreak + ArbolBP.fnImprimir());
end;

procedure TfrmMain.btnPrimeroClick(Sender: TObject);
begin
  fnAgregarLog('Primer valor: ' + ArbolBP.fnPrimerValor());
end;

procedure TfrmMain.btnUltimoClick(Sender: TObject);
begin
  fnAgregarLog('Ultimo valor: ' + ArbolBP.fnUltimoValor());
end;

procedure TfrmMain.btnRecorrerHojasClick(Sender: TObject);
begin
  fnAgregarLog('Recorrer Hojas mostrando valor ' + sLineBreak + ArbolBP.fnRecorresHojas());
end;

end.
