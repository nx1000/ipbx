{$D-,L-,O+,Q-,R-,Y-,S-}
unit genfunc;

interface

uses Classes,Controls,Dialogs,SimpleDS,SysUtils,Forms,sEdit,sComboBox,sPanel,sBitBtn,
sButton,Windows,Messages,ComCtrls,DbGrids,stdctrls,DBCtrls,
DBLookUpEdit,sCheckBox,Graphics,AdvEditBtn1,ExtActns,SqlExpr,DateUtils,WinInet;


type
  TMode = (Add,Modify,Default,Find);
  type TPaymentTp = (CS=0,CC=1,CL=2,RM=3,GR=4,EL=5,CM=6,EN=7,HU=8,OC=9,AC=10,DE=11,CO=12);


procedure EnableIt(Kontrol : array of TControl);
procedure DisableIt(Kontrol : array of TControl);
procedure TickIt(Kontrol : array of TsCheckBox);
procedure UnTickIt(Kontrol : array of TsCheckBox);
procedure EnableAllChild(KontrolInduk : TControl;KontrolYgFokus : TControl);
procedure SetEnableDisable(Mode : TMode;TheParent : TForm; KontrolYgFokus:TWinControl);
procedure SetStatusPanel(Panelnya : TStatusPanel;ActMode : TMode);
procedure ResetAll(TheComponent:TComponent);
function FormExists(TheForm:String;FormUtama:TForm) : Boolean;
procedure CloseForm(TheForm:TForm);
procedure AddNewRecord(ActionMode:TMode;Formnya:TForm;Fokus:TWinControl);
function RelaxDate(Tgl:TDateTime): String;
procedure VisibleTrue(Kontrol: array of TControl);
procedure VisibleFalse(Kontrol: array of TControl);
function ShowForm( afc : TFormClass ) : TForm;
function FindAppForm ( afc : TFormClass ) : TForm;
function WriteRoomSt(rsvst: string) : String;
function DateToPrd(dDate: TDate) : String;
function getVersion : string;
procedure doDownloadGen(sUrl,sFileName:String);
function rateDlg: Integer;
function LastDayCurrMon(dt:TDate) : TDate;
function RightStr(Const Str: String; Size: Word): String;
procedure DeleteIECache;

implementation

uses dbfunc, Unit2;

procedure VisibleTrue(Kontrol: array of TControl);
var i : Integer;
begin
  for i := 0 to Length(Kontrol) - 1 do begin
    Kontrol[i].Visible := True;
  end;
end;

procedure VisibleFalse(Kontrol: array of TControl);
var i : Integer;
begin
  for i := 0 to Length(Kontrol) - 1 do begin
    Kontrol[i].Visible := False;
  end;
end;

procedure EnableIt(Kontrol : array of TControl);
var i : Integer;
begin
  for i := 0 to Length(Kontrol) - 1 do
  begin
    Kontrol[i].Enabled := True;
    if (Kontrol[i] is TDBEdit) or (Kontrol[i] is TDBAdvEditBtn1) or (Kontrol[i] is TDBComboBox) then
      TDBEdit(Kontrol[i]).Color := clWhite;

  end;

end;

procedure DisableIt(Kontrol : array of TControl);
var i : Integer;
begin
  for i := 0 to Length(Kontrol) - 1 do
  begin
    Kontrol[i].Enabled := False;
    if (Kontrol[i] is TDBEdit) or (Kontrol[i] is TDBAdvEditBtn1) then begin
      TDBEdit(Kontrol[i]).Color := $00D3D3D3;
    end;
  end;
end;

