object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'B+ Tree'
  ClientHeight = 597
  ClientWidth = 785
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object txtResultado: TMemo
    Left = 23
    Top = 243
    Width = 592
    Height = 289
    TabStop = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 785
    Height = 166
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label3: TLabel
      Left = 23
      Top = 17
      Width = 37
      Height = 13
      Caption = 'Orden :'
    end
    object Label1: TLabel
      Left = 172
      Top = 17
      Width = 32
      Height = 13
      Caption = 'Llave :'
    end
    object Label2: TLabel
      Left = 311
      Top = 17
      Width = 31
      Height = 13
      Caption = 'Valor :'
    end
    object seOrden: TSpinEdit
      Left = 72
      Top = 14
      Width = 64
      Height = 22
      MaxValue = 999
      MinValue = 3
      TabOrder = 0
      Value = 4
    end
    object txtLlave: TEdit
      Left = 210
      Top = 14
      Width = 76
      Height = 21
      NumbersOnly = True
      TabOrder = 1
      Text = '100'
    end
    object txtValor: TEdit
      Left = 354
      Top = 14
      Width = 70
      Height = 21
      TabOrder = 2
      Text = 'Valor_100'
    end
    object btnInsertar: TButton
      Left = 26
      Top = 89
      Width = 120
      Height = 29
      Caption = 'Insertar'
      TabOrder = 6
      OnClick = btnInsertarClick
    end
    object btnEliminar: TButton
      Left = 152
      Top = 89
      Width = 120
      Height = 29
      Caption = 'Eliminar'
      TabOrder = 7
      OnClick = btnEliminarClick
    end
    object btnConsultar: TButton
      Left = 278
      Top = 89
      Width = 120
      Height = 29
      Caption = 'Consultar'
      TabOrder = 8
      OnClick = btnConsultarClick
    end
    object btnTesteo: TButton
      Left = 549
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Testeo'
      TabOrder = 5
    end
    object btnPrimero: TButton
      Left = 404
      Top = 89
      Width = 120
      Height = 30
      Caption = 'Primero'
      TabOrder = 9
      OnClick = btnPrimeroClick
    end
    object btnUltimo: TButton
      Left = 530
      Top = 89
      Width = 120
      Height = 30
      Caption = 'Ultimo'
      TabOrder = 10
      OnClick = btnUltimoClick
    end
    object btnCrearArbol: TButton
      Left = 23
      Top = 45
      Width = 113
      Height = 25
      Caption = 'Crear Arbol B+'
      TabOrder = 3
      OnClick = btnCrearArbolClick
    end
    object btnDestruirArbol: TButton
      Left = 142
      Top = 45
      Width = 132
      Height = 25
      Caption = 'Destruir Arbol'
      TabOrder = 4
      OnClick = btnDestruirArbolClick
    end
    object btnImprimir: TButton
      Left = 26
      Top = 124
      Width = 120
      Height = 30
      Caption = 'Imprimir'
      TabOrder = 11
      OnClick = btnImprimirClick
    end
    object btnRecorrerHojas: TButton
      Left = 152
      Top = 124
      Width = 120
      Height = 30
      Caption = 'Recorrer Hojas'
      TabOrder = 12
      OnClick = btnRecorrerHojasClick
    end
  end
end
