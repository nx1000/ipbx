unit dbfunc;
interface

uses DB,Classes,SqlExpr,Forms,StrUtils,sEdit,Dialogs,SysUtils,SimpleDS,Variants,
DBGrids,stdctrls,Controls,Unit2,AdvEditBtn1,genfunc,DateUtils,Math;

var
  gCurr : String;
  fromARAPTrans : Byte;
  firsttimecp : Boolean;

type
  TDbFunctions = class
    procedure SortTheGrid(vDataSet:TSimpleDataSet;vColumnName:String);
    procedure IsiComboBox(vComboBox:TComboBox;vDatanya:TSimpleDataSet;vFieldnya:String);
    procedure ComboBoxChange(Sender:TObject);
  end;

  TComboBoxFunctions = class
    procedure ComboBoxChanged(vCombo:TComboBox);
  end;

function ParseFields(Ortu:TForm) : TStrings;
function ParseValues(Ortu:TForm) : TStrings;
function ParseFieldNValues(FieldValue : TStrings;Ortu:TForm) : TStrings;
function NotEmpty(FieldName,FieldValue : String) : String;
function IsDuplicate(TableName:String;aFields,aValues: TStrings) : String;
procedure FilterData(TableName:TSimpleDataSet;sFilter:String;isFiltered:Boolean);
procedure FindData(TheTable:TSimpleDataSet;TheForm:TForm);
function QuickFindData(TableName:TSimpleDataSet;TheIndex,WhatToFind:String) : Boolean;
procedure DeleteRecord(TableName:TSimpleDataSet);
procedure AddRecord(TableName:TSimpleDataSet);
procedure EditRecord(TableName:TSimpleDataSet);
function CreateFilterString(TableName:TSimpleDataSet;TextFilter:String) : String;
function SortTheGrid(FieldSorting:String;Ascending:Boolean;TheForm:TForm) : String;
function GetNewSeq(TableName:String):Integer;
function GetNewSeq2(TableName:String):Integer;
function GetNewSeqEx(TableName,FieldName,FieldValue: String) : Integer;
//function OKToDiscard(TableName:TSimpleDataSet):Boolean;
function GetNextTrNol(TrTp:String):String;
procedure SetNextTrNol(TrTp:String);
function CheckAccess(what,who:String):Boolean;
procedure SaveCrtUserDate(TableName,crtuser:String;crtdatetime:TDateTime;aFields,aValues:TStrings);
procedure getbaserate(var bsrate1,bsrate2:Currency;currcd:String);
//triggers and procedures


function GetNextTrNo(outletcd : String) : String;
function GetNextTrNoBO(trtp:String;trdt:TDate): String;
procedure SetNextTrNo(outletcd : String);
procedure SetNextTrNoBO(trtp : String);
procedure FindDesc(EditBox: TDBAdvEditBtn1; EditDesc: TEdit; ActMode:TMode);
procedure FindDesc2(EditBox: TDBAdvEditBtn1; EditDesc: TEdit; ActMode:TMode);
function getPsCdRm : String;
function getFOPrd : TDate;
procedure savePayment(pscd,trdt,trno,trno1,subtrno1,trdesc,pymtmthd,currcd,currbs1,currbs2,active,rsvno,subrsvno : String; ftotamt,totamt: Double);
procedure SQLExec(querystr: String);
function SQLExec2(querystr,value: String) : String;
function SQLExecEx(querystr: String) : Integer;
function getCurrCd : String;
function GetServerDate : String;
function GetServerDate2 : String;
function GetSomeDBData(fieldnm,tablenm : String) : Variant;
procedure GetRemainingAmt(range: Integer;cutoffdate: TDate;Tp,CompSupCd: String;var amtar,amtallc:Double);
procedure UpdateIA(vseq:Integer;vtrdt,vtrno,vtrno1,vpscd,vcoarvn,vcoasvchg,vcoatax,rsvno,subrsvno,trdesc,trdesc2,trdesccr:String;vamt,vsvchg,vtax:Double;FromRoom: Boolean;user:String);
function GetNextSeqDt : Integer;
procedure UpdateJrnHD(trdt:TDate;trno,subtrno,pscd,rsvno,subrsvno,trdesc,trtime:String;pax,active:Integer;user:String);
procedure UpdateJrnDt(seq:Integer;trdt:TDate;pscd,trno,subtrno,itemcd,trdesc:String;qty,active:Integer;user:String);
procedure CalcAmt(itemcd,pscd,trno:String;seq,qty:Integer;var coarvn,coasvchg,coatax:String;var amt,svchg,tax: Double);
procedure CalcAmtSales(seq:Integer;outletcd,itemcd,trno: string; qty,disc: Integer);
procedure CalcAmtNonSales(seq:Integer;outletcd,itemcd,trno,trdesc: string; qty,disc: Integer;costamt:Double);
procedure UpdateIAPY(vseq:Integer;vtrdt,vtrno,vtrno1,vsubtrno1,vpscd,pycoa,coacomm,rsvno,subrsvno,trdesc,trdesc2:String;vamt,vccamt,vcommamt:Double;CreditCard:Boolean;user:String);
procedure UpdateIAFO(vseq:Integer;vtrdt,docdt,vtrno,vtrno1,vsubtrno1,vpscd,pycoa,coacomm,rsvno,subrsvno,rsvnoto,subrsvnoto,trdesc,trdesc2:String;vamt,vccamt,vcommamt:Double;user:String);
procedure getPyCOA(pycd,pydtcd: String;var coacd,coacomm : String; var commpct : Double);
procedure UpdateIARBT(vseq:Integer;vtrdt,vtrno,vpscd,vcoarvn,vcoasvchg,vcoatax,rsvno,subrsvno,trdesc:String;vamt,vsvchg,vtax:Double;user:String);
procedure WriteChangesLog(user,tablenm,keynm,keyvalue,fieldnm,oldvalue,newvalue: String; dt: TDate; tm,formnm,act: String);
procedure DoCheckIn2(rsvno,roomno:String;CancelCI:Boolean);
procedure DoCheckOut2(rsvno,roomno:String;depdt:TDate;CancelCO:Boolean);
procedure UpdateRmStCI(roomno:String);
procedure UpdateRmStCancelCI(roomno:String);
procedure UpdateRmStCO(roomno:String);
procedure UpdateRmStCancelCO(roomno:String);
//procedure UpdateIADP(seq:Integer;vtrdt,vtrno,vtrno1,vpscd,pycoa,trdesc:String;vamt:Double;user:String);
procedure UpdateIACO(vtrdt:String;seq:Integer;vtrno,vtrno1,vpscd,pycoa,trdesc,strdesc2,rsvno,subrsvno:String;vamt:Double;user:String);
procedure UpdateIACORR(vtrdt,seq,vtrno,vtrno1,vpscd,dbcoa,crcoa,trdesc:String;vamt:Double;user:String);
function GetData(query,fieldnm : String) : Variant;
function GetDataStr(query,fieldnm : String) : String;
function GetDataFloat(query,fieldnm : String) : Double;
function GetDataInt(query,fieldnm : String) : Integer;
function GetData2(query : String) : TSimpleDataSet;
procedure GetData3(query,fieldnm : String; var Hasil : Variant; var Jumlah : Integer);
function GetData4(query,fieldnm: String) : Variant;
procedure CalcAmtEx(itemcd,pscd,trno,rsvno:String;seq,qty:Integer;var coarvn,coasvchg,coatax:String;var amt,svchg,tax: Double;trdt:TDate);
function getnextcashiertoken : String;
function getLastInsertID : Integer;
function CheckOpenCashier(user : String) : Boolean;
function CheckZeroBalance(rsvno : String) : Boolean;
procedure gettodayrate(trdt:TDate;rsvno,rsvst:String);
procedure FindBillMgmt(rsvnofrom,pscd: String; var rsvnoto,subrsvnoto: String);
procedure FindBillMgmtPC(rsvnofrom: String; var rsvnoto,subrsvnoto: String);
procedure CheckDiscrepancyCI(roomno: String;var rsvno,rsvnm: String; var bRoomIsUsed: Boolean);
function GetLocalAmt(FAmt:Double;Curr:String): Double;
procedure UpdateProdBalEx(trdt:TDate;prodcd,whcd : String;no_transaction:Boolean);
procedure UpdateProdBalEx2(trdt:TDate;prodcd,whcd : String;no_transaction:Boolean);
procedure GetValueDBCR(dbamt,cramt: Double;var db,cr: Double);
function GetNextPrd(currprd:String) : String;
function GetPriorPrd(currprd:String) : String;
function getlastinsertid2(tablename,fieldname : String) : Integer;
function getlastinsertid3(tablename,fieldname: String) : Integer;
procedure GetCBInAllocate(range:Integer;CBCd,CompCd: String;cutoffdate: TDate;var amtar:Double);
procedure GetCBOutAllocate(range:Integer;CBCd,SupCd: String;cutoffdate: TDate;var amtap:Double);
function UpdateRsvTemp(oldrsvno,newrsvno,grpcd,roomtp,rsvby,rsvnm,ratecd: String; arrdt,depdt: TDate; nights,adult,child: Integer) : String;
procedure SelfCheckRoom;
procedure UpdateDepDt(rsvno:String;dt:TDate);
function RecCount(Cmd: String) : Integer;
function GetNextProdCd(Ctg,Ctg2,oneLetter:String) : String;
procedure CalcAmtGLHeader(trno,currcd:String;isAdjust:Boolean);
procedure RoomCharge(chgRsvno,chgRoomno,formnm,act: String);
procedure UpdateIANonSales(vseq:Integer;vtrdt,vtrno,vtrno1,vpscd,vcoacost,rsvno,subrsvno,trdesc,trdesccr:String;costamt:Double;user:String);
function checkIfMemberCO(sGrpCd: String) : Boolean;
function checkIfGroupCI(sGrpCd: String) : Boolean;
procedure updateGroupPU(sGrpCd,sRoomTp,sRsvno: String);
procedure recalcGroupPU(grpRsvNo,grpCd: String);
procedure calc_ARRmn(trno,currcd: String);
procedure calc_APRmn(trno,currcd: String);
procedure updateTrialBalance(fromPrd,toPrd,fromCoa,toCoa: String);
procedure CalcTrialBal(sPrd,sCoaCd: String);
procedure sumTrialBal(sCoa,sPrd: String);
function setMinimumNightGen(xrsvno,rmtpcd: String; arrdt,depdt: TDate) : String;
procedure copyGroupRate(sGrpCd,sRsvNo,sRoomType: String;allMember: Boolean);
procedure reinsertTrialBal(var nRecCount,nRec : Integer);
procedure reinsertTrialBalEx(fromdt,todt: TDate);
function checkRoomBlock(arrdt,depdt : TDate;roomno,modRsvno: String;var rsvno: String) : Integer;
procedure recalcDP(trnodp: String);
procedure calcLedger(trno: String;trdt: TDate);
procedure SaveRate(sRsvNo: String;FITRateChanged,KeepRate: Boolean);
procedure recalcPODetail(sPOno: String);
procedure setMandatory(tbldataset: TSimpleDataSet;tblname: String);

function isCoaAllowed(sCoa:String): Boolean;
function validateCOA(sCoa:String) : Boolean;
function getFOTime: String;

var
  DbFunctions : TDbFunctions;


implementation

uses DBClient;


function ParseFields(Ortu:TForm) : TStrings;
var i : Integer;
    s : TStrings;
    nama : String;
begin
  s := TStringList.Create;

  for i := 0 to Ortu.ComponentCount - 1 do
  begin
    if Ortu.Components[i].ClassName = 'TsEdit' then begin
      nama := MidStr(Ortu.Components[i].Name,4,20);
      s.Add(nama);
    end;
  end;

  Result := s;

end;

function ParseValues(Ortu:TForm) : TStrings;
var i : Integer;
    s : TStrings;
    value : String;
begin
  s := TStringList.Create;

  for i := 0 to Ortu.ComponentCount - 1 do
    begin
      if Ortu.Components[i].ClassName = 'TsEdit' then begin
        value := (Ortu.Components[i] as TsEdit).Text;
        s.Add(QuotedStr(value));
      end;
    end;

    Result := s;
end;

function ParseFieldNValues(FieldValue : TStrings;Ortu:TForm) : TStrings;
var i : Integer;
    s : TStringList;
begin
  s := TStringList.Create;
  for i := 0 to FieldValue.Count - 1 do begin
    if FieldValue.ValueFromIndex[i] = 'String' then begin
      s.Add('s');
    end;

  end;
  Result := s;
end;

function NotEmpty(FieldName,FieldValue : String) : String;
begin
  if Length(FieldValue) <= 0 then
    Result := FieldName + ' should not be empty'
  else
    Result := '';
end;

function IsDuplicate(TableName:String;aFields,aValues:TStrings) : String;
var i : Integer;
    condition : String;
    sqlstr : String;
    q : TSQLQuery;
begin

  q := TSQLQuery.Create(nil);
  q.SQLConnection := dm.mySQL1;

  if aFields.Count = 1  then
    condition := aFields.Strings[0] + '=' + QuotedStr(aValues.Strings[0])
  else begin
    for i := 0 to aFields.Count - 1 do
    begin
      condition := condition + aFields.Strings[i] + '=' + QuotedStr(aValues.Strings[i]);
      if i < (aFields.Count) - 1 then condition := condition + ' AND ';
    end;
  end;

  sqlstr := 'SELECT * FROM ' + TableName + ' WHERE ' + condition;

  try
      q.SQL.Clear;
      q.CommandText := sqlstr;
      q.Prepared := True;
      q.Open;

      if q.RowsAffected > 0 then
        Result := 'Duplicate Record'
      else
        Result := '';
      q.Close;
  finally
      q.Free;
  end;

end;

procedure FilterData(TableName:TSimpleDataSet;sFilter:String;isFiltered:Boolean);
begin
  TableName.Filter := sFilter;
  TableName.FilterOptions := [foCaseInsensitive];
  TableName.Filtered := isFiltered;
end;

procedure FindData(TheTable:TSimpleDataSet;TheForm:TForm);
var TheFields,TheValues : TStrings;
begin
  TheFields := ParseFields(TheForm);
  TheValues := ParseValues(TheForm);
  TheFields.Delimiter :=';';
  TheValues.Delimiter :=';';
  TheTable.Locate(TheFields.DelimitedText,TheValues.DelimitedText,[]);
end;

function QuickFindData(TableName:TSimpleDataSet;TheIndex,WhatToFind:String) : Boolean;
begin
  TableName.IndexFieldNames := TheIndex;
  //Result := TableName.FindKey([WhatToFind]);
  //Result := TableName.Locate(TheIndex,WhatToFind,[loPartialKey,loCaseInsensitive]);
  //TableName.SetKey;
  TableName.FindNearest([WhatToFind]);

  Result := True;

end;

procedure TDbFunctions.SortTheGrid(vDataSet:TSimpleDataSet;vColumnName:String);
begin
  vDataSet.IndexFieldNames := vColumnName;
end;


procedure TDbFunctions.IsiComboBox(vComboBox: TComboBox; vDatanya: TSimpleDataSet;vFieldnya:String);
//var Combo : TComboBoxFunctions;
begin
  vComboBox.AutoComplete := True;
  vComboBox.AutoCloseUp := True;

  vDatanya.First;
  while not vDatanya.Eof do begin
    vComboBox.Items.Add(vDatanya.FieldByName(vFieldnya).FieldName);
    vDatanya.Next;
  end;

  vComboBox.OnChange := ComboBoxChange;

end;

procedure TComboBoxFunctions.ComboBoxChanged(vCombo:TComboBox);
begin

end;

procedure TDbFunctions.ComboBoxChange(Sender:TObject);
begin
  ShowMessage((Sender as TComboBox).Text);
end;

procedure DeleteRecord(TableName:TSimpleDataSet);
begin

  if MessageDlg('Delete this record?',mtConfirmation,[mbYes,mbNo],0) = 6  then  //mrYes = 6
  begin
    TableName.Delete;
    TableName.ApplyUpdates(-1);
  end;
end;

function CreateFilterString(TableName:TSimpleDataSet;TextFilter:String) : String;
var i : Integer;
begin
  if (TableName.Fields.Fields[0].DataType = ftString) and (TableName.Fields.Fields[0].FieldKind <> fkLookup) then
    Result := TableName.Fields.Fields[0].FieldName + ' LIKE ' + QuotedStr('%'+TextFilter+'%');

  //if Result <> '' then Result := Result + ' OR ';


  for i := 1 to TableName.FieldCount - 1 do begin
    if (TableName.Fields.Fields[i].DataType = ftString) and (TableName.Fields.Fields[i].FieldKind <> fkLookup) then
      Result := Result + ' OR ' + TableName.Fields.Fields[i].FieldName + ' LIKE ' + QuotedStr('%'+UpperCase(TextFilter)+'%');
  end;

end;

procedure AddRecord(TableName:TSimpleDataSet);
begin
  TableName.Append;
end;

procedure EditRecord(TableName:TSimpleDataSet);
begin
  TableName.Edit;
end;

function SortTheGrid(FieldSorting:String;Ascending:Boolean;TheForm:TForm) : String;
begin

  if Ascending then
    Result := ' ORDER BY ' + FieldSorting + ' DESC'
  else
    Result := ' ORDER BY ' + FieldSorting + ' ASC';


end;


function GetNewSeq(TableName:String):Integer;
var Datanya:TSQLQuery;
begin
  Datanya := TSQLQuery.Create(nil);
  Datanya.SQLConnection := dm.mySQL1;
  Datanya.Close;
  Datanya.CommandText := 'SELECT Seq FROM '+ TableName + ' ORDER BY Seq DESC';
  Datanya.Prepared := True;
  Datanya.Open;
  if Datanya.RecordCount = 0 then begin
    Result := 1;
  end
  else begin
    Datanya.First;
    Result := Datanya['Seq'] + 1;
  end;
  Datanya.Free;
end;

function GetNewSeq2(TableName:String):Integer;
var Datanya:TSQLQuery;
begin
  Datanya := TSQLQuery.Create(nil);
  Datanya.SQLConnection := dm.mySQL1;
  Datanya.Close;
  Datanya.CommandText := 'SELECT SeqNo FROM '+ TableName + ' ORDER BY SeqNo DESC';
  Datanya.Prepared := True;
  Datanya.Open;
  if Datanya.RecordCount = 0 then begin
    Result := 1;
  end
  else begin
    Datanya.First;
    Result := Datanya['SeqNo'] + 1;
  end;
  Datanya.Free;
end;

function GetNewSeqEx(TableName,FieldName,FieldValue: String) : Integer;
var Datanya:TSQLQuery;
begin
  Datanya := TSQLQuery.Create(nil);
  Datanya.SQLConnection := dm.mySQL1;
  Datanya.Close;
  Datanya.CommandText := 'SELECT Seq FROM '+ TableName +
                         ' WHERE ' + FieldName + '='+ QuotedStr(FieldValue) +
                         ' ORDER BY Seq DESC';
  Datanya.Prepared := True;
  Datanya.Open;
  if Datanya.RecordCount = 0 then begin
    Result := 1;
  end
  else begin
    Datanya.First;
    Result := Datanya['Seq'] + 1;
  end;
  Datanya.Free;
end;


function OKToDiscard(TableName:TSimpleDataSet):Boolean;
begin
  if TableName.Modified then begin
    if MessageDlg('Cancel changes?',mtConfirmation,[mbYes,mbNo],0) = mrNo then begin Result := False; Exit; end;
    if MessageDlg('Cancel changes?',mtConfirmation,[mbYes,mbNo],0) = mrYes then Result := True;
  end;
end;

function GetNextTrNol(TrTp:String):String;
var dsTrNo : TSimpleDataSet;
    nTrNo  : Integer;