procedure EnableAllChild(KontrolInduk : TControl;KontrolYgFokus : TControl);
var i : Integer;
begin
  for i := 0 to KontrolInduk.ComponentCount - 1 do
  begin
    if (KontrolInduk.Components[i].Tag = 1) or (KontrolInduk.Components[i].Tag = 2)  then
    begin
      if KontrolInduk.Components[i] is TsEdit then TsEdit(KontrolInduk.Components[i]).Enabled := True;
      if KontrolInduk.Components[i] is TsComboBox  then TsComboBox(KontrolInduk.Components[i]).Enabled := True;
      if KontrolInduk.Components[i] is TDBEdit then TDBEdit(KontrolInduk.Components[i]).Enabled := True;
      if KontrolInduk.Components[i] is TDBLookupComboBox then TDBLookupComboBox(KontrolInduk.Components[i]).Enabled := True;
      if KontrolInduk.Components[i] is TsButton then TsButton(KontrolInduk.Components[i]).Enabled := True;
      if KontrolInduk.Components[i] is TDBMemo then TDBMemo(KontrolInduk.Components[i]).Enabled := True;
      if KontrolInduk.Components[i] is TDBComboBox then TDBComboBox(KontrolInduk.Components[i]).Enabled := True;
      if KontrolInduk.Components[i] is TDBMemo then TDBMemo(KontrolInduk.Components[i]).Enabled := True;
      if KontrolInduk.Components[i] is TDBRadioGroup then TDBRadioGroup(KontrolInduk.Components[i]).Enabled := True;
      if KontrolInduk.Components[i] is TDBLookUpEdit then TDBLookUpEdit(KontrolInduk.Components[i]).Enabled := True;
      if KontrolInduk.Components[i] is TDBAdvEditBtn1 then TDBLookUpEdit(KontrolInduk.Components[i]).Enabled := True;
      if KontrolInduk.Components[i] is TDBCheckBox then TDBCheckBox(KontrolInduk.Components[i]).Enabled := True;
      if KontrolInduk.Components[i] is TDBRichEdit then TDBRichEdit(KontrolInduk.Components[i]).Enabled := True;

      {
      ... tambahkan kontrol lain di sini ...
      }
    end;
  end;
  TWinControl(KontrolYgFokus).SetFocus;
end;


procedure SetEnableDisable(Mode : TMode;TheParent : TForm; KontrolYgFokus:TWinControl);
var i : Integer;
begin

    case Mode of

      Add:
        begin
            EnableAllChild(TControl(TheParent),KontrolYgFokus);
            for i := 0 to Pred(TheParent.ComponentCount) do
            begin

              ResetAll(TheParent.Components[i]);    //CLEAR-kan semua

              if (TheParent.Components[i] is TsBitBtn) then
              begin
                case TheParent.Components[i].Tag  of
                  1 : DisableIt([TControl(TheParent.Components[i])]);
                  2 : EnableIt([TControl(TheParent.Components[i])]);
                end;
              end;

            end;
        end;


      Modify:
        begin
          for i := 0 to TheParent.ComponentCount - 1 do
          begin
            //ShowMessage(TheParent.Components[i].Name);
            case TheParent.Components[i].Tag of
              1 : DisableIt([TControl(TheParent.Components[i])]);
              2 : EnableIt([TControl(TheParent.Components[i])]);
            end;
          end;
          KontrolYgFokus.SetFocus;
        end;

      Default:
        begin
          for i := 0 to (TheParent as TForm).ComponentCount - 1 do
            begin
              case TheParent.Components[i].Tag of
                1: if (TheParent.Components[i] is TsBitBtn) or (TheParent.Components[i] is TsButton) then TsBitBtn(TheParent.Components[i]).Enabled := True;
                2: if (TheParent.Components[i] is TsBitBtn) or (TheParent.Components[i] is TsButton) then TsBitBtn(TheParent.Components[i]).Enabled := False;
              end;
              if TheParent.Components[i] is TDBEdit then begin
                TDBEdit(TheParent.Components[i]).Enabled := False;
                TDBEdit(TheParent.Components[i]).Color := clWhite;
              end;
              if TheParent.Components[i] is TDBLookupComboBox then TDBLookupComboBox(TheParent.Components[i]).Enabled := False;
              if TheParent.Components[i] is TDBMemo then TDBMemo(TheParent.Components[i]).Enabled := False;
              if TheParent.Components[i] is TDBComboBox then TDBComboBox(TheParent.Components[i]).Enabled := False;
              if TheParent.Components[i] is TDBRadioGroup then TDBRadioGroup(TheParent.Components[i]).Enabled := False;
              if TheParent.Components[i] is TDBAdvEditBtn1 then begin
                if TDBAdvEditBtn1(TheParent.Components[i]).Tag = 0 then
                  TDBAdvEditBtn1(TheParent.Components[i]).Enabled := True
                else
                  TDBAdvEditBtn1(TheParent.Components[i]).Enabled := False;

              end;

              if TheParent.Components[i] is TDBCheckBox then TDBCheckBox(TheParent.Components[i]).Enabled := False;
              if TheParent.Components[i] is TDBRichEdit then TDBRichEdit(TheParent.Components[i]).Enabled := False;
              

            end;

          //KontrolYgFokus.SetFocus;
        end;

      Find:
        begin
          EnableAllChild(TControl(TheParent),KontrolYgFokus);
            for i := 0 to Pred(TheParent.ComponentCount) do
            begin
              ResetAll(TheParent.Components[i]);
              if (TheParent.Components[i] is TsBitBtn) then
              begin
                case TheParent.Components[i].Tag  of
                  1,2 : DisableIt([TControl(TheParent.Components[i])]);
                  3 : EnableIt([TControl(TheParent.Components[i])]);
                end;
              end;

            end;

        end;

     end;

