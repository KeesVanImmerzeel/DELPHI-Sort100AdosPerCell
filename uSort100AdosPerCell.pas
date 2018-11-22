unit uSort100AdosPerCell;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.FileCtrl,
  uError, {uProgramSettings,} LargeArrays, OPwstring, AdoSets, DUtils;

const
  nrOfAdoSets = 100;

type
  TForm3 = class(TForm)
    Memo1: TMemo;
    LabeledEditFileNamePrefix: TLabeledEdit;
    LabeledEditInputDir: TLabeledEdit;
    LabeledEditSetName: TLabeledEdit;
    LargeRealArray1: TLargeRealArray;
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    procedure LabeledEditInputDirClick(Sender: TObject);
    procedure LabeledEditFileNamePrefixChange(Sender: TObject);
    procedure LabeledEditSetNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TArrayWithAdoSets = Array[1..nrOfAdoSets] of TRealAdoSet;

var
  Form3: TForm3;
  ArrayWithAdoSets: TArrayWithAdoSets;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
const
  SelectedPercentages: array[1..9] of integer = ( 1, 5, 10, 15, 50, 75, 90, 95, 100 );
  WordDelims: CharSet = ['*',','];
var
  fName, fldrName, AdoFilePrefix, AdoFileExt, SetName, outputSetName: String;
  iAdoSetNr, nrRows, Len: Integer;
  i, n: Integer;
  f: TextFile;
  Initiated: Boolean;
  LineNr: LongWord;
begin
  if SaveDialog1.Execute then begin
    fini.WriteString('Files','ResultAdoFile',ExtractFileName(SaveDialog1.fileName));
    fini.WriteString('Files','ResultAdoDir',ExtractFileDir(SaveDialog1.fileName));
  end;

  fldrName := LabeledEditInputDir.text;
  AdoFilePrefix := ExtractWord( 1, LabeledEditFileNamePrefix.Text, WordDelims, Len );
  AdoFileExt := ExtractWord( 2, LabeledEditFileNamePrefix.Text, WordDelims, Len );
  SetName := Trim( LabeledEditSetName.Text );
  outputSetName := ExtractWord(1, SetName, WordDelims, Len );

  //Initialiseer array met ado's
  for iAdoSetNr := 1 to nrOfAdoSets do begin
    fName := fldrName + '\' + AdoFilePrefix + intToStr( iAdoSetNr ) + AdoFileExt;
    WriteToLogFile( 'Initialise ado #, :' + intToStr( iAdoSetNr ) + ': ' + fName );
    AssignFile( f, fName ); Reset( f );
    ArrayWithAdoSets[ iAdoSetNr ] := TRealAdoSet.InitFromOpenedTextFile( f, SetName, Self, LineNr, Initiated );
    CloseFile( f );
  end;

  //Sorteer waarden per cel
  nrRows := ArrayWithAdoSets[ 1 ].NrOfElements;
  LargeRealArray1 := TLargeRealArray.Create( nrOfAdoSets, self );
  for i := 1 to nrRows do begin
      //Zet waarden in LargeRealArray1
      for iAdoSetNr := 1 to nrOfAdoSets do begin
        LargeRealArray1[ iAdoSetNr ] := ArrayWithAdoSets[ iAdoSetNr ][i];
      end;
      //Sorteer deze array
      LargeRealArray1.Sort( Ascending );
      for iAdoSetNr := 1 to nrOfAdoSets do begin
        ArrayWithAdoSets[ iAdoSetNr ][i] := LargeRealArray1[ iAdoSetNr ];
      end;
  end;

  n := length( SelectedPercentages );
  AssignFile( f, SaveDialog1.FileName ); Rewrite( f );

  for i := 1 to n do begin
    iAdoSetNr := SelectedPercentages[ i ];
    ArrayWithAdoSets[ iAdoSetNr ].SetIdStr := outputSetName + IntToStr( iAdoSetNr );
    ArrayWithAdoSets[ iAdoSetNr ].ExportToOpenedTextFile( f );
  end;
  CloseFile( f );

  ShowMessage( 'Gereed.' );
end;


procedure TForm3.FormCreate(Sender: TObject);
var
  aDir: String;
begin
  InitialiseLogFile;
  aDir := fini.ReadString('Files', 'idfDir','c:\');
  if System.SysUtils.DirectoryExists( aDir ) then
    LabeledEditInputDir.text := aDir
  else
    LabeledEditInputDir.text := 'c:\';
  aDir := fini.ReadString('Files', 'OutputDir','c:\');
    LabeledEditFileNamePrefix.Text := fini.ReadString( 'Settings', 'AdoFilePrefix', 'Flairs*.flo' );
  LabeledEditSetName.Text := fini.ReadString( 'Settings', 'Setname', 'PHIT, STEADY-STATE==' );
  SaveDialog1.fileName := fini.ReadString('Files','ResultAdoFile','percentages.ado');
  SaveDialog1.InitialDir := fini.ReadString('Files','ResultAdoDir','c:\');
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
FinaliseLogFile;
end;

procedure TForm3.LabeledEditFileNamePrefixChange(Sender: TObject);
begin
  fini.WriteString( 'Settings', 'AdoFilePrefix', LabeledEditFileNamePrefix.Text );
end;

procedure TForm3.LabeledEditInputDirClick(Sender: TObject);
var
  aDir: String;
begin
  aDir := LabeledEditInputDir.text;
  if SelectDirectory( aDir, [], 0) then begin
    LabeledEditInputDir.text := ExpandFileName( aDir );
    fini.WriteString('Files','idfDir',LabeledEditInputDir.text);
  end;
end;

procedure TForm3.LabeledEditSetNameChange(Sender: TObject);
begin
  fini.WriteString( 'Settings', 'Setname', LabeledEditSetName.Text );
end;

end.