begin
  dsTrNo := TSimpleDataSet.Create(nil);
  try
    with dsTrNo do begin
      Connection := dm.mySQL1;
      DataSet.CommandText := 'select trtp,refprefix,refnx from gntrantp where trtp = ' + QuotedStr(TrTp);
      Open;
      nTrNo := dsTrNo['refnx'];
      Result := dsTrNo['refprefix'] + FormatDateTime('yyyymm',Now) + '/' + Format('%.5d',[nTrNo]);
    end;
  finally
    dsTrNo.Free;
  end;

end;

procedure SetNextTrNol(TrTp:String);
var dsTrNo : TSQLQuery;
begin
  dsTrNo := TSQLQuery.Create(nil);
  try
    with dsTrNo do begin
      SQLConnection := dm.mySQL1;
      CommandText := 'update gntrantp set refnx=refnx+1 where trtp='+QuotedStr(TrTp);
      ExecSQL();
    end;
  finally
    dsTrNo.Free;
  end;
end;

function CheckAccess(what,who:String):Boolean;
var cmd : TSQLQuery;
begin
  //
  cmd := TSQLQuery.Create(nil);
  try
    cmd.SQLConnection := dm.mySQL1;
    cmd.CommandText := 'select ' +what+ ' from gnuseraccess where usercd='+QuotedStr(who);
    cmd.Open;
    result := cmd[what];
  finally
    cmd.Free;
  end;
end;

procedure SaveCrtUserDate(TableName,crtuser:String;crtdatetime:TDateTime;aFields,aValues:TStrings);
var q : TSQLQuery;
    i : Integer;
    condition : String;
begin
  //save 'create user n date'

 q := TSQLQuery.Create(nil);
 q.SQLConnection := dm.mySQL1;

  if aFields.Count = 1  then
    condition := aFields.Strings[0] + '=' + QuotedStr(aValues.Strings[0])
  else begin
    for i := 0 to aFields.Count - 1 do
    begin
      condition := condition + aFields.Strings[i] + '=' + QuotedStr(aValues.Strings[i]);
      if i < (aFields.Count) - 1 then condition := condition + ' AND ';
    end;
  end;

  with q.Create(nil) do begin
    SQLConnection := dm.mySQL1;
    CommandText := 'update '+ tablename + 'set crtuser='+QuotedStr(crtuser)+ ',crtdttm='+RelaxDate(crtdatetime)+ ' where =' +  condition;
    ExecSQL();
  end;

end;


function GetNextTrNo(outletcd:String) : String;
var data : TSimpleDataSet;
    trnonx : Integer;
begin
  //
  try
    data := TSimpleDataSet.Create(nil);
    data.Connection := dm.mySQL1;
    data.DataSet.CommandText := 'select trnoprefix,trnonx,trnonum from pssps where pscd = ' + QuotedStr(outletcd);
    data.Open;
    trnonx := StrToInt(data['trnonx']);
    Result := Format(data['trnoprefix']+'%.'+data['trnonum']+'d',[trnonx]);
  finally
    data.Free;
  end;
end;

function GetNextTrNoBO(trtp:String;trdt:TDate): String;
var nx : Integer;
    dsTrNo : TSimpleDataSet;
begin
  dsTrNo := TSimpleDataSet.Create(nil);
  dsTrNo.Connection := dm.mySQL1;
  dsTrNo.DataSet.CommandText := 'select * from gntrantp';
  dsTrNo.Open;

  if dsTrNo.Locate('trtp',VarArrayOf([trtp]),[]) then begin
    nx := dsTrNo['RefNx'];
    Result := dsTrNo['refprefix'] + FormatDateTime('yyyymm',trdt) + '/' + Format('%.5d',[nx]);
  end;

  dsTrNo.Close;
  dsTrNo.Free;

end;

procedure SetNextTrNoBO(trtp : String);
var cmd : TSQLQuery;
begin
  cmd  := TSQLQuery.Create(nil);
  try
    cmd.SQLConnection := dm.mySQL1;
    cmd.CommandText := 'update gntrantp set refnx=refnx+1 where trtp = ' + QuotedStr(trtp);    cmd.ExecSQL();
  finally
    cmd.free;
  end;
end;

procedure SetNextTrNo(outletcd : String);
var dsTrNo : TSQLQuery;
begin
  dsTrNo := TSQLQuery.Create(nil);
  try
    with dsTrNo do begin
      SQLConnection := dm.mySQL1;
      CommandText := 'update pssps set trnonx=trnonx+1 where pscd='+QuotedStr(outletcd);
      ExecSQL();
    end;
  finally
    dsTrNo.Free;
  end;
end;


procedure FindDesc(EditBox: TDBAdvEditBtn1; EditDesc: TEdit; ActMode:TMode);
var cmd : TSQLQuery;
begin
  if ActMode <> Modify then Exit;

  //lookupdesc
  cmd := TSQLQuery.Create(nil);
  try
    cmd.SQLConnection := dm.mySQL1;
    cmd.CommandText := EditBox.eQueryStr + ' where ' + EditBox.eLookUpField + ' = ' + QuotedStr(EditBox.Text);
    cmd.Open;
    if cmd.RecordCount = 1 then
      EditDesc.Text := cmd[EditBox.eDescField]
    else
      Exit;
  finally
    cmd.Free;
  end;

end;

procedure FindDesc2(EditBox: TDBAdvEditBtn1; EditDesc: TEdit; ActMode:TMode);
var cmd : TSimpleDataset;
begin
  if ActMode <> Modify then Exit;

  //lookupdesc
  cmd := TSimpleDataset.Create(nil);
  try
    cmd.Connection := dm.mySQL1;
    cmd.DataSet.CommandText := EditBox.eQueryStr + ' and ' + EditBox.eLookUpField + ' = ' + QuotedStr(EditBox.Text);
    cmd.Open;
    if cmd.RecordCount = 1 then
      EditDesc.Text := cmd[EditBox.eDescField]
    else
      Exit;
  finally
    cmd.Free;
  end;

end;


procedure getbaserate(var bsrate1,bsrate2 : Currency;currcd:String);
var getbasert : TSimpleDataSet;
begin
    getbasert := TSimpleDataSet.Create(nil);
  try
    getbasert.Connection := dm.mySQL1;
    // -- WROOOONG !! getbasert.DataSet.CommandText := 'select currcd,curr1,curr2,max(currdt) as maxcurrdt from gncurrdt where currcd = ' + QuotedStr(currcd) + ' group by currcd';
    getbasert.DataSet.CommandText := 'select currcd,curr1,curr2,max(currdt) as maxcurrdt from gncurrdt where currdt <= '+ GetServerDate +' and currcd=' + QuotedStr(currcd) + ' group by currcd';
    getbasert.Open;
    //if getbasert.RecordCount > 0 then begin
      if getbasert.FieldByName('curr1').IsNull then bsrate1 := 0 else bsrate1 := getbasert.FieldByName('curr1').AsFloat;
      if getbasert.FieldByName('curr2').IsNull then bsrate2 := 0 else bsrate2 := getbasert.FieldByName('curr2').AsFloat;

    //end;
  finally
    getbasert.Free;
  end;

end;


function getPsCdRm : String;
var sql : TSQLQuery;
begin
  sql := TSQLQuery.Create(nil);
  try
    sql.SQLConnection := dm.mySQL1;
    sql.CommandText := 'select PsCdRm from iassystem';
    sql.Open;
    if sql.RecordCount = 1 then begin
      Result := sql.FieldByName('PsCdRm').AsString;
    end;
  finally
    sql.Free;
  end;

end;

procedure savePayment(pscd,trdt,trno,trno1,subtrno1,trdesc,pymtmthd,currcd,currbs1,currbs2,active,rsvno,subrsvno : String; ftotamt,totamt: Double);
var querystr : string;
    table : TSQLTable;
begin
  table := TSQLTable.Create(nil);
  try
    table.SQLConnection := dm.mySQL1;
    table.TableName := 'iafjrnhd';
    table.Open;

    //CASH
    table.Append;
    table['pscd'] := pscd;
    table['trdt'] := StrToDate(trdt);
    table['trno'] := trno;
    table['subtrno1'] := subtrno1;
    table['trdesc'] := trdesc;
    table['pymtmthd'] := pymtmthd;
    table['currcd'] := currcd;
    table['currbs1'] := currbs1;
    table['currbs2'] := currbs2;
    table['active'] := active;
    table['rsvno']  := rsvno;
    table['subrsvno'] := subrsvno;
    table['ftotamt'] := ftotamt;
    table.Post;

    table.Close;

  finally
    table.Free;
  end;

end;

function getFOPrd : TDate;
var q : TSQLQuery;
begin
  q := TSQLQuery.Create(nil);
  try
    q.SQLConnection := dm.mySQL1;
    q.CommandText := 'select foprd from gnsystem';
    q.Open;
    Result := q['foprd'];
    q.Close;
  finally
    q.Free;
  end;

end;

procedure SQLExec(querystr: String);
var data : TSQLQuery;
    sukses : Integer;
begin
  data := TSQLQuery.Create(nil);
  try
    data.SQLConnection := dm.mySQL1;
    data.SQL.Text := querystr;
    //while sukses = 0 do begin
      data.ExecSQL();
    //end;
    //Sleep(1000);
  finally
    data.Free;
  end;
end;

function getCurrCd : String;
var data : TSQLQuery;
begin
  data := TSQLQuery.Create(nil);
  try
    data.SQLConnection := dm.mySQL1;
    data.CommandText := 'select prfcurcd from gnprofile';
    data.Open;

    if data.RecordCount = 1 then
      Result := data['prfcurcd'];

    data.Close;

  finally
    data.Free;
  end;

end;

function GetServerDate : String;
var data : TSQLQuery;
begin
  data := TSQLQuery.Create(nil);
  try
    data.SQLConnection := dm.mySQL1;
    data.CommandText := 'select currdate() as tgl';
    //data.Open;
    //if data.RecordCount = 1 then
      Result := RelaxDate(date);
    //data.Close;
  finally
    data.Free;
  end;
end;

function GetServerDate2 : String;
var data : TSQLQuery;
begin
  data := TSQLQuery.Create(nil);
  try
    data.CommandText := 'select curdate() as tgl';
    data.Open;
    if data.RecordCount = 1 then begin
      Result := data['tgl'];
    end;
  finally
    data.Free;
  end;

end;


function GetSomeDBData(fieldnm,tablenm : String) : Variant;
var data : TSQLQuery;
begin
    data := TSQLQuery.Create(nil);
    try
      data.SQLConnection := dm.mySQL1;
      data.CommandText := 'select ' + fieldnm + ' from ' + tablenm;
      data.Open;
      if data.RecordCount = 1 then
        Result := data.FieldByName(fieldnm).AsString;

      data.Close;

    finally
      data.Free;
    end;
end;

function GetData(query,fieldnm: String) : Variant;
var data : TSQLQuery;
begin
  data := TSQLQuery.Create(nil);
  if dm.mySQL1.Connected = False then
    dm.mySQL1.Connected := True;

  try
    data.SQLConnection := dm.mySQL1;
    data.CommandText := query;
    data.Open;
    if data.RecordCount > 0 then
      Result := data[fieldnm];
  finally
    data.Free;
  end;

end;

function GetData4(query,fieldnm: String) : Variant;
var data : TSimpleDataSet;
begin
  data := TSimpleDataSet.Create(nil);
  if dm.mySQL1.Connected = False then
    dm.mySQL1.Connected := True;

  try
    data.Connection := dm.mySQL1;
    data.DataSet.CommandText := query;
    data.Open;
    if data.RecordCount > 0 then
      Result := data[fieldnm];
  finally
    data.Free;
  end;

end;

function GetDataFloat(query,fieldnm: String) : Double;
var data : TSimpleDataSet;
begin
  data := TSimpleDataSet.Create(nil);

  if dm.mySQL1.Connected = False then
    dm.mySQL1.Connected := True;

  try
    data.Connection := dm.mySQL1;
    data.DataSet.CommandText := query;
    data.Open;
    if data.RecordCount > 0 then
      Result := data[fieldnm]
    else
      Result := 0;
  finally
    data.Free;
  end;

end;

function GetDataInt(query,fieldnm: String) : Integer;
var data : TSimpleDataSet;
begin
  if not dm.mySQL1.Connected then
    dm.mySQL1.Connected := True;
  data := TSimpleDataSet.Create(nil);
  try
    data.Connection := dm.mySQL1;
    data.DataSet.CommandText := query;
    data.Open;
    if data.RecordCount > 0 then
      Result := data[fieldnm]
    else
      Result := 0;
  finally
    data.Free;
  end;

end;


//function GetRemainingAmt(range: Integer;cutoffdate: TDate;Tp,CompSupCd: String) : Variant;
procedure GetRemainingAmt(range: Integer;cutoffdate: TDate;Tp,CompSupCd: String;var amtar,amtallc:Double);
var data : TSQLQuery;
    a,b,c,d,e,f,amt,amt0,amt30,amt60,amt90 : Double;
    daysmonth : Integer;
    x : String;
    dt,dt1,dt2,dtcb : TDate;
begin

  data := TSQLQuery.Create(nil);
  data.SQLConnection := dm.mySQL1;

  //V26083
  dt1 := cutoffdate - range;
  dt2 := cutoffdate - (range + 30);

  try

    data.Close;
    if Tp = 'AP' then begin

      //V.26083
      a := GetData('select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where SupCd='+QuotedStr(CompSupCd) + ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1) + ' and trtpcd = ''2010''','nilai');
      b := GetData('select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where SupCd='+QuotedStr(CompSupCd) + ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1) + ' and trtpcd = ''2020''','nilai');
      c := GetData('select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where SupCd='+QuotedStr(CompSupCd) + ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1) + ' and trtpcd = ''2030''','nilai');
      d := GetData('select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where SupCd='+QuotedStr(CompSupCd) + ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1) + ' and trtpcd = ''2040''','nilai');
      e := GetData('select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where SupCd='+QuotedStr(CompSupCd) + ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1) + ' and trtpcd = ''7010''','nilai');
      f := GetData('select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where SupCd='+QuotedStr(CompSupCd) + ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1) + ' and trtpcd = ''7081''','nilai');
      amt := a+b-c+d+e-f;

    end

    else if Tp = 'AR' then begin
      GetCBInAllocate(range,'',CompSupCd,cutoffdate,a);

{ARAdj+}  //b := GetData('select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where CompCd='+QuotedStr(CompSupCd) + ' and trdt <= ' + RelaxDate(dt2) + 'and trtpcd = ''3020''','nilai');
{ARAjd-}  //c := GetData('select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where CompCd='+QuotedStr(CompSupCd) + ' and trdt <= ' + RelaxDate(dt2)+ ' and trtpcd = ''3030''','nilai');
{ARTrf}   //d := GetData('select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where CompCd='+QuotedStr(CompSupCd) + ' and trdt <= ' + RelaxDate(dt2)+ ' and trtpcd = ''3040''','nilai');
{AllcAR}  //x := 'select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where CompCd='+QuotedStr(CompSupCd) + ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1)+ ' and trtpcd = ''9994''';
          //x := 'select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where CompCd='+QuotedStr(CompSupCd) + ' and <= '+RelaxDate(dt1) +' and trtpcd = ''9994''';
          //amt := a+b-c+d;
          //amt := 1;

      end;

    data.SQL.Text := 'select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where CompCd='+QuotedStr(CompSupCd) + ' and trdt <= ' + RelaxDate(cutoffdate-range) + '  and trtpcd=''3010''';
    data.Open;

    //amtar := amt;
    amtar := a;
    amtallc := e;

    data.Close;

  finally
    data.Free;
  end;



end;

procedure UpdateIA(vseq:Integer;vtrdt,vtrno,vtrno1,vpscd,vcoarvn,vcoasvchg,vcoatax,rsvno,subrsvno,trdesc,trdesc2,trdesccr:String;vamt,vsvchg,vtax:Double;FromRoom: Boolean;user:String);
var cmd : TSQLQuery;
    sRsvno,sSubrsvno,sTrno1 : String;