end;

procedure SetStatusPanel(Panelnya : TStatusPanel;ActMode : TMode);
begin
  case ActMode of
    Add: Panelnya.Text := 'CTRL-S: Save, ESC: Back';
    Modify: Panelnya.Text := 'CTRL-S: Save, ESC: Back';
    Default: Panelnya.Text := 'CTRL-N: Add New, ENTER: Update, ESC: Close' ;
    Find :  Panelnya.Text := 'CTRL-F: Find';
  end;
end;

procedure ResetAll(TheComponent:TComponent);
begin
  if (TheComponent.Tag = 1) or (TheComponent.Tag = 2) or (TheComponent.Tag = 3) then
  begin
    if (TheComponent is TsEdit) then (TheComponent as TsEdit).Clear;
    if (TheComponent is TsComboBox) then (TheComponent as TsComboBox).ItemIndex := 0;
    if (TheComponent is TDBEdit) then (TheComponent as TDBEdit).Clear;
    
  end;
end;

function FormExists(TheForm:String;FormUtama:TForm) : Boolean;
var i : Integer;
begin
  for i := 0 to FormUtama.MDIChildCount - 1 do begin
    if FormUtama.MDIChildren[i].Name = TheForm then
      Result := True
    else
      Result := False;
  end;
end;

procedure CloseForm(TheForm:TForm);
begin
  TheForm.Close;
end;

procedure AddNewRecord(ActionMode:TMode;Formnya:TForm;Fokus:TWinControl);
begin
  SetEnableDisable(ActionMode,Formnya,Fokus as TDBEdit);
end;








function RelaxDate(Tgl:TDateTime):String;
begin
  //
  Result := QuotedStr(FormatDateTime('yyyy-mm-dd',Tgl));
end;

//function ShowForm( afc : TFormClass; iLeft : integer = -1; iTop : integer = -1 ) : TForm;
function ShowForm( afc : TFormClass ) : TForm;
   begin
      Result := FindAppForm( afc );
      if Result = nil then
      begin
         Result := afc.Create(Application);
      end;
      Result.Show;
    end;

function FindAppForm ( afc : TFormClass ) : TForm;
   var
      i : integer;
   begin
      Result := nil;
      for i := Screen.FormCount-1 downto 0 do
      begin
         if (Screen.Forms[i] is afc) then
         begin
            Result := Screen.Forms[i];
            break;
         end;
      end;
   end;

procedure TickIt(Kontrol : array of TsCheckBox);
var i : Integer;
begin
  for i := 0 to Length(Kontrol) - 1 do
  begin
    (Kontrol[i] as TsCheckBox).Checked := True;
  end;
end;

procedure UnTickIt(Kontrol : array of TsCheckBox);
var i : Integer;
begin
  for i := 0 to Length(Kontrol) - 1 do
  begin
    (Kontrol[i] as TsCheckBox).Checked := False;
  end;
end;

function WriteRoomSt(rsvst: string) : String;
begin
  if rsvst = 'D' then
    Result := 'Definite'
  else if rsvst = 'R' then
    Result := 'Registered'
  else if rsvst = 'C' then
    Result := 'Cancelled'
  else
    Result := 'Other';
end;



function DateToPrd(dDate: TDate) : String;
var y,m,d : Word;
    yy,mm: String;
begin
  DecodeDate(dDate,y,m,d);
  yy := IntToStr(y);
  if Length(IntToStr(m)) = 1 then mm := '0'+IntToStr(m);
  //Result := yy+mm;
  Result := Concat(yy,mm);
