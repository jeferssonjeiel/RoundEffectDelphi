unit untApp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Objects, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TfrmApp = class(TForm)
    ListView1: TListView;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDQuery1NOME: TWideStringField;
    FDQuery1FOTO_PERFIL: TBlobField;
    FDQuery1FOTO_FEED: TBlobField;
    FDQuery1POSTAGEM_TEXTO: TWideStringField;
    procedure LoadFeed;
    procedure LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmApp: TfrmApp;

implementation

{$R *.fmx}

{ TfrmApp }

procedure TfrmApp.FormShow(Sender: TObject);
  begin
    FDConnection1.Connected := true;
    FDQuery1.Active := true;

    LoadFeed;
  end;

procedure TfrmApp.LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);
var ms, ms2: TMemoryStream;
  begin
    ms := TMemoryStream.Create;
      try
        Blob.SaveToStream(ms);
        ms.Position := 0;
        Bitmap.LoadFromStream(ms);
      finally
          ms.Free;
      end;
  end;

procedure TfrmApp.LoadFeed;
var img, mask: TBitmap;
  begin
    img := TBitmap.Create;
    mask := TBitmap.Create;

  while not FDQuery1.Eof do
    begin
      with ListView1.Items.Add do
        begin
          mask.LoadFromFile('D:\Documentos\Embarcadero Projects\10.3 Apps\RoundImage Effect\Images\mask.png');
          LoadBitmapFromBlob(img,FDQuery1FOTO_PERFIL);

          Data['Image2'] := Bitmap.CreateFromBitmapAndMask(img,mask);
          Data['Image3'] := FDQuery1FOTO_FEED;
          Data['Text1'] := FDQuery1NOME.AsString;
          Data['Text4'] := FDQuery1POSTAGEM_TEXTO.AsString;
          FDQuery1.Next;
        end;
    end;
  end;
end.