begin
  cmd := TSQLQuery.Create(nil);
  try
    cmd.SQLConnection := dm.mySQL1;

    if FromRoom = True then begin
      sTrno1 := '';
      sRsvno := rsvno;
      sSubRsvNo := subrsvno;
    end else begin
      sTrno1 := vtrno1;
      sRsvno := '';
      sSubRsvNo := '';
    end;

    //Debet - Guest Ledger
    cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(sTrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(dm.GuestLedgerCOA)+
                       ','+QuotedStr(rsvno)+
                       ','+QuotedStr(subrsvno)+
                       ','+FloatToStr(vamt+vsvchg+vtax)+
                       ',0'+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(trdesc2)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
    cmd.ExecSQL();

    //Credit - Revenue
    cmd.Close;
    cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(vcoarvn)+
                       ','+QuotedStr(sRsvNo)+
                       ','+QuotedStr(sSubRsvNo)+
                       ',0'+
                       ','+FloatToStr(vamt)+
                       ','+QuotedStr(trdesccr)+
                       ','+QuotedStr(trdesc2)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
    cmd.ExecSQL();

    //if FromRoom = True then Exit;

    //Credit - Service Charge
    cmd.Close;
    cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(vcoasvchg)+
                       ','+QuotedStr(sRsvNo)+
                       ','+QuotedStr(sSubRsvNo)+
                       ',0'+
                       ','+FloatToStr(vsvchg)+
                       ','+QuotedStr(trdesccr)+
                       ','+QuotedStr(trdesc2)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
    cmd.ExecSQL();

    //Credit - Tax
    cmd.Close;
    cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(vcoatax)+
                       ','+QuotedStr(sRsvNo)+
                       ','+QuotedStr(sSubRsvNo)+
                       ',0'+
                       ','+FloatToStr(vtax)+
                       ','+QuotedStr(trdesccr)+
                       ','+QuotedStr(trdesc2)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
    cmd.ExecSQL();

  finally
    cmd.Free;
  end;
end;

function SQLExec2(querystr,value: String) : String;
var data : TSQLQuery;
begin
  data := TSQLQuery.Create(nil);
  try
    data.SQLConnection := dm.mySQL1;
    data.CommandText := querystr;
    data.Open;
    Result := data[value];
  finally
    data.Free;
  end;
end;

procedure CalcAmtPOS(seq:Integer;outletcd,itemcd,trno: string; qty: Integer);
var item,gl,trdt : TSimpleDataSet;
    sqlcmd : TSQLQuery;
    amt,svchg,tax:Double;
    coarvn,coasvchg,coatax: String;
    rvn,svc,pyrmn,splitpy,tot : Double;
begin
  //menghitung dan menyimpan amt,svchg,taxamt

  gl := TSimpleDataSet.Create(nil);
  gl.Connection := dm.mySQL1;
  trdt := TSimpleDataSet.Create(nil);
  trdt.Connection := dm.mySQL1;
  sqlcmd := TSQLQuery.Create(nil);
  sqlcmd.SQLConnection := dm.mySQL1;
  item := TSimpleDataSet.Create(nil);
  item.Connection := dm.mySQL1;

  try
    item.DataSet.CommandText := 'select amtsls,pctsvchg,pcttax,coarvn,coasvchg,coatax from psspsitem where itemcd='+QuotedStr(itemcd) + ' and pscd='+QuotedStr(outletcd);
    item.Open;

    amt   := item['amtsls'] * qty;
    svchg := amt * (item['pctsvchg']/100);
    tax   := amt * (item['pcttax']/100);
    coarvn := item['coarvn'];
    coasvchg := item['coasvchg'];
    coatax := item['coatax'];

    sqlcmd.CommandText := 'update iafjrndt ' +
                          ' set rvnamt = ' + FloatToStr(amt) +
                          ',qty = ' + IntToStr(qty) +
                          ',svchgamt = ' + FloatToStr(svchg) +
                          ',taxamt = ' + FloatToStr(tax) +
                          ',rvncoa = ' + QuotedStr(coarvn) +
                          ',svchgcoa = ' + QuotedStr(coasvchg) +
                          ',taxcoa = ' + QuotedStr(coatax) +
                          ' where pscd='+QuotedStr(outletcd)+
                          ' and trno='+QuotedStr(trno)+
                          ' and itemcd='+QuotedStr(itemcd) +
                          ' and seq='+IntToStr(seq);
    sqlcmd.ExecSQL();

  finally
    item.Free;
    sqlcmd.Free;
  end;

  try
      sqlcmd.CommandText := 'select sum(rvnamt) as rvn,sum(taxamt) as tax,sum(svchgamt) as svc ' +
                       ' from iafjrndt' +
                       ' where pscd='+QuotedStr(outletcd)+
                       ' and trno='+QuotedStr(trno) +
                       ' and active=1' +
                       ' and subtrno='+ QuotedStr('A');
      sqlcmd.Open;
      if sqlcmd['rvn'] <> null then rvn := sqlcmd['rvn'] else rvn := 0;
      if sqlcmd['tax'] <> null then tax := sqlcmd['tax'] else tax := 0;
      if sqlcmd['svc'] <> null then svc := sqlcmd['svc'] else svc := 0;
      tot := rvn+tax+svc;

      sqlcmd.Close;
      sqlcmd.CommandText := 'update iafjrnhd set ftotamt='+FloatToStr(tot)+',totamt='+FloatToStr(tot)+' where trno='+QuotedStr(trno);
      sqlcmd.ExecSQL();

    finally
      sqlcmd.Free;
    end;


end;

function GetNextSeqDt : Integer;
var seq : TSQLQuery;
    lastseq : Integer;
begin
  // Sequence di Detail (untuk index doang)
  seq := TSQLQuery.Create(nil);
  seq.SQLConnection := dm.mySQL1;
  try
    seq.CommandText := 'select max(seq) as lastseq from iafjrndt';
    seq.Open;
    if seq['lastseq'] <> null  then
      Result := seq['lastseq'] + 1
    else
      Result := 1;
  finally
    seq.Free
  end;
end;

procedure UpdateJrnHD(trdt:TDate;trno,subtrno,pscd,rsvno,subrsvno,trdesc,trtime:String;pax,active:Integer;user:String);
var POSHeader1 : TSQLQuery;
begin
  POSHeader1 := TSQLQuery.Create(nil);

  //try
    POSHeader1.SQLConnection := dm.mySQL1;
    POSHeader1.SQL.Text := 'insert into iafjrnhd (trdt,trno,subtrno,trno1,subtrno1,pscd,rsvno,subrsvno,trdesc,trdesc2,trtm,pax,active,usrcrt)' +
                           ' values (' + RelaxDate(trdt)+
                           ','+QuotedStr(trno)+
                           ','+QuotedStr(subtrno)+
                           ','+QuotedStr(trno)+
                           ','+QuotedStr(subtrno)+
                           ','+QuotedStr(pscd)+
                           ','+QuotedStr(rsvno)+
                           ','+QuotedStr(subrsvno)+
                           ','+QuotedStr(trdesc)+
                           ','+QuotedStr(trdesc)+
                           ','+QuotedStr(trtime)+
                           ','+IntToStr(pax)+
                           ','+IntToStr(active)+
                           ','+QuotedStr(user)+
                           ')';

    POSHeader1.ExecSQL();

    {
    with POSHeader1 do begin
      DataSet.CommandText := 'select trdt,trno,subtrno,pscd,rsvno,subrsvno,trdesc,trtm,pax,active,usrcrt from iafjrnhd';
      Open;
      Append;
      FieldByName('trdt').Value := trdt;
      FieldByName('trno').Value := trno;
      FieldByName('subtrno').Value := subtrno;
      FieldByName('pscd').Value := pscd;
      FieldByName('rsvno').Value := rsvno;
      FieldByName('subrsvno').Value := subrsvno;
      FieldByName('trdesc').Value := trdesc;
      FieldByName('trtm').Value := trtime;
      FieldByName('pax').Value := pax;
      FieldByName('active').Value := active;
      FieldByName('usrcrt').Value := user;
      Try
        Post;
        ApplyUpdates(-1);
      Except
        ShowMessage('something is wrong');
      End;
      Close;
    end;
    }



  //finally
    //POSHeader1.Free;
  //end;
end;

procedure UpdateJrnDt(seq:Integer;trdt:TDate;pscd,trno,subtrno,itemcd,trdesc:String;qty,active:Integer;user:String);
var POSDetail : TSimpleDataSet;
begin
  POSDetail := TSimpleDataSet.Create(nil);

  try
    POSDetail.Connection := dm.mySQL1;
    With POSDetail do begin
      DataSet.CommandText := 'select * from iafjrndt';
      Open;
      Append;
      FieldByName('seq').Value := seq;
      FieldByName('trdt').Value := trdt;
      FieldByName('pscd').Value := pscd;
      FieldByName('trno').Value := trno;
      FieldByName('subtrno').Value := subtrno;
      FieldByName('itemcd').Value := itemcd;
      FieldByName('trdesc').Value := trdesc;
      FieldByName('qty').Value := qty;
      FieldByName('itemseq').Value := 1;
      FieldByName('active').Value := active;
      FieldByName('usrcrt').Value := user;
      Post;
      ApplyUpdates(0);
      Close;
    end;

  finally
    POSDetail.Free;
  end;

end;

procedure CalcAmt(itemcd,pscd,trno:String;seq,qty:Integer;var coarvn,coasvchg,coatax:String;var amt,svchg,tax: Double);
var item,trdt : TSimpleDataSet;
    sqlcmd : TSQLQuery;


begin
  //menghitung dan menyimpan amt,svchg,taxamt

  trdt := TSimpleDataSet.Create(nil);
  trdt.Connection := dm.mySQL1;
  sqlcmd := TSQLQuery.Create(nil);
  sqlcmd.SQLConnection := dm.mySQL1;
  item := TSimpleDataSet.Create(nil);
  item.Connection := dm.mySQL1;

  try
    item.DataSet.CommandText := 'select amtsls,pctsvchg,pcttax,coarvn,coasvchg,coatax from psspsitem where itemcd='+QuotedStr(itemcd) + ' and pscd='+QuotedStr(pscd);
    item.Open;

    amt   := item['amtsls'] * qty;
    svchg := amt * (item['pctsvchg']/100);
    tax   := amt * (item['pcttax']/100);
    coarvn := item['coarvn'];
    coasvchg := item['coasvchg'];
    coatax := item['coatax'];

    sqlcmd.CommandText := 'update iafjrndt ' +
                          ' set rvnamt = ' + FloatToStr(amt) +
                          ',qty = ' + IntToStr(qty) +
                          ',svchgamt = ' + FloatToStr(svchg) +
                          ',taxamt = ' + FloatToStr(tax) +
                          ',rvncoa = ' + QuotedStr(coarvn) +
                          ',svchgcoa = ' + QuotedStr(coasvchg) +
                          ',taxcoa = ' + QuotedStr(coatax) +
                          ' where pscd='+QuotedStr(pscd)+
                          ' and trno='+QuotedStr(trno)+
                          ' and itemcd='+QuotedStr(itemcd) +
                          ' and seq='+IntToStr(seq);
    sqlcmd.ExecSQL();

  finally
    item.Free;
    sqlcmd.Free;
  end;

end;

procedure CalcAmtEx(itemcd,pscd,trno,rsvno:String;seq,qty:Integer;var coarvn,coasvchg,coatax:String;var amt,svchg,tax: Double;trdt:TDate);
var cmd : TSQLQuery;
    sqlcmd : TSQLQuery;
    item : TSimpleDataSet;
begin
  //menghitung dan menyimpan amt,svchg,taxamt

  sqlcmd := TSQLQuery.Create(nil);
  sqlcmd.SQLConnection := dm.mySQL1;
  item := TSimpleDataSet.Create(nil);
  item.Connection := dm.mySQL1;

  cmd := TSQLQuery.Create(nil);
  cmd.SQLConnection := dm.mySQL1;
  //cmd.CommandText := 'select amtrvn,amtsvchg,amttax from fofrate where trdt='+RelaxDate(trdt)+' and rsvno='+QuotedStr(rsvno)+' and pscd='+QuotedStr(pscd);
  cmd.CommandText := 'select amtrvn,amtsvchg,amttax from fofrate where trdt='+RelaxDate(trdt)+' and rsvno='+QuotedStr(rsvno)+' and pscd='+QuotedStr(pscd) + ' and psitem = ' + QuotedStr(itemcd);
  //cmd.CommandText := 'select sum(amtrvn) as amtrvn,sum(amtsvchg) as amtsvchg,sum(amttax) as amttax from fofrate where trdt='+RelaxDate(trdt)+' and rsvno='+QuotedStr(rsvno);
  cmd.Open;
  if cmd.RecordCount > 0 then begin
    amt := cmd['amtrvn'];
    svchg := cmd['amtsvchg'];
    tax := cmd['amttax'];
  end;
  cmd.Close;
  cmd.Free;

 try
    if item.Active then item.Close;

    item.DataSet.CommandText := 'select amtsls,pctsvchg,pcttax,coarvn,coasvchg,coatax from psspsitem where itemcd='+QuotedStr(itemcd) + ' and pscd='+QuotedStr(pscd);
    item.Open;

    coarvn := item['coarvn'];
    coasvchg := item['coasvchg'];
    coatax := item['coatax'];

    sqlcmd.CommandText := 'update iafjrndt ' +
                          ' set rvnamt = ' + FloatToStr(amt) +
                          ',qty = ' + IntToStr(qty) +
                          ',svchgamt = ' + FloatToStr(svchg) +
                          ',taxamt = ' + FloatToStr(tax) +
                          ',rvncoa = ' + QuotedStr(coarvn) +
                          ',svchgcoa = ' + QuotedStr(coasvchg) +
                          ',taxcoa = ' + QuotedStr(coatax) +
                          ' where pscd='+QuotedStr(pscd)+
                          ' and trno='+QuotedStr(trno)+
                          ' and itemcd='+QuotedStr(itemcd) +
                          ' and seq='+IntToStr(seq);
    sqlcmd.ExecSQL();

  finally
    item.Free;
    sqlcmd.Free;
  end;



end;

procedure UpdateIAPY(vseq:Integer;vtrdt,vtrno,vtrno1,vsubtrno1,vpscd,pycoa,coacomm,rsvno,subrsvno,trdesc,trdesc2:String;vamt,vccamt,vcommamt:Double;CreditCard:Boolean;user:String);
var cmd : TSQLQuery;
    trno1 : String;
begin
  cmd := TSQLQuery.Create(nil);
  cmd.SQLConnection := dm.mySQL1;

  if rsvno <> '' then
    trno1 := ''
  else
    trno1 := vtrno1;


  try

  //Debit - Payment


      if (CreditCard = True) and (vcommamt <> 0) then begin
        cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,subtrno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(trno1)+
                       ','+QuotedStr(vsubtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(pycoa)+
                       ','+QuotedStr(rsvno)+
                       ','+QuotedStr(subrsvno)+
                       ','+FloatToStr(vccamt)+
                       ',0'+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(trdesc2)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
        cmd.ExecSQL();

        cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,subtrno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(trno1)+
                       ','+QuotedStr(vsubtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(coacomm)+
                       ','+QuotedStr('')+
                       ','+QuotedStr(subrsvno)+
                       ','+FloatToStr(vcommamt)+
                       ',0'+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(trdesc2)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
        cmd.ExecSQL();
    end else begin
      cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,subtrno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(trno1)+
                       ','+QuotedStr(vsubtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(pycoa)+
                       ','+QuotedStr(rsvno)+
                       ','+QuotedStr(subrsvno)+
                       ','+FloatToStr(vamt)+
                       ',0'+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(trdesc2)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
      cmd.ExecSQL();

    end;
  //Credit - Guest Ledger
  cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,subtrno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vsubtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(dm.GuestLedgerCOA)+
                       ','+QuotedStr('')+  //bingung antara rsvno atau bukan
                       ','+QuotedStr('')+
                       ',0'+
                       ','+FloatToStr(vamt)+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(trdesc2)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
    cmd.ExecSQL();


  finally
    cmd.Free;
  end;


end;
//---------

procedure UpdateIAFO(vseq:Integer;vtrdt,docdt,vtrno,vtrno1,vsubtrno1,vpscd,pycoa,coacomm,rsvno,subrsvno,rsvnoto,subrsvnoto,trdesc,trdesc2:String;vamt,vccamt,vcommamt:Double;user:String);
var cmd : TSQLQuery;
    trno1 : String;
    res : Integer;
    str : String;
begin

  if rsvno <> '' then
    trno1 := ''
  else
    trno1 := vtrno1;


  //cmd := TSQLQuery.Create(nil);
  //cmd.SQLConnection := dm.mySQL1;

  try

  //Debit - Payment

  //reservasi asal di debet

  str := 'insert into iafjrngl (trdt,seq,trno,trno1,subtrno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vsubtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(pycoa)+
                       ','+QuotedStr(rsvnoto)+
                       ','+QuotedStr(subrsvnoto)+
                       ','+FloatToStr(vccamt)+ //','+FloatToStr(vamt)+
                       ',0'+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(trdesc2)+
                       ','+QuotedStr(user)+
                       ','+docdt+
                       ')';
  //cmd.ExecSQL();
  res := SQLExecEx(str);

  //comission ---- debet

  if vcommamt <> 0 then begin


    str := 'insert into iafjrngl (trdt,seq,trno,trno1,subtrno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vsubtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(coacomm)+
                       ','+QuotedStr(rsvnoto)+
                       ','+QuotedStr(subrsvnoto)+
                       ','+FloatToStr(vcommamt)+
                       ',0'+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(trdesc2)+
                       ','+QuotedStr(user)+
                       ','+docdt+
                       ')';
    //cmd.ExecSQL();
    res := SQLExecEx(str);

  end;

  //Credit - Guest Ledger
  //reservasi tujuan di credit
  str := 'insert into iafjrngl (trdt,seq,trno,trno1,subtrno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(trno1)+
                       ','+QuotedStr(vsubtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(dm.GuestLedgerCOA)+
                       ','+QuotedStr(rsvno)+
                       ','+QuotedStr(subrsvno)+
                       ',0'+
                       ','+FloatToStr(vamt)+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(trdesc2)+
                       ','+QuotedStr(user)+
                       ','+docdt+
                       ')';
    //cmd.ExecSQL();
    res := SQLExecEx(str);


  finally
    //cmd.Free;
  end;


end;


//--------------

{
procedure UpdateIADP(seq:Integer;vtrdt,vtrno,vtrno1,vpscd,pycoa,trdesc:String;vamt:Double;user:String);
var cmd : TSQLQuery;
begin
  cmd := TSQLQuery.Create(nil);
  cmd.SQLConnection := dm.mySQL1;

  try

  //Debit - Payment type



      cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,pscd,coa,dbamt,cramt,trdesc,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(seq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(pycoa)+
                       ','+FloatToStr(vamt)+
                       ',0'+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
      cmd.ExecSQL();

  //Credit - Deposit
  cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,pscd,coa,dbamt,cramt,trdesc,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(seq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(SQLExec2('select pycd,pycoa from iaspydt where pycd=''DP''','pycoa'))+
                       ',0'+
                       ','+FloatToStr(vamt)+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
    cmd.ExecSQL();


  finally
    cmd.Free;
  end;


end;
}

procedure UpdateIACO(vtrdt:String;seq:Integer;vtrno,vtrno1,vpscd,pycoa,trdesc,strdesc2,rsvno,subrsvno:String;vamt:Double;user:String);
var cmd : TSQLQuery;
    seqno : Integer;
begin
  cmd := TSQLQuery.Create(nil);
  cmd.SQLConnection := dm.mySQL1;

  if seq = 0 then
    seqno := 0;

  try

  //Debit - Guest Ledger


      cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(seq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(dm.GuestLedgerCOA)+
                       ','+QuotedStr(rsvno)+
                       ','+QuotedStr(subrsvno)+
                       ','+FloatToStr(vamt)+  //dbamt
                       ',0'+                  //cramt
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(strdesc2)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
      cmd.ExecSQL();


  //Credit - Cash Payment
  cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1, pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(seq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(pycoa)+
                       ','+QuotedStr('')+
                       ','+QuotedStr('')+
                       ',0'+                  //dbamt
                       ','+FloatToStr(vamt)+  //cramt
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(strdesc2)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
    cmd.ExecSQL();


  finally
    cmd.Free;
  end;


end;


procedure UpdateIACORR(vtrdt,seq,vtrno,vtrno1,vpscd,dbcoa,crcoa,trdesc:String;vamt:Double;user:String);
var cmd : TSQLQuery;
begin
  cmd := TSQLQuery.Create(nil);
  cmd.SQLConnection := dm.mySQL1;

  try

  //Debit -


      cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,pscd,coa,dbamt,cramt,trdesc,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+QuotedStr(seq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(dbcoa)+
                       ','+FloatToStr(vamt)+  //dbamt
                       ',0'+                  //cramt
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
      cmd.ExecSQL();


  //Credit -
    cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1, pscd,coa,dbamt,cramt,trdesc,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+QuotedStr(seq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(crcoa)+
                       ',0'+                  //dbamt
                       ','+FloatToStr(vamt)+  //cramt
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
    cmd.ExecSQL();


  finally
    cmd.Free;
  end;


end;


procedure getPyCOA(pycd,pydtcd: String;var coacd,coacomm : String; var commpct : Double);
var cmd : TSQLQuery;
begin
  cmd := TSQLQuery.Create(nil);
  try
    cmd.SQLConnection := dm.mySQL1;
    cmd.CommandText := 'select pycoa,pycommcoa,pycommpct from iaspydt where pycd='+QuotedStr(pycd)+' and pydtcd='+QuotedStr(pydtcd);
    cmd.Open;
    if cmd.RecordCount>0 then begin
      coacd := cmd['pycoa'];
      coacomm := cmd['pycommcoa'];
      commpct := cmd['pycommpct']/100;
    end;
  finally
    cmd.Free;
  end;
end;


procedure UpdateIARBT(vseq:Integer;vtrdt,vtrno,vpscd,vcoarvn,vcoasvchg,vcoatax,rsvno,subrsvno,trdesc:String;vamt,vsvchg,vtax:Double;user:String);
var cmd : TSQLQuery;
begin
  cmd := TSQLQuery.Create(nil);
  try
    cmd.SQLConnection := dm.mySQL1;

    //Debet - Revenue
    cmd.Close;
    cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,pscd,coa,dbamt,cramt,usrcrt,docdt,active)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(vcoarvn)+
                       ','+FloatToStr(vamt)+
                       ',0'+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ',1)';
    cmd.ExecSQL();

    //Debet - Service Charge
    cmd.Close;
    cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,pscd,coa,dbamt,cramt,usrcrt,docdt,active)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(vcoasvchg)+
                       ','+ FloatToStr(vsvchg)+
                       ',0'+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ',1)';
    cmd.ExecSQL();

    //Debet - Tax
    cmd.Close;
    cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,pscd,coa,dbamt,cramt,usrcrt,docdt,active)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(vcoatax)+
                       ','+FloatToStr(vtax)+
                       ',0'+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ',1)';
    cmd.ExecSQL();


        //Credit - Guest Ledger
    cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,trdesc2,usrcrt,docdt,active)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(dm.GuestLedgerCOA)+
                       ','+QuotedStr(rsvno)+
                       ','+QuotedStr(subrsvno)+
                       ',0'+
                       ','+FloatToStr(vamt+vsvchg+vtax)+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ',1)';
    cmd.ExecSQL();

  finally
    cmd.Free;
  end;
end;

procedure WriteChangesLog(user,tablenm,keynm,keyvalue,fieldnm,oldvalue,newvalue: String; dt: TDate; tm,formnm,act: String);
var cmd : String;
begin
  cmd := 'insert into changeslog (username,tablename,keyname,keyvalue,fieldname,oldvalue,newvalue,date,time,formname,action) values (' +
           QuotedStr(user) +
         ','+QuotedStr(tablenm)+
         ','+QuotedStr(keynm)+
         ','+QuotedStr(keyvalue)+
         ','+QuotedStr(fieldnm)+
         ','+QuotedStr(oldvalue)+
         ','+QuotedStr(newvalue)+
         ','+RelaxDate(dt)+
         ','+QuotedStr(tm)+
         ','+QuotedStr(formnm)+
         ','+QuotedStr(act)+
         ')';

  SQLExec(cmd);
end;

procedure DoCheckIn2(rsvno,roomno:String;CancelCI:Boolean);
var command : TSQLQuery;
    msgtext,cmdtext,resulttxt : String;
begin

  rsvno    := QuotedStr(rsvno);

  if CancelCI = False then begin
    msgtext := 'Do you want to check-in ';
    cmdtext := 'update fofrsv set rsvst=''R'',citm='+QuotedStr(TimeToStr(time))+',cidt='+RelaxDate(getfoprd)+',ciuser='+QuotedStr(dm.UserID)+' where rsvno='+rsvno;
    resulttxt := ' has been checked-in';

  end
  else if CancelCI = True then begin
    msgtext := 'Do you want to cancel check-in ';
    cmdtext := 'update fofrsv set rsvst=''D'',cansttm='+QuotedStr(TimeToStr(time))+',canstdt='+RelaxDate(getfoprd)+',canstuser='+QuotedStr(dm.UserID)+' where rsvno='+rsvno;
    resulttxt := ' has been cancelled for checked-in';


  end;


  if MessageDlg(msgtext+rsvno,mtConfirmation,[mbYes,mbNo],0) = mrYes then begin


  command  := TSQLQuery.Create(nil);
  try
    command.SQLConnection := dm.mySQL1;
    command.SQL.Text := cmdtext;
    command.ExecSQL();

    if CancelCI = False then
      UpdateRmStCI(roomno)
    else if CancelCI=True then
      UpdateRmStCancelCI(roomno);


    Command.SQL.Text := 'update fosroom set roomstfo1=''O'',roomsthk1=''O'' where roomno = '+ QuotedStr(roomno);
    Command.ExecSQL(True);

    SQLExec('update fosroom set roomstfo1=''O'',roomsthk1=''O'' where roomno in (select roomno from fofrsv where rsvst=''R'')');

  finally
    command.Free;
  end;


  MessageDlg('Reservation '+rsvno+resulttxt,mtInformation,[mbOK],0);

  end;


end;

procedure DoCheckOut2(rsvno,roomno:String;depdt:TDate;CancelCO:Boolean);
var msgtext,cmdtext,resulttxt : String;
begin

  rsvno    := QuotedStr(rsvno);

  if CancelCO = False then begin
    msgtext := 'Do you want to check-out ';
    cmdtext := 'update fofrsv set rsvst=''O'' where rsvno='+rsvno;
    resulttxt := ' has been checked-out';


  end
  else if CancelCO = True then begin
    msgtext := 'Do you want to cancel check-out ';
    cmdtext := 'update fofrsv set rsvst=''R'' where rsvno='+rsvno;
    resulttxt := ' has been cancelled for checked-out';

  end;

  if CancelCO = False then
    UpdateRmStCO(roomno)
  else if CancelCO=True then
    UpdateRmStCancelCO(roomno);

  SQLExec(cmdtext);
  SQLExec('update fosroom set roomstfo1=''O'',roomsthk1=''O'' where roomno in (select roomno from fofrsv where rsvst=''R'')');
  SQLExec('update fosroom set roomstfo1=''V'',roomsthk1=''V'' where roomno in (select roomno from fofrsv where rsvst<>''R'')');

  if depdt >= getFOPrd then
    SQLExec('update fofrsv set depdt = '+RelaxDate(getFOPrd) +' where rsvno='+rsvno);

  MessageDlg('Reservation '+rsvno+resulttxt,mtInformation,[mbOK],0);

end;


procedure UpdateRmStCI(roomno:String);
var oldroomst,newroomst : String;
    res : Integer;
begin
  //
  oldroomst := GetData('select concat(roomsthk1,roomsthk2,roomsthk3) as roomst from fosroom where roomno='+QuotedStr(roomno),'roomst');
  res :=  SQLExecEx('update fosroom set roomstfo1=''O'', roomsthk1=''O'' where roomno='+QuotedStr(roomno));
  if res > 0 then begin
    newroomst := GetData('select concat(roomsthk1,roomsthk2,roomsthk3) as roomst from fosroom where roomno='+QuotedStr(roomno),'roomst');
    WriteChangesLog('system','fosroom','roomno',roomno,'roomst',oldroomst,newroomst,getFOPrd,getFOTime,'Reservation','Check In');
  end;
end;

procedure UpdateRmStCancelCI(roomno:String);
var oldroomst,newroomst : String;
    res : Integer;
begin
  //
  oldroomst := GetData('select concat(roomsthk1,roomsthk2,roomsthk3) as roomst from fosroom where roomno='+QuotedStr(roomno),'roomst');
  res := SQLExecEx('update fosroom set roomstfo1=''V'',roomstfo2=''D'', roomsthk1=''V'',roomsthk2=''D'' where roomno='+QuotedStr(roomno));
  if res > 0 then begin
    newroomst := GetData('select concat(roomsthk1,roomsthk2,roomsthk3) as roomst from fosroom where roomno='+QuotedStr(roomno),'roomst');
    WriteChangesLog('system','fosroom','roomno',roomno,'roomst',oldroomst,newroomst,getFOPrd,getFOTime,'Reservation','Cancel Check In');
  end;

end;

procedure UpdateRmStCO(roomno:String);
var oldroomst,newroomst : String;
    res : Integer;
begin
  oldroomst := GetData('select concat(roomsthk1,roomsthk2,roomsthk3) as roomst from fosroom where roomno='+QuotedStr(roomno),'roomst');
  res := SQLExecEx('update fosroom set roomstfo1=''V'',roomstfo2=''D'', roomsthk1=''V'',roomsthk2=''D'' where roomno='+QuotedStr(roomno));
  if res > 0 then begin
    newroomst := GetData('select concat(roomsthk1,roomsthk2,roomsthk3) as roomst from fosroom where roomno='+QuotedStr(roomno),'roomst');
    WriteChangesLog('system','fosroom','roomno',roomno,'roomst',oldroomst,newroomst,getFOPrd,getFOTime,'Reservation','Check Out');
  end;
end;

procedure UpdateRmStCancelCO(roomno:String);
var oldroomst,newroomst : String;
    res : Integer;
begin
  //
  oldroomst := GetData('select concat(roomsthk1,roomsthk2,roomsthk3) as roomst from fosroom where roomno='+QuotedStr(roomno),'roomst');
  res := SQLExecEx('update fosroom set roomstfo1=''O'',roomstfo2=''D'', roomsthk1=''O'',roomsthk2=''D'' where roomno='+QuotedStr(roomno));
  if res > 0 then begin
    newroomst := GetData('select concat(roomsthk1,roomsthk2,roomsthk3) as roomst from fosroom where roomno='+QuotedStr(roomno),'roomst');
    WriteChangesLog('system','fosroom','roomno',roomno,'roomst',oldroomst,newroomst,getFOPrd,getFOTime,'Reservation','Cancel Check Out');
  end;
end;

function GetData2(query : String) : TSimpleDataSet;
var cmd : TSimpleDataSet;
begin
  cmd := TSimpleDataSet.Create(nil);
  cmd.Connection := dm.mySQL1;
  cmd.DataSet.CommandText := query;
  cmd.Open;
  result := cmd;
  cmd.Close;
  cmd.Free;
end;

function getnextcashiertoken : String;
var lastno : Integer;
begin
  lastno := GetData('select lastno from cashiertoken','lastno');
  SQLExec('update cashiertoken set lastno='+inttostr(lastno));
  result := 'CS'+IntToStr(lastno);

end;

function getLastInsertID : Integer;
var cmd : TSQLQuery;
begin
  cmd := TSQLQuery.Create(nil);
  try
    cmd.SQLConnection := dm.mySQL1;
    cmd.CommandText := 'select last_insert_id() as newid';
    cmd.Open;
    Result := cmd['newid'];
  finally
    cmd.Free;
  end;


end;

function CheckOpenCashier(user : String) : Boolean;
var status : Integer;
    str : String;
begin
  str := 'select max(loggedin) as loggedin from fofcashier2 where userid = '+QuotedStr(user)+' and date='+RelaxDate(getFoPrd);
  status := GetData(str,'loggedin');
  if status = 1 then
    Result := True
  else
    Result := False;
end;

function CheckZeroBalance(rsvno : String) : Boolean;
var dsGuestBill : TSimpleDataSet;
    dbamt,cramt,sum : Double;
begin
      dsGuestBill := TSimpleDataSet.Create(nil);
      dbamt := 0; cramt := 0; sum := 0;
      try
        dsGuestBill.Connection := dm.mySQL1;
        if dsGuestBill.Active then dsGuestBill.Close;
        dsGuestBill.DataSet.CommandText := 'select a.pscd,a.trdt,a.trno, IF(LEFT(a.trno,2)=''PC'',''ROOM CHARGE'',b.psdesc) as psdesc,IF(LEFT(a.trno,2)=''PC'',''ROOM CHARGE'',a.trdesc) as trdesc,a.trno1,a.subtrno1,a.rsvno,a.subrsvno,a.coa,sum(a.dbamt) as debit,sum(a.cramt) as credit' +
                                         ' from iafjrngl a, pssps b'+
                                         ' where a.pscd=b.pscd' +
                                         ' and a.coa in (select pycoa from iaspydt where pycd=''GL'')' +
                                         ' and a.rsvno='+QuotedStr(rsvno)+
                                         ' and a.active <> 0' +
                                         ' group by a.trno';
        dsGuestBill.Open;

        dsGuestBill.First;
        while not dsGuestBill.Eof do begin
          dbamt := dbamt + dsGuestBill['debit'];
          cramt := cramt + dsGuestBill['credit'];;
          dsGuestBill.Next;
        end;
        dsGuestBill.First;

        sum := dbamt - cramt;

        if sum = 0 then
          Result := True
        else
          Result := False;

      finally
        dsGuestBill.Free;
      end;

end;

procedure gettodayrate(trdt:TDate;rsvno,rsvst:String);
var cmd : TSimpleDataSet;
    rateamt : Double;
    dt,useddt : TDate;
begin
  cmd := TSimpleDataSet.Create(nil);
  try

    dt := GetData('select arrdt from fofrsv where rsvno='+QuotedStr(rsvno),'arrdt');
    if rsvst='R' then useddt := trdt else  useddt := dt;

    cmd.Connection := dm.mySQL1;
    cmd.DataSet.CommandText := 'select a.trdt,sum(a.amtrvn) as amtplus2,(sum(a.amtrvn)+sum(a.amtsvchg)+sum(a.amttax)) as amtnett from fofrate a' +
                               ' where a.rsvno = '+QuotedStr(rsvno)+ ' and a.trdt='+ RelaxDate(useddt) +
                               ' group by a.trdt order by trdt';
    cmd.Open;
    if cmd.RecordCount = 0 then Exit;
    
    rateamt := Round(cmd['amtnett']);
    SQLExec('update fofrsv set rateamt='+FloatToStr(rateamt)+ ' where rsvno = '+QuotedStr(rsvno));
  finally
    cmd.Free;
  end;

end;

procedure FindBillMgmt(rsvnofrom,pscd: String; var rsvnoto,subrsvnoto: String);
var cmd : TSimpleDataSet;
begin
   // find bill mgmt
   cmd := TSimpleDataSet.Create(nil);
   try
      cmd.Connection := dm.mySQL1;
      cmd.DataSet.CommandText := 'select * from fofbill where rsvno='+QuotedStr(rsvnofrom) + ' and pscd=' + QuotedStr(pscd) + ' and active = 1';
      cmd.Open;
      if cmd.RecordCount > 0 then begin
        rsvnoto := cmd['rsvnoto'];
        subrsvnoto := cmd['subrsvnoto'];
      end else if cmd.RecordCount = 0 then begin
        rsvnoto := '';
        subrsvnoto := '';

      end;

   finally
     cmd.Free;
   end;
end;

procedure FindBillMgmtPC(rsvnofrom: String; var rsvnoto,subrsvnoto: String);
var cmd : TSimpleDataSet;
begin
   // find bill mgmt
   cmd := TSimpleDataSet.Create(nil);
   try
      cmd.Connection := dm.mySQL1;
      cmd.DataSet.CommandText := 'select * from fofbill where rsvno='+QuotedStr(rsvnofrom) + ' and pscd=' + QuotedStr('PC') + ' and active = 1';
      cmd.Open;
      if cmd.RecordCount > 0 then begin
        rsvnoto := cmd['rsvnoto'];
        subrsvnoto := cmd['subrsvnoto'];
      end else if cmd.RecordCount = 0 then begin
        rsvnoto := '';
        subrsvnoto := '';

      end;

   finally
     cmd.Free;
   end;
end;


procedure CheckDiscrepancyCI(roomno: String;var rsvno,rsvnm: String; var bRoomIsUsed: Boolean);
var Cmd : TSimpleDataSet;
begin
  // cek discrepancy;
  Cmd := TSimpleDataSet.Create(nil);
  Cmd.Connection := dm.mySQL1;
  try
    Cmd.DataSet.CommandText := 'select rsvno,rsvnm,roomno,rsvst from fofrsv where rsvst=''R'' and roomno='+QuotedStr(roomno) +
                               ' and arrdt <= ' + RelaxDate(getFOPrd) + ' and depdt >= ' + RelaxDate(getFOPrd);
    Cmd.Open;
    if Cmd.RecordCount > 0 then begin
      bRoomIsUsed := True;
      rsvno := Cmd['rsvno'];
      rsvnm := Cmd['rsvnm'];
    end else begin
      bRoomIsUsed := False;
      rsvno := '';
      rsvnm := '';
    end;
  finally
    Cmd.Free;
  end;
end;


procedure UpdateProdBalEx(trdt:TDate;prodcd,whcd : String;no_transaction:Boolean);
var glfprodbal,calc : TSimpleDataSet;
    prd,lastprd,xx,yy,lgprd,calcprd,priorprd,queryamtst : String;
    qtypurch,qtysr,qtybeg,purchase,returnreceiving,storerequest,returnstorerequest,qtytrin,qtytrout,qtyst : Double;
    amtpurch,amtsr,amtbeg,amtpurchase,amtreturnreceiving,amtstorerequest,amtreturnstorerequest,amttrin,amttrout,amtst : Double;
    amtend : Double;
    arry : Integer;
    y,m,d:Word;
    I : Integer;
    qtyst2 : array of Double;
begin

  prd := FormatDateTime('yyyymm',trdt);
  lgprd := GetData('select lgprd from gnsystem','lgprd');
  lastprd := GetPriorPrd(prd);

  glfprodbal := TSimpleDataSet.Create(nil);
  glfprodbal.Connection := dm.mySQL1;
  calc := TSimpleDataSet.Create(nil);
  calc.Connection := dm.mySQL1;

{
  if no_transaction = false then begin
    if whcd = '' then Exit;
  end;
}

  if no_transaction = True then begin
    if glfprodbal.Active then glfprodbal.Close;
    glfprodbal.DataSet.CommandText := 'select * from glfprodbal where prd = ' + QuotedStr(lastprd);
    glfprodbal.Open;
    glfprodbal.First;

    while not glfprodbal.Eof do begin
      SQLExec('delete from glfprodbal where prd = '+QuotedStr(prd)+' and whcd='+QuotedStr(glfprodbal['whcd'])+' and prodcd='+QuotedStr(glfprodbal['prodcd']));
      SQLExec('insert into glfprodbal (prd,whcd,prodcd,qtybeg,amtbeg,qtyend,amtend)' +
              ' values ('+QuotedStr(prd)+','+QuotedStr(glfprodbal['whcd'])+','+QuotedStr(glfprodbal['prodcd'])+','+FloatToStr(glfprodbal['qtyend'])+','+FloatToStr(glfprodbal['amtend'])+','+FloatToStr(glfprodbal['qtyend'])+','+FloatToStr(glfprodbal['amtend'])+')');
      glfprodbal.Next;
    end;

  end;

  if glfprodbal.Active then glfprodbal.Close;
  try
  glfprodbal.DataSet.CommandText := 'select * from glfprodbal'; //where prd';// = ' + QuotedStr(prd);
  glfprodbal.Open;
  except
    On E : Exception do ShowMessage(E.Message);
  end;

  //start looping

  SetLength(qtyst2,StrToInt(prd)-StrToInt(lgprd)+1);

  calcprd := lgprd;

  while calcprd <= prd do begin

  //for I := StrToInt(lgprd) to StrToInt(prd) do begin
    //calcprd := IntToStr(I);
    arry := StrToInt(calcprd)-StrToInt(lgprd);
    //lastprd := GetPriorPrd(calcprd);

    //CARA BARU

    priorprd := GetPriorPrd(calcprd);

    glfprodbal.ApplyUpdates(0);
    glfprodbal.Refresh;

    if glfprodbal.Locate('prd;prodcd;whcd',VarArrayOf([priorprd,prodcd,whcd]),[]) then begin
      //qtybeg := glfprodbal['qtybeg'];
      //amtbeg := glfprodbal['amtbeg'];
      qtybeg := glfprodbal['qtyend'];
      amtbeg := glfprodbal['amtend'];
    end else begin
      qtybeg := 0;
      amtbeg := 0;
    end;

    xx := 'select ifnull(sum(qty)-sum(qtyout),0) as R from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7010'' or trtpcd=''7081''';
    yy := 'select ifnull(sum(qty),0) as ST from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+'  and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7050''';
    calc.DataSet.CommandText := yy;
    calc.Open;
    qtyst := calc['ST'];
    yy := 'select ifnull(sum(qty)-sum(qtyout),0) as R from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7010'' or trtpcd=''7081''';
    calc.Close;
    calc.DataSet.CommandText := yy;
    calc.Open;
    purchase    := calc['R'];
    //purchase           := GetData('select ifnull(sum(qty)-sum(qtyout),0) as R from glftrdt where prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7010'' or trtpcd=''7081''','R');
    amtpurchase        := GetData('select ifnull(sum(LDbAmt)-sum(LCrAmt),0) as amtR from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7010'' or trtpcd=''7081''','amtR');
    storerequest       := GetData('select ifnull(sum(qty)-sum(qtyout),0) as SR from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whfr='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7020'' or trtpcd=''7082''','SR');
    //amtstorerequest    := GetData('select ifnull(sum(LDbAmt)-sum(LCrAmt),0) as amtSR from glftrdt where prodcd='+ QuotedStr(ProdCd)+ ' and whfr='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7020'' or trtpcd=''7082''','amtSR');
    amtstorerequest    := GetData('select ifnull(sum(LCrAmt)-sum(LDbAmt),0) as amtSR from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whfr='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7020'' or trtpcd=''7082''','amtSR');
    qtytrin            := GetData('select ifnull(sum(qty),0) as TRIN from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+'  and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7082'' and whto='+QuotedStr(whcd),'TRIN');
    amttrin            := GetData('select ifnull(sum(LDbAmt),0) as amtTRIN from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+'  and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7082'' and whto='+QuotedStr(whcd),'amtTRIN');
    qtytrout           := GetData('select ifnull(sum(qty),0) as TROUT from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7082'' and whfr='+QuotedStr(whcd),'TROUT');
    amttrout           := GetData('select ifnull(sum(LCrAmt),0) as amtTROUT from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7082'' and whfr='+QuotedStr(whcd),'amtTROUT');
    //qtyst              := GetData(yy,'ST');
    //qtyst2[arry]          := GetData(yy,'ST');
    //amtst              := GetData('select ifnull(sum(LDbAmt),0) as amtST from glftrdt where prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+'  and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7050''','amtST');
    queryamtst   := 'select ifnull(sum(TotalPrice),0) as amtST from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+'  and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7050''';
    //amtst              := GetData('select ifnull(sum(TotalPrice),0) as amtST from glftrdt where prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+'  and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7050''','amtST');
    calc.Close;
    calc.DataSet.CommandText := queryamtst;
    calc.Open;

    SQLExec('delete from glfprodbal where prd='+QuotedStr(calcprd)+' and prodcd='+QuotedStr(prodcd)+' and whcd='+QuotedStr(whcd));

    if glfprodbal.Active = False then glfprodbal.Open;
    glfprodbal.Append;
    glfprodbal['prd'] := calcprd;
    glfprodbal['whcd'] :=  whcd;
    glfprodbal['prodcd'] := prodcd;
    glfprodbal['qtybeg'] := qtybeg;
    glfprodbal['qtypurch'] := purchase;//receiving - returnreceiving;
    glfprodbal['qtysr']    := storerequest; // storerequest - returnstorerequest;
    glfprodbal['qtytrin']   := qtytrin;
    glfprodbal['qtytrout']  := qtytrout;
    glfprodbal['qtyst']     := qtyst; //calc['ST'];
    //bugs found by FOSA -- 28/09/2011
    //glfprodbal['qtyend'] := qtybeg + glfprodbal['qtypurch'] + glfprodbal['qtysr'] + glfprodbal['qtytrin'] - glfprodbal['qtytrout'] + glfprodbal['qtyst'];
    glfprodbal['qtyend'] := qtybeg + glfprodbal['qtypurch'] - glfprodbal['qtysr'] + glfprodbal['qtytrin'] - glfprodbal['qtytrout'] + glfprodbal['qtyst'];
    //glfprodbal['avgcost'] := glfprodbal['amtend'] / glfprodbal['qtyend'];
    glfprodbal['amtbeg'] := amtbeg;
    glfprodbal['amtpurch'] := amtpurchase;
    glfprodbal['amtsr']    := amtstorerequest;
    glfprodbal['amtst']  :=  calc['amtST'];           //amtst;
    amtend := amtbeg + amtpurchase - amtstorerequest + amttrin - amttrout + calc['amtST'];
    glfprodbal['amtend']   := amtend;
    if glfprodbal['qtyend'] = 0 then
      glfprodbal['avgcost'] := 0
    else
      glfprodbal['avgcost']  := glfprodbal['amtend'] / glfprodbal['qtyend'];
    glfprodbal.Post;
    glfprodbal.ApplyUpdates(0);

    qtyst := 0;
    calc.Close;

    calcprd := GetNextPrd(calcprd);

  end;


  //returnreceiving    := GetData('select ifnull(sum(qty),0) as RR from glftrdt where prodcd='+ QuotedStr(ProdCd)+ ' and extract(year_month from '+ RelaxDate(trdt) +') ='+QuotedStr(prd)+ ' and trtpcd=''7081''','RR');
  //returnstorerequest := GetData('select ifnull(sum(qty),0) as RSR from glftrdt where prodcd='+ QuotedStr(ProdCd)+ ' and whcd='+QuotedStr(whcd)+'  and extract(year_month from '+ RelaxDate(trdt) +') ='+QuotedStr(prd)+ ' and trtpcd=''7082''','RSR');


  {if glfprodbal.Active = False then glfprodbal.Open;
  if glfprodbal.Locate('prd;prodcd;whcd',VarArrayOf([prd,prodcd,whcd]),[]) then begin
    glfprodbal.Delete;
    glfprodbal.ApplyUpdates(0);
  end;}




end;

procedure UpdateProdBalEx2(trdt:TDate;prodcd,whcd : String;no_transaction:Boolean);
var glfprodbal,calc : TSimpleDataSet;
    prd,lastprd,xx,yy,lgprd,calcprd,priorprd,queryamtst : String;
    qtypurch,qtysr,qtybeg,purchase,returnreceiving,storerequest,returnstorerequest,qtytrin,qtytrout,qtyst : Double;
    amtpurch,amtsr,amtbeg,amtpurchase,amtreturnreceiving,amtstorerequest,amtreturnstorerequest,amttrin,amttrout,amtst : Double;
    amtend : Double;
    arry : Integer;
    y,m,d:Word;
    I : Integer;
    qtyst2 : array of Double;
    queryst : String;
begin

  prd := FormatDateTime('yyyymm',trdt);
  lgprd := GetData('select lgprd from gnsystem','lgprd');
  lastprd := GetPriorPrd(prd);

  glfprodbal := TSimpleDataSet.Create(nil);
  glfprodbal.Connection := dm.mySQL1;
  calc := TSimpleDataSet.Create(nil);
  calc.Connection := dm.mySQL1;

  if no_transaction = True then begin
    if glfprodbal.Active then glfprodbal.Close;
    glfprodbal.DataSet.CommandText := 'select * from glfprodbal where prd = ' + QuotedStr(lastprd);
    glfprodbal.Open;
    glfprodbal.First;

    while not glfprodbal.Eof do begin
      SQLExec('delete from glfprodbal where prd = '+QuotedStr(prd)+' and whcd='+QuotedStr(glfprodbal['whcd'])+' and prodcd='+QuotedStr(glfprodbal['prodcd']));
      SQLExec('insert into glfprodbal (prd,whcd,prodcd,qtybeg,amtbeg,qtyend,amtend)' +
              ' values ('+QuotedStr(prd)+','+QuotedStr(glfprodbal['whcd'])+','+QuotedStr(glfprodbal['prodcd'])+','+FloatToStr(glfprodbal['qtyend'])+','+FloatToStr(glfprodbal['amtend'])+','+FloatToStr(glfprodbal['qtyend'])+','+FloatToStr(glfprodbal['amtend'])+')');
      glfprodbal.Next;
    end;

  end;

  if glfprodbal.Active then glfprodbal.Close;
  try
  glfprodbal.DataSet.CommandText := 'select * from glfprodbal'; //where prd';// = ' + QuotedStr(prd);
  glfprodbal.Open;
  except
    On E : Exception do ShowMessage(E.Message);
  end;

  //start looping

  SetLength(qtyst2,StrToInt(prd)-StrToInt(lgprd)+1);

  calcprd := lgprd;

  while calcprd <= prd do begin

    arry := StrToInt(calcprd)-StrToInt(lgprd);

    //CARA BARU

    priorprd := GetPriorPrd(calcprd);

    glfprodbal.ApplyUpdates(0);
    glfprodbal.Refresh;

    if glfprodbal.Locate('prd;prodcd;whcd',VarArrayOf([priorprd,prodcd,whcd]),[]) then begin
      //qtybeg := glfprodbal['qtybeg'];
      //amtbeg := glfprodbal['amtbeg'];
      qtybeg := glfprodbal['qtyend'];
      amtbeg := glfprodbal['amtend'];
    end else begin
      qtybeg := 0;
      amtbeg := 0;
    end;
    xx := 'select ifnull(sum(qty)-sum(qtyout),0) as R from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7010'' or trtpcd=''7081''';
    //yy := 'select ifnull(sum(qty),0) as ST from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+'  and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7050''';
    yy := 'select ifnull(sum(qty),0) as ST from vproductcard where trtpcd = ''7050'' and extract(year_month from trdt) = '+QuotedStr(calcprd)+' and prodcd='+QuotedStr(ProdCd)+' and whcd='+QuotedStr(whcd);
    calc.DataSet.CommandText := yy;
    calc.Open;
    qtyst := calc['ST'];
    {
    yy := 'select ifnull(sum(qty)-sum(qtyout),0) as R from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7010'' or trtpcd=''7081''';
    calc.Close;
    calc.DataSet.CommandText := yy;
    calc.Open;
    purchase    := calc['R'];
    }
    purchase        := GetDataFloat('select ifnull(sum(qty),0) as amtr from vproductcard where trtpcd in (''7010'',''7081'') and extract(year_month from trdt) = '+QuotedStr(calcprd)+' and prodcd='+QuotedStr(ProdCd)+' and whcd='+QuotedStr(whcd),'amtr');
    amtpurchase        := GetDataFloat('select ifnull(sum(amount),0) as amtr from vproductcard where trtpcd in (''7010'',''7081'') and extract(year_month from trdt) = '+QuotedStr(calcprd)+' and prodcd='+QuotedStr(ProdCd)+' and whcd='+QuotedStr(whcd),'amtr');
    //amtpurchase        := GetData('select ifnull(sum(LDbAmt)-sum(LCrAmt),0) as amtR from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7010'' or trtpcd=''7081''','amtR');
    storerequest       := GetDataFloat('select ifnull(sum(qty),0) as qtySR from vproductcard where trtpcd in (''7020'',''7082'') and extract(year_month from trdt) = '+QuotedStr(calcprd)+' and prodcd='+QuotedStr(ProdCd)+' and whcd='+QuotedStr(whcd),'qtySR');
    //storerequest       := GetData('select ifnull(sum(qty)-sum(qtyout),0) as SR from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whfr='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7020'' or trtpcd=''7082''','SR');
    amtstorerequest       := GetDataFloat('select ifnull(sum(amount),0) as amtSR from vproductcard where trtpcd in (''7020'',''7082'') and extract(year_month from trdt) = '+QuotedStr(calcprd)+' and prodcd='+QuotedStr(ProdCd)+' and whcd='+QuotedStr(whcd),'amtSR');
    //amtstorerequest    := GetData('select ifnull(sum(LCrAmt)-sum(LDbAmt),0) as amtSR from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whfr='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7020'' or trtpcd=''7082''','amtSR');
    qtytrin            := 0; //GetDataFloat('select sum(qty) as qtyTRIN from vproductcard where trtpcd = ''7082'' and extract(year_month from trdt) = '+QuotedStr(calcprd)+' and prodcd='+QuotedStr(ProdCd),'qtyTRIN');
    //qtytrin            := GetData('select ifnull(sum(qty),0) as TRIN from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+'  and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7082'' and whto='+QuotedStr(whcd),'TRIN');
    amttrin            := 0; //GetDataFloat('select sum(amount) as amtTRIN from vproductcard where trtpcd = ''7082'' and extract(year_month from trdt) = '+QuotedStr(calcprd)+' and prodcd='+QuotedStr(ProdCd),'amtTRIN');
    //amttrin            := GetData('select ifnull(sum(LDbAmt),0) as amtTRIN from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+'  and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7082'' and whto='+QuotedStr(whcd),'amtTRIN');
    qtytrout           := 0; //GetDataFloat('select sum(qty) as qtyTROUT from vproductcard where trtpcd = ''7082'' and extract(year_month from trdt) = '+QuotedStr(calcprd)+' and prodcd='+QuotedStr(ProdCd),'qtyTRIN');
    //qtytrout           := GetData('select ifnull(sum(qty),0) as TROUT from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7082'' and whfr='+QuotedStr(whcd),'TROUT');
    amttrout        := 0;
    //amttrout           := GetData('select ifnull(sum(LCrAmt),0) as amtTROUT from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+' and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7082'' and whfr='+QuotedStr(whcd),'amtTROUT');
    //queryamtst   := 'select ifnull(sum(TotalPrice),0) as amtST from glftrdt where active = 1 and prodcd='+ QuotedStr(ProdCd)+ ' and whto='+QuotedStr(whcd)+'  and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7050''';
    queryamtst   := 'select ifnull(sum(Amount),0) as amtST from vproductcard where prodcd='+ QuotedStr(ProdCd)+ ' and whcd='+QuotedStr(whcd)+'  and extract(year_month from trdt)='+QuotedStr(calcprd)+ ' and trtpcd=''7050''';
    calc.Close;
    calc.DataSet.CommandText := queryamtst;
    calc.Open;

    SQLExec('delete from glfprodbal where prd='+QuotedStr(calcprd)+' and prodcd='+QuotedStr(prodcd)+' and whcd='+QuotedStr(whcd));

    if glfprodbal.Active = False then glfprodbal.Open;
    glfprodbal.Append;
    glfprodbal['prd'] := calcprd;
    glfprodbal['whcd'] :=  whcd;
    glfprodbal['prodcd'] := prodcd;
    glfprodbal['qtybeg'] := qtybeg;
    glfprodbal['qtypurch'] := purchase;//receiving - returnreceiving;
    glfprodbal['qtysr']    := storerequest; // storerequest - returnstorerequest;
    glfprodbal['qtytrin']   := qtytrin;
    glfprodbal['qtytrout']  := qtytrout;
    glfprodbal['qtyst']     := qtyst; //calc['ST'];
    //glfprodbal['qtyend'] := qtybeg + glfprodbal['qtypurch'] - glfprodbal['qtysr'] + glfprodbal['qtytrin'] - glfprodbal['qtytrout'] + glfprodbal['qtyst'];
    glfprodbal['qtyend'] := qtybeg + glfprodbal['qtypurch'] + glfprodbal['qtysr'] + glfprodbal['qtytrin'] + glfprodbal['qtytrout'] + glfprodbal['qtyst'];
    glfprodbal['amtbeg'] := amtbeg;
    glfprodbal['amtpurch'] := amtpurchase;
    glfprodbal['amtsr']    := amtstorerequest;
    glfprodbal['amtst']  :=  calc['amtST'];           //amtst;
    amtend := amtbeg + amtpurchase + amtstorerequest + amttrin + amttrout + calc['amtST'];
    glfprodbal['amtend']   := amtend;
    if glfprodbal['qtyend'] = 0 then
      glfprodbal['avgcost'] := 0
    else
      glfprodbal['avgcost']  := glfprodbal['amtend'] / glfprodbal['qtyend'];
    glfprodbal.Post;
    glfprodbal.ApplyUpdates(0);

    qtyst := 0;
    calc.Close;

    calcprd := GetNextPrd(calcprd);

  end;

end;


function GetLocalAmt(FAmt:Double;Curr:String): Double;
var base1,base2 : Double;
    cmd : TSimpleDataSet;
begin
  //
  cmd := TSimpleDataSet.Create(nil);
  cmd.Connection := dm.mySQL1;
  try
    cmd.DataSet.CommandText := 'select curr1,curr2 from gncurrdt where currcd='+QuotedStr(Curr);
    cmd.Open;
    if cmd.RecordCount > 0 then begin
      Result := FAmt * cmd['curr2'] / cmd['curr1'];
    end
    else
      Result := 0;

  finally
    cmd.Free;
  end;
end;

procedure GetValueDBCR(dbamt,cramt: Double;var db,cr: Double);
begin
  if dbamt > cramt then begin
    db := RoundTo(dbamt-cramt,-2);
    cr := 0;
  end;

  if cramt > dbamt then begin
    db := 0;
    cr := RoundTo(cramt-dbamt,-2);
  end;

end;

function GetNextPrd(currprd:String) : String;
var qr : TSQLQuery;
begin
  qr := TSQLQuery.Create(nil);
  qr.SQLConnection := dm.mySQL1;
  qr.CommandText := 'select period_add('+QuotedStr(currprd)+',1) as newprd';
  qr.Open;
  Result := qr['newprd'];
end;

function getlastinsertid2(tablename,fieldname : String) : Integer;
var q : TSimpleDataSet;
begin
  q := TSimpleDataSet.Create(nil);
  try
    q.Connection := dm.mySQL1;
    q.Close;
    q.DataSet.CommandText := 'select count(trno) as counttrno from glftrdt';
    q.Open;
    if q['counttrno'] = 0 then begin
      result := 1;
      Exit;
    end;
    q.Close;
    q.DataSet.CommandText := 'select ifnull(max('+fieldname+'),0) + 1 as id from '+tablename;
    q.Open;
    result := q['id'];
  finally
    q.Free;
  end;
end;

function getlastinsertid3(tablename,fieldname: String) : Integer;
var q : TSimpleDataSet;
begin
    q := TSimpleDataSet.Create(nil);
    try
      q.Connection := dm.mySQL1;
      q.DataSet.CommandText := 'select max(right('+fieldname+',4)) + 1 as id from ' + tablename + ' where length('+fieldname+')=8';
      q.Open;
      result := q['id'];
    finally

    end;
end;

function GetPriorPrd(currprd:String) : String;
var qr : TSQLQuery;
begin
  qr := TSQLQuery.Create(nil);
  qr.SQLConnection := dm.mySQL1;
  qr.CommandText := 'select period_add('+QuotedStr(currprd)+',-1) as newprd';
  qr.Open;
  Result := qr['newprd'];
end;


procedure GetCBInAllocate(range:Integer;CBCd,CompCd: String;cutoffdate: TDate;var amtar:Double);
var data : TSimpleDataSet;
    strar,strallc,stradjmin,stradjplus : String;
    dt1,dt2 : TDate;
    amtallc,amtadjmin,amtadjplus : Double;
    x,y,z: Double;
begin

  dt1 := cutoffdate - range;
  if range < 91 then
    dt2 := cutoffdate - (range + 30)
  else
    dt2 := cutoffdate - (range + 1825);

  amtallc := 0;
  amtar := 0;
  data := TSimpleDataSet.Create(nil);
  data.Connection := dm.mySQL1;
  //data.DataSet.CommandText := 'select * from glftrhd where trtpcd=''4011'' and CompCd='+QuotedStr(CompCd);
  {strar := 'select * from glftrhd where active = 1 and trtpcd=''3010'' and CompCd='+QuotedStr(CompCd) +
           ' and trno in (select subtrno from glftrhd where active = 1 and trtpcd=''9994'')' +
           ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1);}
  strar := 'select * from glftrhd where active = 1 and trtpcd=''3010'' and CompCd='+QuotedStr(CompCd) +
           ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1);

  data.DataSet.CommandText := strar;
  data.Open;
  data.First;

  amtallc := 0; amtadjmin := 0; amtadjplus := 0;

  while not data.Eof do begin
    strallc := 'select ifnull(sum(ftramt),0) as amt from glftrhd where active = 1 and trtpcd = ''9994'' and compcd='+QuotedStr(CompCd)+ ' and trdt <= ' + RelaxDate(cutoffdate) + ' and subtrno='+QuotedStr(data['trno']);
    x := GetDataFloat(strallc,'amt');
    stradjmin := 'select ifnull(sum(ftramt),0) as amt from glftrhd where active = 1 and trtpcd = ''3030'' and compcd='+QuotedStr(CompCd)+ ' and trdt <= ' + RelaxDate(cutoffdate) + ' and subtrno='+QuotedStr(data['trno']);
    y := GetDataFloat(stradjmin,'amt');
    stradjplus := 'select ifnull(sum(ftramt),0) as amt from glftrhd where active =1 and trtpcd = ''3020'' and compcd='+QuotedStr(CompCd)+ ' and trdt <= ' + RelaxDate(cutoffdate) + ' and subtrno='+QuotedStr(data['trno']);
    z := GetDataFloat(stradjplus,'amt');
    amtallc := amtallc + x;
    amtadjmin := amtadjmin + y;
    amtadjplus := amtadjplus + z;
    data.Next;
  end;

  strar := 'select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where active = 1 and CompCd='+QuotedStr(CompCd) + ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1)+ ' and trtpcd = ''3010''';
  //strar := 'select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where CompCd='+QuotedStr(CompCd)+' and trtpcd = ''3010''' +
  //         ' and (trdt between '+RelaxDate(dt2)+' and '+RelaxDate(dt1)+' or trdt < '+RelaxDate(dt2)+')';
  //strar := 'select ifnull(sum(ftramt),0) as nilai from glftrhd where active = 1 and compcd='+ QuotedStr(CompCd) + ' and trtpcd=''3010'' and trdt > ' + RelaxDate(dt1);
  amtar := GetDataFloat(strar,'nilai');

  if amtar > 0 then
    amtar := amtar - amtallc - amtadjmin + amtadjplus
  else
    amtar := 0;

end;

procedure GetCBOutAllocate(range:Integer;CBCd,SupCd: String;cutoffdate: TDate;var amtap:Double);
var data : TSimpleDataSet;
    strap,strallc,stradjmin,stradjplus : String;
    dt1,dt2 : TDate;
    amtallc,amtadjmin,amtadjplus : Double;
    x,y,z : Double;
begin


  dt1 := cutoffdate - range;
  if range < 91 then
    dt2 := cutoffdate - (range + 30)
  else
    dt2 := cutoffdate - (range + 1825);


  amtallc := 0;
  amtap := 0;
  data := TSimpleDataSet.Create(nil);
  data.Connection := dm.mySQL1;
  //data.DataSet.CommandText := 'select * from glftrhd where trtpcd=''4011'' and CompCd='+QuotedStr(CompCd);
  {strap := 'select * from glftrhd where active = 1 and trtpcd in (''2010'',''7010'') and SupCd='+QuotedStr(SupCd) +
           ' and trno in (select subtrno from glftrhd where active = 1 and trtpcd=''9992'')' +
           ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1);}
  strap := 'select * from glftrhd where active = 1 and trtpcd in (''2010'',''7010'') and SupCd='+QuotedStr(SupCd) +
           ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1);


  data.DataSet.CommandText := strap;
  data.Open;
  data.First;

  amtallc := 0;
  amtadjmin := 0;
  amtadjplus := 0;


  while not data.Eof do begin
    strallc := 'select ifnull(sum(ftramt),0) as amt from glftrhd where active = 1 and trtpcd = ''9992'' and supcd='+QuotedStr(SupCd)+ ' and trdt <= ' + RelaxDate(cutoffdate) + ' and subtrno='+QuotedStr(data['trno']);
    x := GetDataFloat(strallc,'amt');
    stradjmin := 'select ifnull(sum(ftramt),0) as amt from glftrhd where active = 1 and trtpcd = ''2030'' and supcd='+QuotedStr(SupCd)+ ' and trdt <= ' + RelaxDate(cutoffdate) + ' and subtrno='+QuotedStr(data['trno']);
    y := GetDataFloat(stradjmin,'amt');
    stradjplus := 'select ifnull(sum(ftramt),0) as amt from glftrhd where active = 1 and trtpcd = ''2020'' and supcd='+QuotedStr(SupCd)+ ' and trdt <= ' + RelaxDate(cutoffdate) + ' and subtrno='+QuotedStr(data['trno']);
    z := GetDataFloat(stradjplus,'amt');
    amtallc := amtallc + x;
    amtadjmin := amtadjmin + y;
    amtadjplus := amtadjplus + z;
    data.Next;
  end;

  strap := 'select IFNULL(sum(FTrAmt),0) as nilai from glftrhd where active = 1 and SupCd='+QuotedStr(SupCd) + ' and trdt between ' + RelaxDate(dt2) + ' and ' + RelaxDate(dt1)+ ' and trtpcd in (''2010'',''7010'')';
  amtap := GetDataFloat(strap,'nilai');

  if amtap <> 0 then
    amtap := amtap - amtallc - amtadjmin + amtadjplus
  else
    amtap := 0;

end;


function UpdateRsvTemp(oldrsvno,newrsvno,grpcd,roomtp,rsvby,rsvnm,ratecd: String; arrdt,depdt: TDate; nights,adult,child: Integer) : String;
begin
  //
  Result := 'update fofrsv_temp' +
            ' set rsvno = '+QuotedStr(newrsvno)+
            ',grpcd='+QuotedStr(grpcd) +
            ',rsvst=''D''' +
            ',roomtpcd='+QuotedStr(roomtp)+
            ',ratecd='+QuotedStr(ratecd)+
            ',rsvtp= ''2''' +
            ',arrdt='+RelaxDate(arrdt)+
            ',depdt='+RelaxDate(depdt)+
            ',adult='+QuotedStr(IntToStr(adult))+
            ',child='+QuotedStr(IntToStr(child))+
            ' where rsvno = '+QuotedStr(oldrsvno);
end;

procedure SelfCheckRoom;
var str : String;
    res : Integer;
begin
  //SQLExec('update fosroom set roomsthk1=''V''');
  str := 'update fosroom set roomsthk1=''V'' where concat(roomsthk1,roomsthk2,roomsthk3) not in (''MMM'',''XXX'')';
  res := SQLExecEx(str);
  res := SQLExecEx('update fosroom set roomsthk1=''O'',roomstfo1=''O'' where roomno in (select roomno from fofrsv where RsvSt = ''R'' order by roomno) and (roomsthk2 <> ''X'' or roomsthk2 <> ''M'')');
end;

procedure UpdateDepDt(rsvno:String;dt:TDate);
var s : String;
    dArr : TDate;
begin
  dArr := GetData('select arrdt from fofrsv where rsvno = ' + QuotedStr(rsvno),'arrdt');
  s := 'update fofrsv set depdt = ' + RelaxDate(dt) + ',nights=datediff('+RelaxDate(dt)+','+RelaxDate(dArr)+')'  + ' where rsvno='+QuotedStr(rsvno);
  SQLExec(s);
end;

function RecCount(Cmd: String) : Integer;
var data : TSimpleDataSet;
    sukses : Integer;
begin
  data := TSimpleDataSet.Create(nil);
  try
    data.Connection := dm.mySQL1;
    data.DataSet.CommandText := Cmd;
    data.Open;
    Result := data.RecordCount;
  finally
    data.Free;
  end;
end;

function GetNextProdCd(Ctg,Ctg2,oneLetter:String) : String;
var recno,maxno : Integer;
    prefix : String;
    str : String;
begin
    //
    prefix := GetData('select prodctg1cd from lgsprodctg where prodctg2cd='+QuotedStr(Ctg2),'prodctg1cd');
    str := 'select count(prodcd) as cnt from lgsprod where left(prodcd,3) = '+QuotedStr(Ctg+oneLetter);
    recno := GetData('select count(prodcd) as cnt from lgsprod where left(prodcd,3) = '+QuotedStr(Ctg+oneLetter),'cnt');
    if recno = 0 then begin
      result := prefix+oneLetter+Format('%.4d',[1]);
      Exit;
    end
    else begin
      maxno := GetData('select max(right(prodcd,4))+1 as newno from lgsprod where left(prodcd,3) = '+QuotedStr(Ctg+oneLetter),'newno');
      result := prefix+oneLetter+Format('%.4d',[maxno]);
    end;
end;

procedure CalcAmtGLHeader(trno,currcd:String;isAdjust:Boolean);
var famt,lamt,frmn,lrmn : Double;
begin
  //

  if isAdjust = True then Exit;

  famt := GetDataFloat('select ifnull(sum(FDbAmt),0) as Amt from glftrdt where trno='+QuotedStr(trno) + ' and active = 1','Amt');
  lamt := GetLocalAmt(famt,currcd);
  frmn := GetDataFloat('select ifnull(sum(FDbAmt),0) as Amt from glftrdt where trno='+QuotedStr(trno) + ' and active = 1','Amt');
  lrmn := GetLocalAmt(frmn,currcd);

  if fromARAPTrans = 1 then Exit;

  SQLExec('update glftrhd set FTrAmt='+FloatToStr(famt)+',LTrAmt='+FloatToStr(lamt)+',FTrAmtRmn='+FloatToStr(frmn)+',LTrAmtRmn='+FloatToStr(lrmn)+' where trno='+QuotedStr(trno));

end;

procedure RoomCharge(chgRsvno,chgRoomno,formnm,act: String);
var data : TSimpleDataSet;
    seq : Integer;
    split,trno,trdescbill,trdescbill2,itemname:String;
    coarvn,coasvchg,coatax: String;
    amt,svchg,tax: Double;
begin

  amt := 0; svchg:=0; tax := 0;

  data := TSimpleDataSet.Create(nil);
  data.Connection := dm.mySQL1;

  if data.Active then data.Close;
      data.DataSet.CommandText := 'select trdt,rsvno,pscd,psitem,qty from fofrate' +
                                  ' where rsvno = ' + QuotedStr(chgRsvno) +
                                  ' and trdt = ' + RelaxDate(GetFOPrd);
      data.Open;
      data.First;

      trno := GetNextTrNo('PC');
      while not data.Eof do begin
        seq := GetNextSeqDt;
        split := 'A'; //-->> HARUSNYA CEK BILLING MANAGEMENT
        //trno := GetNextTrNo('PC');
        trdescbill := Trim(SQLExec2('select psdesc from pssps where pscd='+QuotedStr(data['pscd']),'psdesc')) +' '+ chgRoomno +' - '+data['rsvno'] + ' (R)';
        trdescbill2 := Trim(SQLExec2('select psdesc from pssps where pscd='+QuotedStr(data['pscd']),'psdesc')) +' '+ chgRoomno;

        itemname := SQLExec2('select itemdesc from psspsitem where itemcd='+QuotedStr(data['psitem'])+ ' and pscd='+QuotedStr(data['pscd']),'itemdesc');

        UpdateJrnHD(getFOPrd,trno,split,data['pscd'],chgRsvno,split,trdescbill,FormatDateTime('hh:nn',Time),1,1,dm.UserID);
        UpdateJrnDt(seq,GetFOPrd,data['pscd'],trno,split,data['psitem'],itemname,data['qty'],1,dm.UserID);
        CalcAmtEx(data['psitem'],data['pscd'],trno,data['rsvno'],seq,data['qty'],coarvn,coasvchg,coatax,amt,svchg,tax,GetFOPrd);
        UpdateIA(seq,RelaxDate(GetFOPrd),trno,trno,data['pscd'],coarvn,coasvchg,coatax,data['rsvno'],split,trdescbill,trdescbill2,trdescbill,amt,svchg,tax,True,dm.UserID);
        WriteChangesLog(dm.UserID,'iafjrngl','trno',trno,'trno','',trno,getFOPrd,TimeToStr(Now),formnm,act);
        SQLExec('update fofrate set trno = ' + QuotedStr(trno) + ' where rsvno='+QuotedStr(data['rsvno']) + ' and trdt = ' + RelaxDate(getFOPrd));
        SetNextTrNo('PC');
        data.Next;
      end;
end;

procedure GetData3(query,fieldnm : String; var Hasil: Variant; var Jumlah : Integer);
var data : TSimpleDataSet;
begin
  data := TSimpleDataSet.Create(nil);
  try
    data.Connection := dm.mySQL1;
    data.DataSet.CommandText := query;
    data.Open;
    if data.RecordCount > 0 then begin
      Hasil := data[fieldnm];
      Jumlah := data.RecordCount;
    end;
  finally
    data.Free;
  end;

end;

procedure UpdateIANonSales(vseq:Integer;vtrdt,vtrno,vtrno1,vpscd,vcoacost,rsvno,subrsvno,trdesc,trdesccr:String;costamt:Double;user:String);
var cmd : TSQLQuery;
    sRsvno,sSubrsvno,sTrno1 : String;
begin
  cmd := TSQLQuery.Create(nil);
  try
    cmd.SQLConnection := dm.mySQL1;

    sTrno1 := vtrno1;


    //Debet - Guest Ledger
    cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(sTrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(dm.GuestLedgerCOA)+
                       ','+QuotedStr(rsvno)+
                       ','+QuotedStr(subrsvno)+
                       ','+FloatToStr(costamt)+
                       ',0'+
                       ','+QuotedStr(trdesc)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
    cmd.ExecSQL();


    //Credit - Revenue
    cmd.Close;
    cmd.CommandText := 'insert into iafjrngl (trdt,seq,trno,trno1,pscd,coa,rsvno,subrsvno,dbamt,cramt,trdesc,usrcrt,docdt)' +
                       ' values ('+vtrdt+
                       ','+IntToStr(vseq)+
                       ','+QuotedStr(vtrno)+
                       ','+QuotedStr(vtrno1)+
                       ','+QuotedStr(vpscd)+
                       ','+QuotedStr(vcoacost)+
                       ','+QuotedStr('')+
                       ','+QuotedStr('')+
                       ',0'+
                       ','+FloatToStr(costamt)+
                       ','+QuotedStr(trdesccr)+
                       ','+QuotedStr(user)+
                       ','+vtrdt+
                       ')';
    cmd.ExecSQL();

  finally
    cmd.Free;
  end;
end;

procedure CalcAmtNonSales(seq:Integer;outletcd,itemcd,trno,trdesc: string; qty,disc: Integer;costamt:Double);
var item,gl,trdt : TSimpleDataSet;
    sqlcmd : TSQLQuery;
    amt,rateamt,discamt,svchg,tax:Double;
    coarvn,coasvchg,coatax,coacost: String;
begin
  //menghitung dan menyimpan amt,svchg,taxamt

  gl := TSimpleDataSet.Create(nil);
  gl.Connection := dm.mySQL1;
  trdt := TSimpleDataSet.Create(nil);
  trdt.Connection := dm.mySQL1;
  sqlcmd := TSQLQuery.Create(nil);
  sqlcmd.SQLConnection := dm.mySQL1;
  item := TSimpleDataSet.Create(nil);
  item.Connection := dm.mySQL1;

  try
    item.DataSet.CommandText := 'select amtsls,pctsvchg,pcttax,coarvn,coasvchg,coatax,itemdesc,amtcost,coacost from psspsitem where itemcd='+QuotedStr(itemcd) + ' and pscd='+QuotedStr(outletcd);
    item.Open;

    rateamt := item['amtcost'] * qty;
    discamt := rateamt * (disc/100);
    amt := rateamt - discamt;
    //amt   := item['amtsls'] * qty;
    svchg := 0;
    tax   := 0;
    coarvn := '';
    coasvchg := '';
    coatax := '';
    coacost := item['coacost'];

    sqlcmd.CommandText := 'update iafjrndt ' +
                          ' set rvnamt = ' + FloatToStr(amt) +
                          ',rateamt = '+ FloatToStr(rateamt)+
                          ',discamt = '+ FloatToStr(discamt)+
                          ',discpct = '+ IntToStr(disc)+
                          ',qty = ' + IntToStr(qty) +
                          ',svchgamt = ' + FloatToStr(svchg) +
                          ',taxamt = ' + FloatToStr(tax) +
                          ',rvncoa = ' + QuotedStr(coarvn) +
                          ',svchgcoa = ' + QuotedStr(coasvchg) +
                          ',taxcoa = ' + QuotedStr(coatax) +
                          ',costcoa = ' + QuotedStr(coacost) +
                          ' where pscd='+QuotedStr(outletcd)+
                          ' and trno='+QuotedStr(trno)+
                          ' and itemcd='+QuotedStr(itemcd) +
                          ' and seq='+IntToStr(seq);
    sqlcmd.ExecSQL();




   SQLExec('delete from iafjrngl where seq='+IntToStr(seq));

   UpdateIANonSales(seq,RelaxDate(getFOPrd),trno, trno,outletcd,coacost,'','', trdesc,trdesc, amt,dm.UserID);

  finally
    item.Free;
    sqlcmd.Free;
  end;

end;

procedure CalcAmtSales(seq:Integer;outletcd,itemcd,trno: string; qty,disc: Integer);
var item,gl,trdt : TSimpleDataSet;
    sqlcmd : TSQLQuery;
    amt,rateamt,discamt,svchg,tax:Double;
    coarvn,coasvchg,coatax,trdesc: String;
begin
  //menghitung dan menyimpan amt,svchg,taxamt

  gl := TSimpleDataSet.Create(nil);
  gl.Connection := dm.mySQL1;
  trdt := TSimpleDataSet.Create(nil);
  trdt.Connection := dm.mySQL1;
  sqlcmd := TSQLQuery.Create(nil);
  sqlcmd.SQLConnection := dm.mySQL1;
  item := TSimpleDataSet.Create(nil);
  item.Connection := dm.mySQL1;

  try
    item.DataSet.CommandText := 'select amtsls,pctsvchg,pcttax,coarvn,coasvchg,coatax,itemdesc from psspsitem where itemcd='+QuotedStr(itemcd) + ' and pscd='+QuotedStr(outletcd);
    item.Open;

    rateamt := item['amtsls'] * qty;
    discamt := rateamt * (disc/100);
    amt := rateamt - discamt;
    //amt   := item['amtsls'] * qty;
    svchg := amt * (item['pctsvchg']/100);
    tax   := amt * (item['pcttax']/100);
    coarvn := item['coarvn'];
    coasvchg := item['coasvchg'];
    coatax := item['coatax'];

    sqlcmd.CommandText := 'update iafjrndt ' +
                          ' set rvnamt = ' + FloatToStr(amt) +
                          ',rateamt = '+ FloatToStr(rateamt)+
                          ',discamt = '+ FloatToStr(discamt)+
                          ',discpct = '+ IntToStr(disc)+
                          ',qty = ' + IntToStr(qty) +
                          ',svchgamt = ' + FloatToStr(svchg) +
                          ',taxamt = ' + FloatToStr(tax) +
                          ',rvncoa = ' + QuotedStr(coarvn) +
                          ',svchgcoa = ' + QuotedStr(coasvchg) +
                          ',taxcoa = ' + QuotedStr(coatax) +
                          ' where pscd='+QuotedStr(outletcd)+
                          ' and trno='+QuotedStr(trno)+
                          ' and itemcd='+QuotedStr(itemcd) +
                          ' and seq='+IntToStr(seq);
    sqlcmd.ExecSQL();



   //trdescbillCR := item['itemdesc'] + '/'+ FloatToStr(qty);
   trdesc := item['itemdesc'] + '/'+ FloatToStr(qty);

   SQLExec('delete from iafjrngl where seq='+IntToStr(seq));


     //if FromGuestBill = True then
      //UpdateIA(seq,RelaxDate(getFOPrd),trno,trno,outletcd,coarvn,coasvchg,coatax,rsvno,subtrno,trdescbill,trdescbillCR,amt,svchg,tax,True,dm.UserID)
     //else
   UpdateIA(seq,RelaxDate(getFOPrd),trno,trno,outletcd,coarvn,coasvchg,coatax,'','',trdesc,trdesc,trdesc,amt,svchg,tax,False,dm.UserID);

  finally
    item.Free;
    sqlcmd.Free;
  end;

end;

function checkIfMemberCO(sGrpCd: String) : Boolean;
var i : Integer;
begin
  i := GetData('select count(rsvno) as crsvno from fofrsv where rsvtp = ''2'' and grpcd='+QuotedStr(sGrpCd)+ ' and rsvst = ''R''','crsvno');
  if i > 0  then
    Result := False
  else
    Result := True;
end;

function checkIfGroupCI(sGrpCd: String) : Boolean;
var ci : String;
begin
  ci := GetData('select rsvst from fofrsv where grpcd='+QuotedStr(sGrpCd),'rsvst');
  if ci = 'R' then
    Result := True
  else
    Result := False;
end;



procedure updateGroupPU(sGrpCd,sRoomTp,sRsvno: String);
var dt : TSimpleDataSet;
    currDt,tArrdt,tDepdt : TTimeStamp;
    t : Integer;
    cmd,rsvst : String;
begin
  dt := TSimpleDataSet.Create(nil);
  dt.Connection := dm.mySQL1;
  dt.DataSet.CommandText := 'select rsvno,rsvst,arrdt,depdt from fofrsv where rsvtp=''5'' and grpcd='+QuotedStr(sGrpCd);
  dt.Open;

  tArrdt := DateTimeToTimeStamp(dt['arrdt']);
  tDepdt := DateTimeToTimeStamp(dt['depdt']);

  rsvst := dt['rsvst'];

  dt.Close;

  for t := tArrdt.Date to tDepdt.Date do begin
    currDt.Date := t;
    if dt.Active then dt.Close;
    dt.DataSet.CommandText := 'select count(rsvno) as cnt from fofrsv' +
                              ' where grpcd='+QuotedStr(sGrpCd)+
                              ' and rsvtp=''2''' +
                              ' and roomtpcd='+QuotedStr(sRoomTp)+
                              ' and rsvst in (''R'',''D'')' +
                              ' and arrdt <= '+RelaxDate(TimeStampToDateTime(currDt)) + ' and depdt > '+RelaxDate(TimeStampToDateTime(currDt));
    dt.Open;

    if True then

    if rsvst = 'R' then
      cmd := 'update fofgrpblc set qtypu='+IntToStr(dt['cnt'])+ ',qtyblc='+IntToStr(dt['cnt'])+ ' where rsvno='+QuotedStr(sRsvno)+' and grpcd='+QuotedStr(sGrpCd)+' and trdt='+RelaxDate(TimeStampToDateTime(currDt))+' and roomtpcd='+QuotedStr(sRoomTp)
    else if (rsvst = 'D') or (rsvst='T') then
      cmd := 'update fofgrpblc set qtypu='+IntToStr(dt['cnt'])+ ' where rsvno='+QuotedStr(sRsvno)+' and grpcd='+QuotedStr(sGrpCd)+' and trdt='+RelaxDate(TimeStampToDateTime(currDt))+' and roomtpcd='+QuotedStr(sRoomTp);
    SQLExec(cmd);

  end;

end;

procedure recalcGroupPU(grpRsvNo,grpCd: String);
var grpMember: TSimpleDataSet;
begin
  //
  grpMember := TSimpleDataSet.Create(nil);
    try
      grpMember.Connection := dm.mySQL1;
      grpMember.DataSet.CommandText := 'select distinct roomtpcd from fofrsv where rsvtp=''2'' and rsvst in (''R'',''D'') and grpcd='+QuotedStr(grpCd);
      grpMember.Open;
      grpMember.First;

      while not grpMember.Eof do begin
        updateGroupPU(grpCd,grpMember['roomtpcd'],grpRsvNo);
        grpMember.Next;
      end;

    finally
      grpMember.Free;
    end;

end;

procedure calc_ARRmn(trno,currcd: String);
var frmn,lrmn,amt,adjplus,adjmin,allc,trans : Double;
    cmd : String;
begin

  amt     := GetData('select ftramt from glftrhd where trno = ' + QuotedStr(trno),'ftramt');
  adjplus := GetData('select sum(ftramt) as adjplus from glftrhd where trtpcd = ''3020'' and subtrno = ' + QuotedStr(trno),'adjplus');
  adjmin  := GetData('select sum(ftramt) as adjmin from glftrhd where trtpcd = ''3030'' and subtrno = ' + QuotedStr(trno),'adjmin');
  allc    := GetData('select sum(ftramt) as allc from glftrhd where trtpcd = ''9994'' and subtrno = ' + QuotedStr(trno),'allc');
  trans   := GetData('select sum(ftramt) as trans from glftrhd where trtpcd = ''3040'' and subtrno = ' + QuotedStr(trno),'trans');

  frmn := amt + adjplus - adjmin - allc - trans;
  lrmn := GetLocalAmt(frmn,currcd);

  cmd := 'update glftrhd set ftramtrmn = ' + FloatToStr(frmn) + ',' + 'ltramtrmn = ' + FloatToStr(lrmn) + ' where trno = ' + QuotedStr(trno);

  SQLExec(cmd);

end;

procedure calc_APRmn(trno,currcd: String);
var frmn,lrmn,amt,adjplus,adjmin,allc,trans : Double;
    cmd : String;
begin

  amt     := GetData('select ftramt from glftrhd where trno = ' + QuotedStr(trno),'ftramt');
  adjplus := GetData('select sum(ftramt) as adjplus from glftrhd where trtpcd = ''2020'' and subtrno = ' + QuotedStr(trno),'adjplus');
  adjmin  := GetData('select sum(ftramt) as adjmin from glftrhd where trtpcd = ''2030'' and subtrno = ' + QuotedStr(trno),'adjmin');
  allc    := GetData('select sum(ftramt) as allc from glftrhd where trtpcd = ''9992'' and subtrno = ' + QuotedStr(trno),'allc');
  trans   := GetData('select sum(ftramt) as trans from glftrhd where trtpcd = ''2040'' and subtrno = ' + QuotedStr(trno),'trans');

  frmn := amt + adjplus - adjmin - allc - trans;
  lrmn := GetLocalAmt(frmn,currcd);

  cmd := 'update glftrhd set ftramtrmn = ' + FloatToStr(frmn) + ',' + 'ltramtrmn = ' + FloatToStr(lrmn) + ' where trno = ' + QuotedStr(trno);

  SQLExec(cmd);

end;

procedure updateTrialBalance(fromPrd,toPrd,fromCoa,toCoa: String);
var coa,dt,summaryTB : TSimpleDataSet;
    beg,ending,db,cr : Double;
    nowprd,priorprd,cmd : String;
    i : integer;
    masih : Boolean;
    DBorCR : String;
    strcmd : String;
begin

  strcmd := 'delete from trialbalance where prd between ' + QuotedStr(fromPrd) + ' and ' + QuotedStr(toPrd) + ' and coacd between ' + QuotedStr(fromCoa) + ' and ' + QuotedStr(toCoa);
  SQLExec(strcmd);

  coa := TSimpleDataSet.Create(nil);
  dt  := TSimpleDataSet.Create(nil);
  summaryTB := TSimpleDataSet.Create(nil);
  try
    coa.Connection := dm.mySQL1;
    dt.Connection := dm.mySQL1;
    summaryTB.Connection := dm.mySQL1;

    if coa.Active then coa.Close;
    coa.DataSet.CommandText := 'select coadtcd from gncoadt where coadtcd between ' + QuotedStr(fromCoa) + ' and ' + QuotedStr(toCoa) + '  order by coadtcd';
    coa.Open;
    i := coa.RecordCount;
    coa.First;

    while not coa.Eof do begin
      masih := True;
      nowprd := fromPrd;
      while masih do begin
        priorprd := GetPriorPrd(nowprd);
        if dt.Active then dt.Close;

        summaryTB.Close;
        summaryTB.DataSet.CommandText := 'select Prd,coacd' +
                                   ', ifnull(begcoa,0) as begcoa,ifnull(endcoa,0) as endcoa' +
                                   ' from glfcoabal' +
                                   ' where prd = ' + QuotedStr(nowprd) +
                                   ' and coacd = ' + QuotedStr(coa['coadtcd']) +
                                   ' group by  coacd,prd' +
                                   ' order by coacd,prd';
        summaryTB.Open;

        //dt.DataSet.CommandText := 'select trno,trdt,ifnull(fdbamt,0) as fdbamt,ifnull(fcramt,0) as fcramt,id from glftrdt where trcoa = '+QuotedStr(coa['coadtcd']) +' and active = 1 and extract(year_month from trdt) = '+QuotedStr(nowprd) + ' order by id';
        dt.DataSet.CommandText := 'select trno,trdt,ifnull(fdbamt,0) as fdbamt,ifnull(fcramt,0) as fcramt,id from glftrdt where trcoa = '+QuotedStr(coa['coadtcd']) +' and active = 1 and extract(year_month from trdt) = '+QuotedStr(nowprd) + ' order by trdt,trno,trcoa,id';
        dt.Open;

        //if nowprd = toPrd then masih := False;
        //nowprd := GetNextPrd(nowprd);

        dt.First;
          //beg := GetData('select endcoa from glfcoabal where coacd='+QuotedStr(coa['coadtcd']) + ' and prd = ' + QuotedStr(priorprd),'endcoa');

        if summaryTB.RecordCount = 0 then
          beg := 0
        else
        beg := summaryTB['begcoa'];

          while not dt.Eof do begin
            if (dt['fdbamt']) = null then
              db := 0
            else
              db := dt['fdbamt'];

            if (dt['fdbamt']) = null then
              cr := 0
            else
              cr := dt['fcramt'];

            DBorCR := GetData('select dccd from gncoa where coacd='+QuotedStr(coa['coadtcd']),'dccd');
            if DBorCR = 'D' then
              ending := beg + db - cr
            else
              ending := beg + cr - db;

            //cmd := 'insert into trialbalance values('+QuotedStr(dt['trno'])+','+QuotedStr(coa['coadtcd'])+','+ QuotedStr(nowprd) + ','  + RelaxDate(dt['trdt']) + ',' + FloatToStr(beg) + ',' + FloatToStr(dt['fdbamt']) + ',' + FloatToStr(dt['fcramt']) + ',' + FloatToStr(ending) + ',' + IntToStr(dt['id'])  +')';
            cmd := 'insert into trialbalance values('+QuotedStr(dt['trno'])+','+QuotedStr(coa['coadtcd'])+','+ QuotedStr(nowprd) + ','  + RelaxDate(dt['trdt']) + ',' + FloatToStr(beg) + ',' + FloatToStr(dt['fdbamt']) + ',' + FloatToStr(dt['fcramt']) + ',' + FloatToStr(ending) + ',' + IntToStr(dt['id'])  +',1)';
            SQLExec(cmd);
            beg := ending;
            dt.Next;
          end;

        if nowprd = toPrd then masih := False;
        nowprd := GetNextPrd(nowprd);

      end;

      coa.Next;

    end;








{
      if dt.Active then dt.Close;
      dt.DataSet.CommandText := 'select trno,trdt,ifnull(fdbamt,0) as fdbamt,ifnull(fcramt,0) as fcramt,id from glftrdt where trcoa = '+QuotedStr(coa['coadtcd']) +' and active = 1 and extract(year_month from trdt) between ' + QuotedStr(fromPrd) + ' and ' + QuotedStr(toPrd) + ' order by id';
      dt.Open;
      if dt.RecordCount > 0 then begin
        dt.First;
        nowprd := FormatDateTime('yyyymm',dt['trdt']);
        priorprd := GetPriorPrd(nowprd);
        //beg := GetData('select endcoa from glfcoabal where coacd='+QuotedStr(coa['coadtcd']) + ' and prd = ' + QuotedStr(priorprd),'endcoa');
        while not dt.Eof do begin
          db := dt['fdbamt'];
          cr := dt['fcramt'];
          ending := beg + db - cr;
          cmd := 'insert into trialbalance values('+QuotedStr(dt['trno'])+','+QuotedStr(coa['coadtcd'])+','+ QuotedStr(nowprd) + ','  + RelaxDate(dt['trdt']) + ',' + FloatToStr(beg) + ',' + FloatToStr(dt['fdbamt']) + ',' + FloatToStr(dt['fcramt']) + ',' + FloatToStr(ending) + ',' + IntToStr(dt['id'])  +')';
          SQLExec(cmd);
          beg := ending;
          dt.Next;
        end;
      end;
      coa.Next;
    end;

}

  finally
    coa.Free;
    dt.Free;
    summaryTB.Free;
  end;

end;

procedure CalcTrialBal(sPrd,sCoaCd: String);
var dt,dt2 : TSimpleDataSet;
    begcoa,endcoa,mact,yact : Double;
    DBorCR,cmd,yactstr : String;
    mbudstr,ybudstr : String;
    mbud,ybud: Double;
begin
  //
  dt  := TSimpleDataSet.Create(nil);
  dt2 := TSimpleDataSet.Create(nil);
  try
    dt.Connection := dm.mySQL1;
    dt2.Connection := dm.mySQL1;
    dt.DataSet.CommandText := 'select coacd,prd,dbcoa,crcoa from glfcoabal where coacd='+QuotedStr(sCoaCd)+' and prd='+QuotedStr(sPrd);
    dt.Open;

    dt2.DataSet.CommandText := 'select endcoa from glfcoabal where coacd='+QuotedStr(sCoaCd) + ' and prd='+QuotedStr(GetPriorPrd(sPrd));
    dt2.Open;

    if dt2.RecordCount = 0 then
      begcoa := 0
    else
      begcoa := dt2['endcoa'];

    DBorCR := GetData('select dccd from gncoa where coacd='+QuotedStr(sCoaCd),'dccd');
    if DBorCR = 'D' then begin
      endcoa  := begcoa + dt['dbcoa'] - dt['crcoa'];
      mact    := dt['dbcoa'] - dt['crcoa'];
      yactstr := 'select sum(dbcoa)-sum(crcoa) as yact from glfcoabal where prd between ' + QuotedStr(Copy(sPrd,1,4)+'01') + ' and '+ QuotedStr(sPrd)  + ' and coacd ='+QuotedStr(sCoaCd);
      yact    := GetDataFloat(yactstr,'yact');
    end
    else if DBorCR = 'C' then begin
      endcoa := begcoa + dt['crcoa'] - dt['dbcoa'];
      mact   := dt['crcoa'] - dt['dbcoa'];
      yactstr := 'select sum(crcoa)-sum(dbcoa) as yact from glfcoabal where prd between ' + QuotedStr(Copy(sPrd,1,4)+'01') + ' and '+ QuotedStr(sPrd)  + ' and coacd ='+QuotedStr(sCoaCd);
      yact    := GetDataFloat(yactstr,'yact');
    end;

    mbudstr := 'select ifnull(amount,0) as amount from gnbudget where prd='+QuotedStr(sPrd)+' and account='+QuotedStr(sCoaCd);
    mbud := GetDataFloat(mbudstr,'amount');
    ybudstr := 'select ifnull(sum(amount),0) as sumamount from gnbudget where prd between ' + QuotedStr(Copy(sPrd,1,4)+'01') + ' and ' + QuotedStr(sPrd) + ' and account ='+QuotedStr(sCoaCd);
    ybud := GetDataFloat(ybudstr,'sumamount');

    cmd := 'update glfcoabal set begcoa = ' + FloatToStr(begcoa)+',endcoa='+FloatToStr(endcoa)+
           ',mact='+FloatToStr(mact)+',yact='+FloatToStr(yact)+
           ',mbud='+FloatToStr(mbud)+',ybud='+FloatToStr(ybud)+
           ' where coacd='+QuotedStr(sCoaCd) + ' and prd='+QuotedStr(sPrd);

    SQLExecEx(cmd);

  finally
    dt.Free;
    dt2.Free;
  end;
end;

procedure sumTrialBal(sCoa,sPrd: String);
var str: String;
    dt : TSimpleDataSet;
    sumdb,sumcr : Double;
begin
  //
  dt := TSimpleDataSet.Create(nil);
  dt.Connection := dm.mySQL1;
  try
    str := 'select sum(fdbamt) as sum_fdbamt,sum(fcramt) as sum_fcramt from glftrdt' +
           ' where trcoa = ' + QuotedStr(sCoa) +
           ' and extract(year_month from trdt)= ' + QuotedStr(sPrd)+
           ' and active = 1';
    dt.DataSet.CommandText := str;
    dt.Open;
    if dt.RecordCount > 0 then begin
      sumdb := dt['sum_fdbamt'];
      sumcr := dt['sum_fcramt']
    end
    else begin
      sumdb := 0;
      sumcr := 0;
    end;

    str := 'update glfcoabal set dbcoa='+FloatToStr(sumdb)+',crcoa='+FloatToStr(sumcr)+
           ' where coacd='+QuotedStr(sCoa) + ' and prd='+QuotedStr(sPrd);

    SQLExec(str);

    dt.Close;

  finally
    dt.Free;
  end;

end;

function setMinimumNightGen(xrsvno,rmtpcd: String; arrdt,depdt: TDate) : String;
var str : String;
    minNight : Integer;
begin
  str := 'select min(qtyblc-qtypu) as minpu from fofgrpblc' +
         ' where rsvno = '+ QuotedStr(xrsvno) +
         ' and roomtpcd = ' + QuotedStr(rmtpcd) +
         ' and trdt between ' + RelaxDate(arrdt) + ' and ' + RelaxDate(depdt) +
         ' and qtyblc <> 0';

  minNight :=GetData(str,'minpu');
  Result := IntToStr(minNight);

end;

procedure copyGroupRate(sGrpCd,sRsvNo,sRoomType: String;allMember: Boolean);
var tarrdt,tdepdt,currentdt : TTimeStamp;
    arrdt,depdt : TDate;
    dt : TSimpleDataSet;
    d : Integer;
    grpRsvNo : String;
    cmd,strcmd : String;
begin
  //

  grpRsvno := GetData('select rsvno from fofrsv where rsvtp=''5'' and grpcd='+QuotedStr(sGrpCd),'rsvno');

  if allMember=True then begin
    arrdt := GetData('select arrdt from fofrsv where rsvno='+QuotedStr(grpRsvNo),'arrdt');
    depdt := GetData('select depdt from fofrsv where rsvno='+QuotedStr(grpRsvNo),'depdt');
    cmd := 'select rsvno from fofrsv where rsvtp = ''2'' and grpcd = ' + QuotedStr(sGrpCd);
  end
  else if allMember=False then begin
    arrdt := GetData('select arrdt from fofrsv where rsvno='+QuotedStr(sRsvNo),'arrdt');
    depdt := GetData('select depdt from fofrsv where rsvno='+QuotedStr(sRsvNo),'depdt');
    cmd := 'select rsvno from fofrsv where rsvno = '+QuotedStr(sRsvNo);
  end;


  tarrdt := DateTimeToTimeStamp(arrdt);
  tdepdt := DateTimeToTimeStamp(depdt);

  dt := TSimpleDataSet.Create(nil);
  dt.Connection := dm.mySQL1;
  dt.DataSet.CommandText := cmd;
  dt.Open;
  if dt.RecordCount = 0  then Exit;

  dt.First;

  while not dt.Eof do begin
      //copy rate
    for d := tarrdt.Date to tdepdt.Date do begin
      currentdt.Date := d;
      strcmd := 'delete from fofrate_temp';
      SQLExec(strcmd);
      strcmd := 'insert into fofrate_temp select * from fofrate where rsvno='+QuotedStr(grpRsvNo) + ' and roomtpcd='+QuotedStr(sRoomType) + ' and trdt='+RelaxDate(TimeStampToDateTime(currentdt));
      SQLExec(strcmd);
      strcmd := 'update fofrate_temp set rsvno = ' + QuotedStr(dt['rsvno'])+' where rsvno='+QuotedStr(grpRsvNo);
      SQLExec(strcmd);
      strcmd := 'delete from fofrate where rsvno = ' + QuotedStr(dt['rsvno']) + ' and trdt = ' + RelaxDate(TimeStampToDateTime(currentdt));
      SQLExec(strcmd);
      strcmd := 'insert into fofrate select * from fofrate_temp';
      SQLExec(strcmd);
      strcmd  := 'delete from fofrate_temp';
      SQLExec(strcmd);
    end;
    dt.Next;

  end;


end;


procedure reinsertTrialBal(var nRecCount,nRec : Integer);
var dt,dt2 : TSimpleDataSet;
    lastprd,currprd : String;
    str : String;
    DBorCR: String;
    strdbcr : String;
    trcoa : String;
    begcoa,db,cr,endcoa : Double;
begin
  //reinsert glfcoabal

  lastprd := GetData('select BoGlPrd from gnsystem','BoGlPrd');
  currprd := FormatDateTime('yyyymm',Date);

  SQLExec('delete from glfcoabal where prd between ' + QuotedStr(lastprd) + ' and ' + QuotedStr(currprd));

  dt2 := TSimpleDataSet.Create(nil);
  dt2.Connection := dm.mySQL1;


  dt := TSimpleDataSet.Create(nil);
  dt.Connection := dm.mySQL1;
  dt.DataSet.CommandText := 'select coadtcd,coadtai from gncoadt where coadtai = ''A'' order by coadtcd';
  dt.Open;
  dt.First;

  while not dt.Eof do begin

    lastprd := GetData('select BoGlPrd from gnsystem','BoGlPrd');
    currprd := FormatDateTime('yyyymm',Date);


    DBorCR := GetData('select dccd from gncoa where coacd='+QuotedStr(dt['coadtcd']),'dccd');
    if DBorCR = 'D' then
      strdbcr := '0+sum(ldbamt)-sum(lcramt)'
    else
      strdbcr := '0+sum(lcramt)-sum(ldbamt)';


    while lastprd <> currprd do begin

      if dt2.Active then dt2.Close;

      dt2.DataSet.CommandText := ' select trcoa, ' + QuotedStr(lastprd) + ' as prd,' +
                                 ' 0 as BegCoa,' +
                                 ' ifnull(sum(ldbamt),0) as debit,' +
                                 ' ifnull(sum(lcramt),0) as credit,' +
                                 ' ' + strdbcr + ' as endcoa' +
                                 ' from glftrdt' +
                                 ' where extract(year_month from trdt) = ' + QuotedStr(lastprd) +
                                 ' and trcoa = ' + QuotedStr(dt['coadtcd']) +
                                 ' and active = 1' +
                                 ' group by trcoa,prd';
      dt2.Open;

      if dt2.RecordCount > 0 then begin
        trcoa := dt2['trcoa'];
        db := dt2['debit'];
        cr := dt2['credit'];
        endcoa := dt2['endcoa'];
      end
      else begin
        trcoa := dt['coadtcd'];
        db := 0;
        cr := 0;
        endcoa := 0;
      end;


      str := 'insert into glfcoabal (coacd,prd,begcoa,dbcoa,crcoa,endcoa)' +
             ' values (' + QuotedStr(trcoa) +
             ',' + QuotedStr(lastprd) +
             ',0' +
             ',' + FloatToStr(db) +
             ',' + FloatToStr(cr) +
             ',' + FloatToStr(endcoa)+
             ')';
{             ' select trcoa, ' + QuotedStr(lastprd) + ' as prd,' +
             ' 0 as BegCoa,' +
             ' ifnull(sum(ldbamt),0) as debit,' +
             ' ifnull(sum(lcramt),0) as credit,' +
             ' ' + strdbcr + ' as endcoa' +
             ' from glftrdt' +
             ' where extract(year_month from trdt) = ' + QuotedStr(lastprd) +
             ' and trcoa = ' + QuotedStr(dt['coadtcd']) +
             ' and active = 1' +
             ' group by trcoa,prd';}
      SQLExec(str);

      lastprd := GetNextPrd(lastprd);

    end;

    dt.Next;
  end;

  dt.Close;

  dt.DataSet.CommandText := 'select * from glfcoabal order by coacd,prd';
  dt.Open;
  dt.First;

  while not dt.Eof do begin
    CalcTrialBal(dt['prd'],dt['coacd']);
    dt.Next;
  end;



end;

procedure reinsertTrialBalEx(fromdt,todt: TDate);
var dt : TSimpleDataSet;
    lastprd,currprd : String;
    str : String;
    DBorCR: String;
    strdbcr : String;

begin
  //
  //reinsert glfcoabal
  SQLExec('delete from glfcoabal');

  dt := TSimpleDataSet.Create(nil);
  dt.Connection := dm.mySQL1;
  dt.DataSet.CommandText := 'select coacd,coadtai from gncoadt where coadtai = ''A'' order by coacd';
  dt.Open;
  dt.First;

  while not dt.Eof do begin

    lastprd := FormatDateTime('yyyymm',fromdt);
    currprd := FormatDateTime('yyyymm',todt);

    DBorCR := GetData('select dccd from gncoa where coacd='+QuotedStr(dt['coacd']),'dccd');
    if DBorCR = 'D' then
      strdbcr := '0+sum(ldbamt)-sum(lcramt)'
    else
      strdbcr := '0+sum(lcramt)-sum(ldbamt)';


    while lastprd <= currprd do begin

      str := 'insert into glfcoabal (coacd,prd,begcoa,dbcoa,crcoa,endcoa)' +
             ' select trcoa, ' + QuotedStr(lastprd) + ' as prd,' +
             ' 0 as BegCoa,' +
             ' ifnull(sum(ldbamt),0) as debit,' +
             ' ifnull(sum(lcramt),0) as credit,' +
             ' ' + strdbcr + ' as endcoa' +
             ' from glftrdt' +
             ' where trdt between ' + RelaxDate(fromdt) + ' and ' + RelaxDate(todt) +
             ' and trcoa = ' + QuotedStr(dt['coacd']) +
             ' and active = 1' +
             ' group by trcoa,prd';
      SQLExec(str);

      lastprd := GetNextPrd(lastprd);

    end;

    dt.Next;
  end;

  dt.Close;

  dt.DataSet.CommandText := 'select * from glfcoabal';
  dt.Open;
  dt.First;

  while not dt.Eof do begin
    CalcTrialBal(dt['prd'],dt['coacd']);
    dt.Next;
  end;


end;

function checkRoomBlock(arrdt,depdt : TDate;roomno,modRsvno: String;var rsvno: String) : Integer;
var cmd: String;
    res : Variant;
    num : Integer;
begin
  cmd := ' select roomno from fosroom where roomno in' +
         ' (select roomno from fofrsv' +
         ' where roomno = ' + QuotedStr(roomno) +
         //' and arrdt <= ' + RelaxDate(depdt) + ' and depdt > ' + RelaxDate(arrdt)+
         ' and arrdt < ' + RelaxDate(depdt) + ' and depdt > ' + RelaxDate(arrdt)+
         ' and rsvno <> ' + QuotedStr(modRsvno) +
         ')';
  GetData3(cmd,'roomno',res,num);
  rsvno := res;
  Result := num;
end;

function SQLExecEx(querystr: String) : Integer;
var data : TSQLQuery;
    sukses : Integer;
begin
  data := TSQLQuery.Create(nil);
  try
    data.SQLConnection := dm.mySQL1;
    data.SQL.Text := querystr;
    sukses := data.ExecSQL();
    Result := sukses;
  finally    data.Free;
  end;
  //
end;

procedure recalcDP(trnodp: String);
var strcmd: String;
    res: Integer;
begin
  strcmd := 'update iafdphd set rmnamt=totamt-(select sum(totamt) from iafdpallc where trnodp=iafdphd.TrNo)' +
              ' where iafdphd.trno='+QuotedStr(trnodp);
  res:= SQLExecEx(strcmd);
end;

procedure calcLedger(trno: String;trdt: TDate);
var glftrdt: TSimpleDataSet;
    fmprd,toprd,lastprd,currprd: String;
begin
  glftrdt := TSimpleDataSet.Create(nil);
  try
    glftrdt.Connection := dm.mySQL1;
    glftrdt.DataSet.CommandText := 'select distinct trdt,trcoa from glftrdt where trno = ' +QuotedStr(trno)+ ' order by trcoa';
    glftrdt.Open;
    glftrdt.First;

    while not glftrdt.Eof do begin
        fmprd := FormatDateTime('yyyymm',trdt);
        toprd := FormatDateTime('yyyymm',Date);
        lastprd := fmprd;
        currprd := toprd;
        while lastprd <= currprd do begin
          sumTrialBal(glftrdt['trcoa'],fmprd);
          CalcTrialBal(lastprd,glftrdt['trcoa']);
          lastprd := GetNextPrd(lastprd);
        end;
        //updateTrialBalance(fmprd,toprd,glftrdt['trcoa'],glftrdt['trcoa']);
        glftrdt.Next;
    end;
  finally
    glftrdt.Free;
  end;

end;

procedure SaveRate(sRsvNo: String;FITRateChanged,KeepRate: Boolean);
var cmd,cmd2,cmd3 : TSQLQuery;
    fofrate,tbRsv: TSimpleDataSet;
    adultno,childno,maxpax,RateActive,I,pctsvchg,pcttax: Integer;
    arrdt,depdt,ratetodt,current: TTimeStamp;
    adultamt,childamt,totamt : Currency;
    pscdrm,servicecd,seqno,nextseqno,pscdrate,fieldnm : String;
begin
  cmd := TSQLQuery.Create(nil);
  cmd.SQLConnection := dm.mySQL1;
  cmd2 := TSQLQuery.Create(nil);
  cmd2.SQLConnection := dm.mySQL1;
  cmd3 := TSQLQuery.Create(nil);
  cmd3.SQLConnection := dm.mySQL1;

  tbRsv := TSimpleDataSet.Create(nil);
  tbRsv.Connection := dm.mySQL1;
  tbRsv.DataSet.CommandText := 'select * from fofrsv where rsvno='+QuotedStr(sRsvNo);
  tbRsv.Open;

  fofrate := TSimpleDataSet.Create(nil);
  fofrate.Connection := dm.mySQL1;
  fofrate.DataSet.CommandText := 'select * from fofrate where rsvno = ' + QuotedStr(tbRsv['rsvno']);
  fofrate.Open;

  try


  //if tbRsvratecd.Value <> RateCd then begin

    //ambil code pos untuk Room
    cmd.CommandText := 'select PsCdRm from iassystem';
    cmd.Open;

    pscdrm := cmd['PsCdRm'];
    cmd.Close;

    //ambil jumlah adult & child
    //cmd.CommandText := 'select adult,child from fofrsv where rsvno='+QuotedStr(tbRsvrsvno.Value);
    //cmd.Open;
    adultno :=  tbRsv['adult'];
    childno :=  tbRsv['child'];
    cmd.Close;

    //ambil nilai 'max pax' dari fosratedt1
    cmd.CommandText := 'select seqno,ifnull(max,0) as maks,todt,nextseq from fosratedt1 where active=1' +
                       ' and ratecd='+QuotedStr(tbRsv['ratecd']) +
                       ' and fromdt < ' + RelaxDate(tbRsv['arrdt']) +
                       ' and todt > ' + RelaxDate(tbRsv['depdt']) +
                       ' and roomtpcd ='+QuotedStr(tbRsv['roomtpcd']);
    cmd.Open;

    if cmd.RecordCount = 1 then begin
      maxpax :=  cmd['maks'];
      ratetodt := DateTimeToTimeStamp(cmd.FieldByName('todt').AsDateTime);
      seqno    := cmd['seqno'];
      nextseqno := cmd['nextseq'];
      cmd.Close;
    end;

    //looping thru dates
    //updating rate

    if (tbRsv['rsvst']='C') or (tbRsv['rsvst']='N') or (tbRsv['rsvst']='W') or (tbRsv['rsvst']='I') then
      RateActive := 0
    else
      RateActive := 1;

    arrdt := DateTimeToTimeStamp(tbRsv['arrdt']);
    depdt := DateTimeToTimeStamp(tbRsv['depdt']);

    //delete rate kecuali yg diubah manual
    cmd.Close;

    if FITRateChanged = True then begin

      if KeepRate=True then begin
        cmd.CommandText := 'update fofrate set roomtpcd='+QuotedStr(tbRsv['roomtpcd']) + ' where rsvno = ' + QuotedStr(tbRsv['rsvno']);
        cmd.ExecSQL();
        Exit;
      end
      else
        cmd.CommandText := 'delete from fofrate where rsvno = ' + QuotedStr(tbRsv['rsvno']);

    end

    else begin
      cmd.CommandText := 'delete from fofrate where rsvno = ' + QuotedStr(tbRsv['rsvno']) + ' and changedrate = 0'
    end;


    cmd.ExecSQL();

    //if (tbRsvrsvtp.Value = '3') or (tbRsvcomplfl.Value = '1') then Exit;

    for I := arrdt.Date to depdt.Date  do begin
      cmd.Close;
      current.Date := I;

      cmd.CommandText := 'select Adult,AddAdult,Child,ServiceCd,outletcd,ratecd from fosratedt2 where active=1' +
                         ' and ratecd='+QuotedStr(tbRsv['ratecd']) +
                         ' and day=' +   IntToStr(DayOfWeek(current.Date));

      if depdt.Date >  ratetodt.Date then
        cmd.CommandText := cmd.CommandText + ' and seqno =' + QuotedStr(nextseqno)
      else
        cmd.CommandText := cmd.CommandText + ' and seqno =' + QuotedStr(seqno);


      cmd.Open;

      cmd.First;
      while not cmd.Eof do begin
      //RelaxDate(TimeStampToDateTime(current));


        if adultno <= maxpax then
          adultamt := cmd['Adult']
        else
          adultamt := cmd['Adult'] + ((adultno-maxpax) * cmd['AddAdult']);

        childamt := cmd['Child'] * childno;
        totamt := adultamt + childamt;
        servicecd := cmd['ServiceCd'];
        pscdrate := cmd['outletcd'];

        //BIAR GAK DOUBLE DI fofrate
        if fofrate.Locate('trdt;rsvno;pscd;psitem',VarArrayOf([current.Date,tbRsv['rsvno'],pscdrate,servicecd]),[]) then Exit;


        //ambil persent svchg & tax
        cmd2.Close;
        cmd2.CommandText := 'select ifnull(pctsvchg,0) as pctsvchg,ifnull(pcttax,0) as pcttax from psspsitem where pscd = '+QuotedStr(pscdrate) + ' and itemcd = ' + QuotedStr(servicecd);
        cmd2.Open;
        if cmd2.RecordCount > 0 then begin
          pctsvchg := cmd2['pctsvchg'];
          pcttax   := cmd2['pcttax'];
        end;

        cmd2.Close;
        cmd2.CommandText := 'select * from fofrate where' +
                            ' trdt='+ RelaxDate(TimeStampToDateTime(current)) +
                            ' and rsvno='+QuotedStr(tbRsv['rsvno']) +
                            ' and pscd='+QuotedStr(pscdrate)+
                            ' and psitem='+QuotedStr(servicecd) +
                            ' and changedrate=1';
        cmd2.Open;

        if cmd2.RecordCount = 0 then begin
          if (tbRsv['rsvtp'] = '3') or (tbRsv['complfl'] = '1') then begin
            cmd3.CommandText := 'insert into fofrate values(' +
                              RelaxDate(TimeStampToDateTime(current)) +
                             ',' + QuotedStr(tbRsv['rsvno']) +
                             ',' + QuotedStr(tbRsv['roomtpcd']) +
                             ',' + QuotedStr(pscdrate) +
                             ',' + QuotedStr(servicecd) +
                             ',' + QuotedStr(getCurrCd) +
                             ',' + FloatToStr(1) +
                             ',' + FloatToStr(1) +
                             ',' + FloatToStr(0) +
                             ',' + FloatToStr(0) +
                             ',' + FloatToStr(0) +
                             ',' + FloatToStr(0) +
                             ',' + FloatToStr(0) +
                             ',' + QuotedStr('')+
                             ',' + QuotedStr('')+
                             ',' + QuotedStr(cmd['ratecd']) +
                             ',' + QuotedStr(seqno)+
                             ',1,0,1)';

            cmd3.ExecSQL();


          end else begin
            cmd2.Close;
            cmd2.CommandText := 'insert into fofrate values(' +
                                  RelaxDate(TimeStampToDateTime(current)) +
                               ',' + QuotedStr(tbRsv['rsvno']) +
                               ',' + QuotedStr(tbRsv['roomtpcd']) +
                               ',' + QuotedStr(pscdrate) +
                               ',' + QuotedStr(servicecd) +
                               ',' + QuotedStr(getcurrcd) +
                               ',' + FloatToStr(1) +
                               ',' + FloatToStr(1) +
                               ',' + FloatToStr(totamt+ totamt*(pctsvchg/100) + totamt*(pcttax/100)  ) +
                               ',' + FloatToStr(totamt) +
                               ',' + FloatToStr((totamt*(pctsvchg/100))) +
                               ',' + FloatToStr((totamt*(pcttax/100))) +
                               ',' + FloatToStr(totamt+ totamt*(pctsvchg/100) + totamt*(pcttax/100)  ) +
                               ',' + QuotedStr('')+
                               ',' + QuotedStr('')+
                               ',' + QuotedStr(cmd['ratecd']) +
                               ',' + QuotedStr(seqno)+
                               ',1,0,'+IntToStr(RateActive)+')';



            //ShowMessage(cmd.CommandText);
            cmd2.ExecSQL();
          end;
        end;
        cmd.Next;
      end;
    end;

  finally
    cmd.Free;
    cmd2.Free;
    cmd3.Free;
    tbRsv.Free;
    fofrate.Free;

  end;

end;

procedure recalcPODetail(sPOno: String);
var dt : TSimpleDataSet;
    sProdCd,str: String;
    nQtyRR: Double;
    res : Integer;
begin
  // Menghitung ulang detail PO setelah (mungkin) terjadi delete atau edit;
  dt := TSimpleDataSet.Create(Nil);
  try


  dt.Connection := dm.mySQL1;
  dt.DataSet.CommandText := 'select * from glftrdtpo where active =1 and trno='+QuotedStr(sPOno);
  dt.Open;
  dt.First;

  while not dt.Eof do begin
    sProdCd := dt['prodcd'];
    nQtyRR := GetDataFloat('select ifnull(sum(qty),0) as qtyrr from glftrdt where active=1 and docno='+QuotedStr(sPOno) + ' and prodcd='+QuotedStr(sProdCd),'qtyrr');
    str := 'update glftrdtpo set qtyrr='+FloatToStr(nQtyRR)+',qtyrmn=qty-'+FloatToStr(nQtyRR)+' where active=1 and trno='+QuotedStr(SPOno)+' and prodcd='+QuotedStr(sProdCd);
    res := SQLExecEx(str);
    dt.Next;
  end;

  finally
    dt.Close;
    dt.Free;
  end;

end;

procedure setMandatory(tbldataset: TSimpleDataSet;tblname: String);
var dt : TSimpleDataSet;
begin
  dt := TSimpleDataSet.Create(nil);
  try
    dt.Connection := dm.mySQL1;
    dt.DataSet.CommandText := 'select * from gnmandatory where tblnm='+QuotedStr(tblname);
    dt.Open;
    dt.First;
    while not dt.Eof do begin
      //tbldataset.FieldByName(dt['fldnm']).Required := dt.FieldByName('required').Value;
      tbldataset.FieldByName(dt['fldnm']).Required := True;
      dt.Next;
    end;

  finally
    dt.Free;
  end;
end;


function isCoaAllowed(sCoa:String): Boolean;
var str : String;
    res : Integer;
    lvl : Double;
begin
  //

  str := 'select level from gnuser where usercd='+QuotedStr(dm.UserID);
  lvl := GetDataFloat(str,'level');

  if lvl >= 99 then begin
    Result := True;
    Exit;
  end;

  str := 'select * from vprohibitedcoa where coacd<>'''' and coacd='+QuotedStr(sCoa);
  res := SQLExecEx(str);

  if res = 0 then
    Result := True
  else
    Result := False;

end;

function validateCOA(sCoa:String) : Boolean;
var coatp,coadtcd : String;
begin
  //
  Result := True;

  // validate jika coa kosong
  coadtcd := GetData('select coadtcd from gncoadt where coadtcd='+QuotedStr(sCoa),'coadtcd');
  if coadtcd = '' then begin
    MessageDlg('Account does not exists',mtWarning,[mbOK],0);
    Result := False;
  end;

  // validate jika coa Inactive
  coatp := GetData('select coadtai from gncoadt where coadtcd = ' + QuotedStr(sCoa),'coadtai');
  if coatp = 'I' then begin
    raise Exception.Create('This Account is inactive. Please select another one.');
    Result := False;
  end;

  // validate jika coa tidak boleh dipake
  if isCoaAllowed(sCoa) = False then begin
    raise Exception.Create('This Account can not be used for this transaction. Select another one.');
    Result := False;
  end;


end;


function getFOTime: String;
begin
  //
  Result := FormatDateTime('hh:mm:ss',Now);
end;

function GetDataStr(query,fieldnm : String) : String;
var data : TSimpleDataSet;
begin
  data := TSimpleDataSet.Create(nil);
  try
    data.Connection := dm.mySQL1;
    data.DataSet.CommandText := query;
    data.Open;
    if data.RecordCount > 0 then
      Result := data[fieldnm]
    else
      Result := '';
  finally
    data.Free;
  end;
end;



end.