end;

function getVersion : string;
{ ---------------------------------------------------------
   Extracts the FileVersion element of the VERSIONINFO
   structure that Delphi maintains as part of a project's
   options.

   Results are returned as a standard string.  Failure
   is reported as "".

   Note that this implementation was derived from similar
   code used by Delphi to validate ComCtl32.dll.  For
   details, see COMCTRLS.PAS, line 3541.
  -------------------------------------------------------- }
const
   NOVIDATA = '';

var
  dwInfoSize,           // Size of VERSIONINFO structure
  dwVerSize,            // Size of Version Info Data
  dwWnd: DWORD;         // Handle for the size call.
  FI: PVSFixedFileInfo; // Delphi structure; see WINDOWS.PAS
  ptrVerBuf: Pointer;   // pointer to a version buffer
  strFileName,          // Name of the file to check
  strVersion : string;  // Holds parsed version number
begin

   strFileName := paramStr( 0 );
   dwInfoSize :=
      getFileVersionInfoSize( pChar( strFileName ), dwWnd);

   if ( dwInfoSize = 0 ) then
      result := NOVIDATA
   else
   begin

      getMem( ptrVerBuf, dwInfoSize );
      try

         if getFileVersionInfo( pChar( strFileName ),
            dwWnd, dwInfoSize, ptrVerBuf ) then

            if verQueryValue( ptrVerBuf, '\',
                              pointer(FI), dwVerSize ) then

            strVersion :=
               format( '%d.%d.%d.%d',
                       [ hiWord( FI.dwFileVersionMS ),
                         loWord( FI.dwFileVersionMS ),
                         hiWord( FI.dwFileVersionLS ),
                         loWord( FI.dwFileVersionLS ) ] );

      finally
        freeMem( ptrVerBuf );
      end;
    end;
  Result := strVersion;
end;

procedure doDownloadGen(sUrl,sFileName:String);
begin
  //
    with TDownLoadURL.Create(nil) do begin
    try
      URL := sUrl;
      Filename := sFileName;
      ExecuteTarget(nil);
    finally
      Free;
    end;
  end;

end;





function rateDlg: Integer;
begin
  with CreateMessageDialog('Room Type is changed. Do you want to Keep or Replace the Rates?',mtConfirmation,[mbYes,mbNo]) do begin
    try
      TButton(FindComponent('Yes')).Caption := 'Keep';
      TButton(FindComponent('No')).Caption := 'Replace';
      Position := poScreenCenter;
      Result := ShowModal;
    finally
      Free;
    end;
  end;
end;

function LastDayCurrMon(dt:TDate): TDate;
begin
   result := EncodeDate(YearOf(dt),MonthOf(dt), DaysInMonth(dt)) ;
end;

function RightStr(Const Str: String; Size: Word): String;
begin
  if Size > Length(Str) then Size := Length(Str) ;
  RightStr := Copy(Str, Length(Str)-Size+1, Size)
end;

procedure DeleteIECache;
var
  lpEntryInfo: PInternetCacheEntryInfo;
  hCacheDir: LongWord;
  dwEntrySize: LongWord;
begin
  dwEntrySize := 0;
  FindFirstUrlCacheEntry(nil, TInternetCacheEntryInfo(nil^), dwEntrySize);
  GetMem(lpEntryInfo, dwEntrySize);
  if dwEntrySize > 0 then lpEntryInfo^.dwStructSize := dwEntrySize;
  hCacheDir := FindFirstUrlCacheEntry(nil, lpEntryInfo^, dwEntrySize);
  if hCacheDir <> 0 then 
  begin
    repeat
      DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);
      FreeMem(lpEntryInfo, dwEntrySize);
      dwEntrySize := 0;
      FindNextUrlCacheEntry(hCacheDir, TInternetCacheEntryInfo(nil^), dwEntrySize);
      GetMem(lpEntryInfo, dwEntrySize);
      if dwEntrySize > 0 then lpEntryInfo^.dwStructSize := dwEntrySize;
    until not FindNextUrlCacheEntry(hCacheDir, lpEntryInfo^, dwEntrySize);
  end;
  FreeMem(lpEntryInfo, dwEntrySize);
  FindCloseUrlCache(hCacheDir);
end;




end.
