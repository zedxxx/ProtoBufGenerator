unit ufmMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    edProtoFileName: TEdit;
    btnOpenProtoFile: TButton;
    odProtoFile: TFileOpenDialog;
    btnGenerate: TButton;
    edOutputFolder: TEdit;
    btnChooseOutputFolder: TButton;
    procedure btnOpenProtoFileClick(Sender: TObject);
    procedure btnChooseOutputFolderClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
  private
    { Private declarations }
    procedure Generate(SourceFiles: TStrings; const OutputDir: string);
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses
  Vcl.FileCtrl,
  uProtoBufGenerator;

{$R *.dfm}

procedure TfmMain.btnChooseOutputFolderClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := edOutputFolder.Text;
  if SelectDirectory('Select output directory', '', Dir, [sdNewFolder, sdShowShares, sdNewUI, sdValidateDir], nil) then
    edOutputFolder.Text := Dir;
end;

procedure TfmMain.btnGenerateClick(Sender: TObject);
var
  FileNames: TStrings;
begin
  FileNames := TStringList.Create;
  try
    FileNames.Delimiter:=odProtoFile.Files.Delimiter;
    FileNames.DelimitedText:=edProtoFileName.Text;
    Generate(FileNames, edOutputFolder.Text);
    ShowMessage('Complete! Take a look into output directory');
  finally
    FileNames.Free;
  end;
end;

procedure TfmMain.btnOpenProtoFileClick(Sender: TObject);
begin
  if odProtoFile.Execute then
    edProtoFileName.Text := odProtoFile.Files.DelimitedText;
end;

procedure TfmMain.Generate(SourceFiles: TStrings; const OutputDir: string);
var
  Gen: TProtoBufGenerator;
  i: Integer;
begin
  System.SysUtils.ForceDirectories(OutputDir);
  Gen := TProtoBufGenerator.Create;
  try
    for i := 0 to SourceFiles.Count - 1 do
      Gen.Generate(SourceFiles[i], edOutputFolder.Text, TEncoding.UTF8);
  finally
    Gen.Free;
  end;
end;

end.
