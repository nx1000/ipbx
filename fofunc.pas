unit fofunc;

interface

type
  TiafjrnHD = class
    //
    procedure saveHD;
    procedure deleteHD;
    public
      outlet,trno,trno1,subtrno,subtrno1,trdesc,trdesc2,roomno,pymtmthd,currcd:String;
      rsvno,subrsvno,user: String;
      currbs1,currbs2,ftotamt,totamt,frmnamt: Double;
      pax,active,slstp: Integer;
      trdt: TDateTime;
      trtm: String;
      cardcd,cardno,cardnm,compcd,disccd: String;
      cardexp: TDateTime;
      grpcd: String;
    published
      constructor Create;
  end;


  TiafjrnDT = class
    procedure saveDT;
    procedure deleteDT;
    function getitemseq : Integer;
    public
      active,seq,itemseq : Integer;
      trdt : TDateTime;
      pscd,trno,trno1,subtrno,itemcd,trdesc: String;
      usercrt,waitercd,cono: String;
      qty,discpct: Double;
    published
      constructor Create;
  end;

  Tcalcamt = class
    procedure CalcAmt;
    procedure CalcAmt2;
    public
      seq,active : Integer;
      outletcd,itemcd,itemdesc,trno,trno1: String;
      rsvno,subrsvno,trdesc,trdesccr,trdesc2: String;
      qty,disc,nslstp,openitem: Integer;
      price,pricenett:Double;
      nett,na,extbed: Boolean;
      manualprice:Boolean;
    published
      constructor Create;
  end;

  Tstarsys = class
    procedure updStarsys;
    public
      rm,nm,wk,cos,typ:String;
      flag: Integer;
    published
      constructor Create;
  end;


function isRsvDateChange(oldarrdt,olddepdt,newarrdt,newdepdt: TDateTime): Boolean;
function changeGroupBlock(sGrpcd:String;oldarrdt,newarrdt,olddepdt,newdepdt:TDateTime): Boolean;
procedure saveGL(tgl:TDateTime;seq:Integer;trno,trno1,subtrno1,pscd,coa:String;dbamt,cramt:Double;rsvno,subrsvno,trdesc,trdesc2,gltrno:String;id:Integer;usrcrt:String;active:Integer;docdt:TDateTime);
procedure deleteFODeposit(sPyNo:String);
function ConnectDB : Boolean;
procedure AddHolidayRate(sRatecd,sRoomTpCd,sRsvNo,sSeqno:String; dDate: TDateTime);
function getMaintenance(vDate: TDateTime): Integer;
function getroomhuact(vDate:TDateTime) : Currency;
function hitungExtraBed: Double;
function hitungAmtplusExtraBed(amtnett: Double): Double;
function hitungAmtplus(amtnett: Double;itemcd,pscd:String): Double;
function hitungAmtnett(amtplus: Double;itemcd,pscd:String): Double;
function getPengurang1(tp:Integer;amtplus:Double;item,outlet:String): Double;
function getPengurang2(tp:Integer;amtplus:Double;item,outlet:String): Double;
function getPriceNett(item,outlet:String): Double;
function getPricePlus(amtnett:Double;item,outlet:String): Double;

implementation

uses genfunc, dbfunc,SysUtils,SqlExpr, Unit2, SimpleDS, Dialogs;

function isRsvDateChange(oldarrdt,olddepdt,newarrdt,newdepdt: TDateTime): Boolean;
begin
  //cek apakah arrdt dan depdt berbeda
  if (oldarrdt <> newarrdt) or (olddepdt <> newdepdt) then
    Result := True
  else
    Result := False;
end;



function changeGroupBlock(sGrpcd:String;oldarrdt,newarrdt,olddepdt,newdepdt:TDateTime): Boolean;
var oldtgl,newtgl : TDateTime;
    str : String;
    res : Integer;
begin
  //geser tanggal group block

  if sGrpcd='' then Exit;

  str := 'update fofrsv set arrdt='+RelaxDate(newarrdt)+',depdt='+RelaxDate(newdepdt)+' where rsvst<>''O'' and grpcd='+QuotedStr(sGrpcd);
  res := SQLExecEx(str);

  str := 'insert into t_fofgrpblc select * from fofgrpblc where grpcd='+QuotedStr(sGrpcd);
  res := SQLExecEx(str);
  str := 'delete from fofgrpblc where grpcd='+QuotedStr(sGrpcd);
  res := SQLExecEx(str);

  newtgl := newarrdt;
  oldtgl := oldarrdt;
  while newtgl <= newdepdt do begin
    str := 'update t_fofgrpblc set trdt='+RelaxDate(newtgl)+' where trdt='+RelaxDate(oldarrdt);
    res := SQLExecEx(str);
    newtgl := newtgl + 1;
    oldtgl := oldtgl + 1;
  end;

  str := 'insert into fofgrpblc select * from t_fofgrpblc where grpcd='+QuotedStr(sGrpcd);
  res := SQLExecEx(str);
  str := 'delete from t_fofgrpblc';
  res := SQLExecEx(str);

  Result := True;
end;


procedure saveGL(tgl:TDateTime;seq:Integer;trno,trno1,subtrno1,pscd,coa:String;dbamt,cramt:Double;rsvno,subrsvno,trdesc,trdesc2,gltrno:String;id:Integer;usrcrt:String;active:Integer;docdt:TDateTime);
var str,saveTrno1: String;
    res: Integer;
begin

  if (coa=dm.GuestLedgerCOA) and (rsvno <>'') then
    saveTrno1 := ''
  else
    saveTrno1 := trno1;

  str := 'insert into iafjrngl values ('+
          RelaxDate(tgl)+
          ','+IntToStr(seq)+
          ','+QuotedStr(trno)+
          ','+QuotedStr(saveTrno1)+
          ','+QuotedStr(subtrno1)+
          ','+QuotedStr(pscd)+
          ','+QuotedStr(coa)+
          ','+FloatToStr(dbamt)+
          ','+FloatToStr(cramt)+
          ','+QuotedStr(rsvno)+
          ','+QuotedStr(subrsvno)+
          ','+QuotedStr(trdesc)+
          ','+QuotedStr(trdesc2)+
          ','+QuotedStr(gltrno)+
          ','+IntToStr(id)+
          ','+QuotedStr(usrcrt)+
          ','+IntToStr(active)+
          ','+RelaxDate(docdt)+
          ')';

  res := SQLExecEx(str);

end;

procedure TiafjrnHD.saveHD;
var str: String;
    res: Integer;
begin
  //
  str := 'insert into iafjrnhd (pscd,trdt,trno,trno1,subtrno1,trdesc,trdesc2,roomno,pymtmthd,currcd,currbs1,currbs2,ftotamt,totamt,frmnamt,active,rsvno,subrsvno,usrcrt,cardcd,cardno,cardnm,cardexp,grpcd,compcd,pax,slstp,trtm)' +
         ' values (' +
          QuotedStr(outlet)+
         ','+RelaxDate(trdt)+
         ','+QuotedStr(trno)+
         ','+QuotedStr(trno1)+
         ','+QuotedStr(subtrno1)+
         ','+QuotedStr(trdesc)+
         ','+QuotedStr(trdesc2)+
         ','+QuotedStr(roomno)+
         ','+QuotedStr(pymtmthd)+
         ','+QuotedStr(currcd)+
         ','+FloatToStr(currbs1)+
         ','+FloatToStr(currbs2)+
         ','+FloatToStr(ftotamt)+
         ','+FloatToStr(totamt)+
         ','+FloatToStr(frmnamt)+
         ','+IntToStr(active)+
         ','+QuotedStr(rsvno)+
         ','+QuotedStr(subrsvno)+
         ','+QuotedStr(user)+
         ','+QuotedStr(cardcd)+
         ','+QuotedStr(cardno)+
         ','+QuotedStr(cardnm)+
         ','+RelaxDate(cardexp)+
         ','+QuotedStr(grpcd)+
         ','+QuotedStr(compcd)+
         ','+IntToStr(pax)+
         ','+IntToStr(slstp)+
         ','+QuotedStr(trtm)+
         ')';

  res := SQLExecEx(str);
end;

procedure TiafjrnDT.saveDT;
var str: String;
    res,newitemseq: Integer;
begin
  //

  newitemseq := getitemseq;
  str := 'insert into iafjrndt (trdt,seq,pscd,trno,trno1,subtrno,itemseq,itemcd,qty,discpct,trdesc,active,usrcrt,waitercd,cono)' +
         ' values (' + RelaxDate(trdt) +
         ','+ IntToStr(seq)+
         ','+ QuotedStr(pscd)+
         ','+ QuotedStr(trno)+
         ','+ QuotedStr(trno1)+
         ','+ QuotedStr(subtrno)+
         ','+ IntToStr(newitemseq)+
         ','+ QuotedStr(itemcd)+
         ','+ FloatToStr(qty)+
         ','+ FloatToStr(discpct)+
         ','+ QuotedStr(trdesc)+
         ','+ IntToStr(active)+
         ','+ QuotedStr(usercrt)+
         ','+ QuotedStr(waitercd)+
         ','+ QuotedStr(cono)+
         ')';
  res := SQLExecEx(str);
end;

procedure TiafjrnDT.deleteDT;
var str: String;
    res: Integer;
begin
  //
  str := 'update iafjrndt set active=0,usrdel='+QuotedStr(usercrt)+' where trno='+QuotedStr(trno)+' and seq='+IntToStr(seq);
  res := SQLExecEx(str);
end;



procedure TiafjrnHD.deleteHD;
var str: String;
    res: Integer;
begin
  //
  str := 'update iafjrnhd set active=0,usrdel='+QuotedStr(user)+' where trno='+QuotedStr(trno);
  res := SQLExecEx(str);
end;

constructor TiafjrnHD.Create;
begin
  //
  active := 1;
  pax := 1;
  slstp := 1;
  trtm := FormatDateTime('hh:mm:ss',Time);
end;

constructor Tcalcamt.Create;
begin
  active := 1;
  extbed := False;
  manualprice:= False;
end;

constructor Tstarsys.Create;
begin
  flag := 1;
end;

constructor TiafjrnDT.Create;
begin
  active := 1;
end;

function ConnectDB : Boolean;
var sHostName : String;
begin

  sHostName := dm.serverName;
  with dm.mySQL1 do begin
    Close;
    Params.Clear;
    DriverName := 'dbxmysql';
    GetDriverFunc := 'getSQLDriverMYSQL50';
    LibraryName := 'dbxopenmysql50.dll';
    VendorLib := 'libmysql.dll';
    LoginPrompt := False;
    Params.Clear;
    Params.Append('Database='+dm.DBNm);
    Params.Append('User_Name=root');
    Params.Append('Password=toor');
    Params.Append('HostName='+sHostName);
    Params.Append('ConnectionTimeOut=3000');
    if not connected then  begin
      try
        //Open;
        Connected := True;
      except
        Result := False;
        Exit;
      end;
    end;

    if connected then begin
      Result := True;
    end;
  end;

end;

procedure deleteFODeposit(sPyNo:String);
var sDpNo,strcmd : String;
    res : Integer;
begin

    strcmd := 'select trnodp from iafdpallc where active=1 and trnoallc='+QuotedStr(sPyNo);
    sDpNo := GetData(strcmd,'trnodp');

    strcmd := 'update iafdpallc set active = 0 where active=1 and trnodp = ' + QuotedStr(sDpNo) + ' and trnoallc='+QuotedStr(sPyNo);
    res := SQLExecEx(strcmd);

    strcmd := 'update iafdphd set rmnamt=totamt-(select ifnull(sum(totamt),0) from iafdpallc where active=1 and trnodp='+QuotedStr(sDpNo)+')'+
              ' where iafdphd.trno='+QuotedStr(sDpNo);
    res := SQLExecEx(strcmd);

end;

procedure AddHolidayRate(sRatecd,sRoomTpCd,sRsvNo,sSeqno:String; dDate: TDateTime);
var dt,item : TSimpleDataSet;
    strc,currcd : String;
    res : Integer;
    famtnett,famttax,famtsvchg,famtplus,tax_svc : Double;
    lamtnett,lamtplus,lamttax,lamtsvchg,fcurr1,fcurr2 : Double;
begin
  //

  strc := 'select * from fosholidaydt' +
          ' where active=1' +
          ' and ratecd='+QuotedStr(sRatecd)+
          ' and roomtpcd='+QuotedStr(sRoomTpCd)+
          ' and trdt='+RelaxDate(dDate);

  dt := TSimpleDataSet.Create(nil);
  dt.Connection := dm.mySQL1;
  dt.DataSet.CommandText := strc;
  dt.Open;

  if dt.RecordCount=0 then Exit;

  if dt['surcharge'] = 0 then Exit;

  item := TSimpleDataSet.Create(nil);
  item.Connection := dm.mysql1;
  item.DataSet.CommandText := 'select amtsls,pctsvchg,pcttax,coarvn,coasvchg,coatax,coacost,itemdesc from psspsitem where itemcd='+QuotedStr(dt['itemcd']) + ' and pscd='+QuotedStr(dt['pscd']);
  item.Open;

  currcd := GetDataStr('select prfcurcd from gnprofile','prfcurcd');
  fcurr1 := GetDataFloat('select curr1 from gncurrdt where currcd = '+ QuotedStr(currcd),'curr1');
  fcurr2 := GetDataFloat('select curr2 from gncurrdt where currcd = '+ QuotedStr(currcd),'curr2');

  tax_svc := 1 + item['pcttax']/100 + item['pctsvchg']/100;
  famtnett := dt['surcharge'];
  famtplus := famtnett / tax_svc;
  lamtnett := dt['surcharge'] * fcurr2;
  lamtplus := lamtnett / tax_svc;
  lamttax := lamtplus * item['pcttax']/100;
  lamtsvchg := lamtplus * item['pctsvchg']/100;

  strc := 'insert into fofrate (trdt,rsvno,roomtpcd,pscd,psitem,holidaycd,currcd,base1,base2,famtnett,amtrvn,amtsvchg,amttax,amtnett,ratecd,rateseqno,qty,changedrate) values' +
         '('+RelaxDate(dDate) +                //trdt
         ','+QuotedStr(sRsvno)+                  //rsvno
         ','+QuotedStr(sRoomTpCd)+
         ','+QuotedStr(dt['pscd'])+    //pscd
         ','+QuotedStr(dt['itemcd'])+    //psitem
         ','+QuotedStr(dt['holidaycd'])+
         ','+QuotedStr(currcd)+                 //currcd
         ','+FloatToStr(fcurr1)+                //base1
         ','+FloatToStr(fcurr2)+                //base2
         ','+FloatToStr(famtnett)+              //famtnett
         ','+FloatToStr(lamtplus)+              //amtrvn
         ','+FloatToStr(lamtsvchg)+             //amtsvchg
         ','+FloatToStr(lamttax)+               //amttax
         ','+FloatToStr(lamtnett)+              //amtnett
         ','+QuotedStr(sRateCd)+                 //ratecd
         ','+QuotedStr(sSeqno)+          //seqno
         ',1,0)';                                //qty, changedrate

  res := SQLExecEx(strc);



end;

procedure Tcalcamt.CalcAmt;
var item,itemrate : TSimpleDataSet;
    rateamt,discamt,amtnett,svchg,tax,amtplus,amtsls,amtcost:Double;
    hargaplus,hargatotal,pengurang1,pengurang2: Double;
    coarvn,coasvchg,coatax,coacost : String;
    coarvnthd1,coarvnthd2,coasvchgthd1,coasvchgthd2,coataxthd1,coataxthd2: String;
    billRsvno,billSubtrno,trno1gl:String;
    dtrvnamt,dtrateamt,dtdiscamt,dtsvchg,dttax: Double;
    valsvchg,valtax,taxsvc : Double;
    strcmd : String;
    res : Integer;
    trdate : TDateTime;
    hargarate,hargahotel: Double;
begin
  //

  SQLExec('delete from iafjrngl where seq='+IntToStr(seq));


  if na=True then
    trdate := getFOPrd-1
  else
    trdate := getFOPrd;

  if extbed=True then begin
    trdate := getFOPrd-1;
    //qty := 1;
  end;

  item := TSimpleDataSet.Create(nil);
  item.Connection := dm.mySQL1;

  if item.Active then item.Close;
  item.DataSet.CommandText := 'select *, 1 + pcttax/100 + pctsvchg/100 as tax_svc,1 + pcttax1/100 + pctsvchg1/100 as tax_svc1,1 + pcttax2/100 + pctsvchg2/100 as tax_svc2 '+
                              ' from psspsitem where itemcd='+QuotedStr(itemcd) + ' and pscd='+QuotedStr(outletcd);
  item.Open;

  if na=True then begin
    itemrate := TSimpleDataSet.Create(nil);
    itemrate.Connection := dm.mySQL1;
    itemrate.DataSet.CommandText := 'select amtrvn,amtsvchg,amttax from fofrate where trdt='+RelaxDate(trdate)+' and rsvno='+QuotedStr(rsvno)+' and pscd='+QuotedStr(outletcd) + ' and psitem = ' + QuotedStr(itemcd);
    itemrate.Open;
  end;

  openitem := item['Open'];
  amtcost := GetData('select amtcost from psspsitem where pscd='+QuotedStr(outletcd)+ ' and itemcd='+QuotedStr(itemcd),'amtcost') * qty;

  if na=True then begin
    hargaplus := itemrate['amtrvn'];
    valtax := itemrate['amttax'];
    valsvchg := itemrate['amtsvchg'];
    hargarate := hargaplus;
  end
  else begin
    if openitem=0 then begin
      hargaplus := item['amtsls'] * qty;
      hargarate := item['amtsls'];
    end
    else begin
      hargaplus := price * qty;
      hargarate := price;
    end;
  end;

  if nett=True then begin
      if extbed=True then
        //hargaplus := (price / item['tax_svc']) * qty
        hargaplus := price * qty
      else
        //hargaplus := (price / item['tax_svc']) * qty;
        //hargaplus := price * qty;
        hargaplus := (hitungAmtplus(price*qty,itemcd,outletcd) / item['tax_svc']) * qty;

      hargarate := (price / item['tax_svc']);
  end;

  if nslstp=0 then begin
    if nett=False then begin
      hargaplus := amtcost * qty;
      hargarate := amtcost;
    end;
    if nett=True then begin
      hargaplus := price * qty;
      hargarate := price;
    end;
  end;

  case item['thd1'] of
    0 : pengurang1 := 0;
    1 : pengurang1 := item['amtrvn1'];
    2 : begin
          if nett=False then
            pengurang1 := (item['pctrvn1']/100) * price
          else
            pengurang1 := (item['pctrvn1']/100) * (price / item['tax_svc']);
          pengurang1 := pengurang1 - (pengurang1 * disc/100);
        end;
  end;

  case item['thd2'] of
    0 : pengurang2 := 0;
    1 : pengurang2 := item['amtrvn2'];
    2 : begin
          if nett=False then
            pengurang2 := (item['pctrvn2']/100) * price
          else
            pengurang2 := (item['pctrvn2']/100) * (price /item['tax_svc']);
          pengurang2 := pengurang2 - (pengurang2 * disc/100);
        end;
  end;

  pengurang1 := pengurang1 * qty;
  pengurang2 := pengurang2 * qty;

  hargahotel := hargaplus;
  hargarate := hargaplus; //sebelum discount
  //hargaplus := (price-   pengurang1-pengurang2) - (hargahotel*(disc/100));
  hargaplus := (price-(price*(disc/100)));


  hargatotal := hargaplus-pengurang1-pengurang2;
  //hargatotal := hargaplus;

  case nslstp of
    1 :
      begin
        if nett=True then begin

          amtplus := hargatotal;
          //discamt := amtplus * (disc/100);
          amtsls := amtplus;// - discamt;
          //amtplus := amtnett / item['tax_svc'];
          //amtplus := amtsls;
          tax     := amtsls * (item['pcttax']/100);
          svchg   := amtsls * (item['pctsvchg']/100);
          amtnett  := amtplus + tax + svchg;
        end
        else if nett=False then begin
          if (na=True) and ((item['thd1']=0) or (item['thd2']=0)) then begin
            amtplus := hargaplus;
            amtsls  := hargaplus;
            svchg   := valsvchg;
            tax     := valtax;
          end
          else begin
            amtplus  := hargatotal;// * qty;
            //discamt  := amtplus * (disc/100);
            amtsls   := amtplus;// - discamt;
            amtplus  := amtsls;
            tax      := amtsls * (item['pcttax']/100);
            svchg    := amtsls * (item['pctsvchg']/100);
          end;
          amtnett  := amtplus + tax + svchg;
          itemdesc := item['itemdesc'];
        end;

      end;

    0 :
      begin
        if nett=True then  begin
          amtplus := hargaplus;
          amtnett := hargaplus;
          amtsls  := hargaplus;
          svchg   := 0;
          tax     := 0;
        end
        else if nett=False then begin
          amtplus := amtcost;
          amtnett := amtcost;
          amtsls  := amtcost;
          svchg   := 0;
          tax     := 0;
        end;
      end;
  end;

  dtrvnamt := amtnett;
  dtrateamt := amtplus;
  dtdiscamt := discamt;
  dtsvchg := svchg;
  dttax := tax;

  SaveGL(trdate,seq,trno,trno1,'',outletcd,dm.GuestLedgerCOA,amtnett,0,rsvno,subrsvno,trdesc,trdesc2,'',0,dm.UserID,active,trdate);

  if nslstp = 1 then begin
    SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coarvn'],0,amtplus,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
    SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coatax'],0,tax,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
    SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coasvchg'],0,svchg,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
  end
  else if nslstp = 0 then begin
    SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coacost'],0,amtplus,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
  end;


  if item['thd1'] <> 0 then begin
    case nslstp of
      1 :
        begin

          amtplus  := pengurang1;// * qty;
          //discamt  := amtplus * (disc/100);
          amtsls := amtplus;
          amtplus  := amtsls;
          tax      := amtplus * (item['pcttax1']/100);
          svchg    := amtplus * (item['pctsvchg1']/100);
          amtnett  := amtplus + tax + svchg;
          itemdesc := item['itemdesc'];
          trdesc := itemdesc + '/' + IntToStr(qty);



        end;

    end;

    if nslstp=1 then begin
      dtrvnamt := dtrvnamt + amtplus;
      dtrateamt := dtrateamt + amtplus;
      dtdiscamt := dtdiscamt + discamt;
      dtsvchg := dtsvchg + svchg;
      dttax := dttax + tax;

      SaveGL(trdate,seq,trno,trno1,'',outletcd,dm.GuestLedgerCOA,amtnett,0,rsvno,subrsvno,trdesc,trdesc2,'',0,dm.UserID,active,trdate);
      SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coarvn1'],0,amtplus,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
      SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coatax1'],0,tax,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
      SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coasvchg1'],0,svchg,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
    end;

  end;

//-----------------


  if item['thd2'] <> 0 then begin
    case nslstp of
      1 :
        begin
          amtplus  := pengurang2;// * qty;
          //discamt  := amtplus * (disc/100);
          amtsls := amtplus;
          amtplus  := amtsls;
          tax      := amtplus * (item['pcttax2']/100);
          svchg    := amtplus * (item['pctsvchg2']/100);
          amtnett  := amtplus + tax + svchg;
          itemdesc := item['itemdesc'];
          trdesc := itemdesc + '/' + IntToStr(qty);



      end;

    end;

    if nslstp=1 then begin
      dtrvnamt := dtrvnamt + amtplus;
      dtrateamt := dtrateamt + amtplus;
      dtdiscamt := dtdiscamt + discamt;
      dtsvchg := dtsvchg + svchg;
      dttax := dttax + tax;


      SaveGL(trdate,seq,trno,trno1,'',outletcd,dm.GuestLedgerCOA,amtnett,0,rsvno,subrsvno,trdesc,trdesc2,'',0,dm.UserID,active,trdate);
      SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coarvn2'],0,amtplus,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
      SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coatax2'],0,tax,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
      SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coasvchg2'],0,svchg,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
      
    end;

  end;

    strcmd :=   'update iafjrndt ' +
              ' set rvnamt = ' + FloatToStr(dtrateamt) +
              ',rateamt = '+ FloatToStr(hargarate)+//FloatToStr(hargaplus)+//FloatToStr(hargarate)+//FloatToStr(dtrateamt)+
              ',amtcost = '+ FloatToStr(amtcost)+
              ',discamt = '+ FloatToStr(dtdiscamt)+
              ',discpct = '+ IntToStr(disc)+
              ',qty = ' + IntToStr(qty) +
              ',svchgamt = ' + FloatToStr(dtsvchg) +
              ',taxamt = ' + FloatToStr(dttax) +
              ',rvncoa = ' + QuotedStr(item['coarvn']) +
              ',svchgcoa = ' + QuotedStr(item['coasvchg']) +
              ',taxcoa = ' + QuotedStr(item['coatax']) +
              ' where pscd='+QuotedStr(outletcd)+
              ' and trno='+QuotedStr(trno)+
              ' and itemcd='+QuotedStr(itemcd) +
              ' and seq='+IntToStr(seq);

  res := SQLExecEx(strcmd);

end;

function getMaintenance(vDate: TDateTime): Integer;
var str: String;
    res: Integer;
begin
  //
  str := 'select count(roomno) as cnt' +
         ' from fofroommaint' +
         ' where fromdt <= ' + RelaxDate(vDate) + ' and todt >= '+RelaxDate(vDate);
  result := GetDataInt(str,'cnt');
end;

function getroomhuact(vDate:TDateTime) : Currency;
var cmd : TSQLQuery;
begin
  cmd := TSQLQuery.Create(nil);
  cmd.SQLConnection := dm.mySQL1;

  if cmd.Active then cmd.Close;
  cmd.CommandText := 'select IFNULL(count(rsvno),0) as RmAv ' +
                     ' from fofrsv where rsvst IN( ''R'',''D'',''T'',''O'')'+
                     ' and arrdt <=' + RelaxDate(vDate) + ' and depdt > ' + RelaxDate(vDate) +
                     ' and rsvtp = ''3''';
  cmd.Open;
  Result := cmd['RmAv'];

  if cmd.Active then cmd.Close;
  cmd.CommandText := 'select IFNULL(count(rsvno),0) as RmAv ' +
                     ' from fofhisrsv where rsvst IN(''O'')'+
                     ' and arrdt <=' + RelaxDate(vDate) + ' and depdt > ' + RelaxDate(vDate) +
                     ' and rsvtp = ''3''';
  cmd.Open;
  Result := Result + cmd['RmAv'];

end;


procedure Tstarsys.updStarsys;
var str: String;
    res,tb: Integer;
begin
  //

  str := 'show tables like ''room''';
  tb := SQLExecEx(str);

  if tb > 0 then begin

    str := 'insert into room (room,name,wkup,cos,type,flag) values (' + QuotedStr(rm) +
           ','+QuotedStr(nm)+
           ','+QuotedStr(wk)+
           ','+QuotedStr(cos)+
           ','+QuotedStr(typ)+
           ',1)';
    res := SQLExecEx(str);

   end;
end;

function hitungExtraBed: Double;
var exbeditemcd: String;
    exbedsls: Double;
    dt: TSimpleDataSet;
    pengurang1,pengurang2,hargaplus: Double;
    hargatotal,harganett: Double;
    tax,svc: Double;
begin

  //
  exbeditemcd := GetData('select itemcdexbed from iassystem','itemcdexbed');
  dt := TSimpleDataSet.Create(nil);
  dt.Connection := dm.mySQL1;
  dt.DataSet.CommandText := 'select *, 1 + pcttax/100 + pctsvchg/100 as tax_svc,1 + pcttax1/100 + pctsvchg1/100 as tax_svc1,1 + pcttax2/100 + pctsvchg2/100 as tax_svc2 '+
                              ' from psspsitem where itemcd='+QuotedStr(exbeditemcd);
  dt.Open;


  exbedsls := dt['amtsls'];

  case dt['thd1'] of
    0 : pengurang1 := 0;
    1 : pengurang1 := dt['amtrvn1'];
    2 : pengurang1 := (dt['pctrvn1']/100) * exbedsls;
  end;

  case dt['thd2'] of
    0 : pengurang2 := 0;
    1 : pengurang2 := dt['amtrvn2'];
    2 : pengurang2 := (dt['pctrvn2']/100) * exbedsls;
  end;

  hargatotal := exbedsls - pengurang1 - pengurang2;

  tax := hargatotal * dt['pcttax'] / 100;
  svc := hargatotal * dt['pctsvchg'] / 100;

  harganett := hargatotal + tax + svc;

  Result := harganett + pengurang1 + pengurang2

end;

function hitungAmtplusExtraBed(amtnett: Double): Double;
var pengurang1,pengurang2,exbedsls: Double;
    dt: TSimpleDataSet;
    exbeditemcd: String;
    harganett,hargaplus: Double;
begin
  //
  exbeditemcd := GetData('select itemcdexbed from iassystem','itemcdexbed');

  dt := TSimpleDataSet.Create(nil);
  dt.Connection := dm.mySQL1;
  dt.DataSet.CommandText := 'select *, 1 + pcttax/100 + pctsvchg/100 as tax_svc,1 + pcttax1/100 + pctsvchg1/100 as tax_svc1,1 + pcttax2/100 + pctsvchg2/100 as tax_svc2 '+
                              ' from psspsitem where itemcd='+QuotedStr(exbeditemcd);
  dt.Open;

  exbedsls := dt['amtsls'];

  case dt['thd1'] of
    0: pengurang1 := 0;
    1: pengurang1 := dt['amtrvn1'];
    2: pengurang1 := (dt['pctrvn1']/100) * exbedsls;
  end;

  case dt['thd2'] of
    0: pengurang2 := 0;
    1: pengurang2 := dt['amtrvn2'];
    2: pengurang2 := (dt['pctrvn2']/100) * exbedsls;
  end;

  harganett := amtnett - pengurang1 - pengurang2;
  hargaplus := harganett / dt['tax_svc'];
  Result := hargaplus + pengurang1 + pengurang2;



end;

function hitungAmtplus(amtnett: Double;itemcd,pscd:String): Double;
var pengurang1,pengurang2,amtsls: Double;
    dt: TSimpleDataSet;
    exbeditemcd: String;
    harganett,hargaplus: Double;
begin
  //

  dt := TSimpleDataSet.Create(nil);
  dt.Connection := dm.mySQL1;
  dt.DataSet.CommandText := 'select *, 1 + pcttax/100 + pctsvchg/100 as tax_svc,1 + pcttax1/100 + pctsvchg1/100 as tax_svc1,1 + pcttax2/100 + pctsvchg2/100 as tax_svc2 '+
                              ' from psspsitem where itemcd='+QuotedStr(itemcd) + ' and pscd='+QuotedStr(pscd);
  dt.Open;

  amtsls := dt['amtsls'];

  case dt['thd1'] of
    0: pengurang1 := 0;
    1: pengurang1 := dt['amtrvn1'];
    2: pengurang1 := (dt['pctrvn1']/100) * amtsls;
  end;

  case dt['thd2'] of
    0: pengurang2 := 0;
    1: pengurang2 := dt['amtrvn2'];
    2: pengurang2 := (dt['pctrvn2']/100) * amtsls;
  end;

  harganett := amtnett - pengurang1 - pengurang2;
  hargaplus := harganett / dt['tax_svc'];
  Result := hargaplus + pengurang1 + pengurang2;



end;

function hitungAmtnett(amtplus: Double;itemcd,pscd:String): Double;
var pengurang1,pengurang2,amtsls: Double;
    dt: TSimpleDataSet;
    exbeditemcd: String;
    harganett,hargaplus: Double;
    plusincl3rd,plusexcl3rd:Double;
begin
  //

  dt := TSimpleDataSet.Create(nil);
  dt.Connection := dm.mySQL1;
  dt.DataSet.CommandText := 'select *, 1 + pcttax/100 + pctsvchg/100 as tax_svc,1 + pcttax1/100 + pctsvchg1/100 as tax_svc1,1 + pcttax2/100 + pctsvchg2/100 as tax_svc2 '+
                              ' from psspsitem where itemcd='+QuotedStr(itemcd) + ' and pscd='+QuotedStr(pscd);
  dt.Open;

  plusincl3rd := amtplus;
  pengurang1 := dt['amtrvn1'];
  pengurang2 := dt['amtrvn2'];

  plusexcl3rd := plusincl3rd - pengurang1 - pengurang2;
  Result := plusexcl3rd+(plusexcl3rd*dt['pcttax']/100)+(plusexcl3rd*dt['pctsvchg']/100);
  Result := Result + pengurang1 + pengurang2;



end;

procedure Tcalcamt.CalcAmt2;
var pengurang1,pengurang2,amtcost: Double;
    hargaplus,valtax,valsvchg,hargarate,harganett,hargahotelnett: Double;
    amtplus_incl_3rd: Double;
    tax_svc,tax_svc1,tax_svc2,amttax,amtsvc: Double;
    item,itemrate : TSimpleDataSet;
    trdate: TDateTime;
    hargahotelnett_after_disc: Double;
    strcmd: String;
    res: Integer;
    guestledgercoa : String;
begin
  //
  SQLExec('delete from iafjrngl where seq='+IntToStr(seq));

  guestledgercoa := Trim(GetDataStr('select coagstled from iassystem','coagstled')); 

  if na=True then
    trdate := getFOPrd-1
  else
    trdate := getFOPrd;

  if extbed=True then begin
    trdate := getFOPrd-1;
  end;

  item := TSimpleDataSet.Create(nil);
  item.Connection := dm.mySQL1;

  if item.Active then item.Close;
  item.DataSet.CommandText := 'select *, 1 + pcttax/100 + pctsvchg/100 as tax_svc,1 + pcttax1/100 + pctsvchg1/100 as tax_svc1,1 + pcttax2/100 + pctsvchg2/100 as tax_svc2 '+
                              ' from psspsitem where itemcd='+QuotedStr(itemcd) + ' and pscd='+QuotedStr(outletcd);
  item.Open;

  if na=True then begin
    itemrate := TSimpleDataSet.Create(nil);
    itemrate.Connection := dm.mySQL1;
    itemrate.DataSet.CommandText := 'select amtrvn,amtsvchg,amttax from fofrate where trdt='+RelaxDate(trdate)+' and rsvno='+QuotedStr(rsvno)+' and pscd='+QuotedStr(outletcd) + ' and psitem = ' + QuotedStr(itemcd);
    itemrate.Open;
  end;

  tax_svc := item['tax_svc'];
  tax_svc1 := item['tax_svc1'];
  tax_svc2 := item['tax_svc2'];
  if manualprice=False then
    amtplus_incl_3rd := item['amtsls'] * qty
  else
    amtplus_incl_3rd := getPricePlus(pricenett,itemcd,outletcd) * qty;

  openitem := item['Open'];
  amtcost := GetData('select amtcost from psspsitem where pscd='+QuotedStr(outletcd)+ ' and itemcd='+QuotedStr(itemcd),'amtcost') * qty;

  if na=True then begin
    hargaplus := itemrate['amtrvn'];
    valtax := itemrate['amttax'];
    valsvchg := itemrate['amtsvchg'];
    hargarate := hargaplus;
    harganett := hargaplus + valtax + valsvchg;
  end
  else begin
    harganett := pricenett * qty;
    //hargaplus := harganett / tax_svc;
    hargarate := price;
  end;

  pengurang1 := getPengurang1(item['thd1'],hargaplus,itemcd,outletcd) * qty;
  pengurang2 := getPengurang2(item['thd2'],hargaplus,itemcd,outletcd) * qty;

  hargahotelnett := harganett - pengurang1 - pengurang2;

  case nslstp of
    1: begin
          hargaplus := hargahotelnett / tax_svc;
          amttax := hargaplus * (item['pcttax']/100);
          amtsvc := hargaplus * (item['pctsvchg']/100);
       end;
    0: begin
          hargaplus := amtcost * qty;
          amttax := 0;
          amtsvc := 0;
       end;
  end;

  SaveGL(trdate,seq,trno,trno1,'',outletcd,guestledgercoa,hargahotelnett,0,rsvno,subrsvno,trdesc,trdesc2,'',0,dm.UserID,active,trdate);

  if nslstp = 1 then begin
    SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coarvn'],0,hargaplus,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
    SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coatax'],0,amttax,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
    SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coasvchg'],0,amtsvc,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
  end
  else if nslstp = 0 then begin
    SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coacost'],0,hargaplus,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
  end;

  if item['thd1'] <> 0 then begin
      SaveGL(trdate,seq,trno,trno1,'',outletcd,guestledgercoa,pengurang1,0,rsvno,subrsvno,trdesc,trdesc2,'',0,dm.UserID,active,trdate);
      SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coarvn1'],0,pengurang1,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
  end;

  if item['thd2'] <> 0 then begin
      SaveGL(trdate,seq,trno,trno1,'',outletcd,guestledgercoa,pengurang2,0,rsvno,subrsvno,trdesc,trdesc2,'',0,dm.UserID,active,trdate);
      SaveGL(trdate,seq,trno,trno1,'',outletcd,item['coarvn2'],0,pengurang2,rsvno,subrsvno,trdesccr,trdesc2,'',0,dm.UserID,active,trdate);
  end;

  strcmd :=   'update iafjrndt ' +
              ' set rvnamt = ' + FloatToStr(amtplus_incl_3rd) +
              ',rateamt = '+ FloatToStr(hargarate)+//FloatToStr(hargaplus)+//FloatToStr(hargarate)+//FloatToStr(dtrateamt)+
              ',amtcost = '+ FloatToStr(amtcost)+
              ',discamt = '+ FloatToStr(hargarate*disc/100)+
              ',discpct = '+ IntToStr(disc)+
              ',qty = ' + IntToStr(qty) +
              ',svchgamt = ' + FloatToStr(amtsvc) +
              ',taxamt = ' + FloatToStr(amttax) +
              ',rvncoa = ' + QuotedStr(item['coarvn']) +
              ',svchgcoa = ' + QuotedStr(item['coasvchg']) +
              ',taxcoa = ' + QuotedStr(item['coatax']) +
              ' where pscd='+QuotedStr(outletcd)+
              ' and trno='+QuotedStr(trno)+
              ' and itemcd='+QuotedStr(itemcd) +
              ' and seq='+IntToStr(seq);

  res := SQLExecEx(strcmd);


end;

function getPriceNett(item,outlet:String): Double;
var str: String;
    amtplus_incl_3rd,amtplus_excl_3rd : Double;
    amtnett_incl_3rd,amtnett_excl_3rd : Double;
    pengurang1,pengurang2: Double;
    tp1,tp2: Integer;
    tax,svc,tax_svc: Double;
begin
  //
  str := 'select amtsls from psspsitem where itemcd='+QuotedStr(item)+' and pscd='+QuotedStr(outlet);
  amtplus_incl_3rd := GetDataFloat(str,'amtsls');
  str := 'select thd1 from psspsitem where itemcd='+QuotedStr(item)+' and pscd='+QuotedStr(outlet);
  tp1 := GetDataInt(str,'thd1');
  str := 'select thd2 from psspsitem where itemcd='+QuotedStr(item)+' and pscd='+QuotedStr(outlet);
  tp2 := GetDataInt(str,'thd2');

  str := 'select 1 + pcttax/100 + pctsvchg/100 as tax_svc from psspsitem where itemcd='+QuotedStr(item)+' and pscd='+QuotedStr(outlet);
  tax_svc := GetDataFloat(str,'tax_svc');

  pengurang1 := getPengurang1(tp1,amtplus_incl_3rd,item,outlet);
  pengurang2 := getPengurang2(tp2,amtplus_incl_3rd,item,outlet);

  amtplus_excl_3rd := amtplus_incl_3rd - pengurang1 - pengurang2;

  amtnett_excl_3rd := amtplus_excl_3rd * tax_svc;
  amtnett_incl_3rd := amtnett_excl_3rd + pengurang1 + pengurang2;

  Result := amtnett_incl_3rd;

end;

function getPricePlus(amtnett:Double;item,outlet:String): Double;
var pengurang1,pengurang2: Double;
    str: String;
    tp1,tp2: Integer;
    amtnett_excl_3rd,amtplus_excl_3rd,tax_svc,amtplus_incl_3rd: Double;
begin
  //
  str := 'select amtsls from psspsitem where itemcd='+QuotedStr(item)+' and pscd='+QuotedStr(outlet);
  str := 'select thd1 from psspsitem where itemcd='+QuotedStr(item)+' and pscd='+QuotedStr(outlet);
  tp1 := GetDataInt(str,'thd1');
  str := 'select thd2 from psspsitem where itemcd='+QuotedStr(item)+' and pscd='+QuotedStr(outlet);
  tp2 := GetDataInt(str,'thd2');

  str := 'select 1 + pcttax/100 + pctsvchg/100 as tax_svc from psspsitem where itemcd='+QuotedStr(item)+' and pscd='+QuotedStr(outlet);
  tax_svc := GetDataFloat(str,'tax_svc');

  pengurang1 := getPengurang1(tp1,amtnett,item,outlet);
  pengurang2 := getPengurang2(tp2,amtnett,item,outlet);

  amtnett_excl_3rd := amtnett - pengurang1 - pengurang2;
  amtplus_excl_3rd := amtnett_excl_3rd / tax_svc;
  amtplus_incl_3rd := amtplus_excl_3rd + pengurang1 + pengurang2;

  Result := amtplus_incl_3rd;

end;


function getPengurang1(tp:Integer;amtplus:Double;item,outlet:String): Double;
var str1,str2: String;
    pct: Double;
begin
  //
  str1 := 'select amtrvn1 from psspsitem where itemcd='+QuotedStr(item)+' and pscd='+QuotedStr(outlet);
  str2 := 'select pctrvn1 from psspsitem where itemcd='+QuotedStr(item)+' and pscd='+QuotedStr(outlet);
  case tp of
    0: Result := 0;
    1: Result := GetDataFloat(str1,'amtrvn1');
    2: begin
          pct := GetDataFloat(str2,'pctrvn1');
          Result := amtplus * (pct/100);
       end;
  end;


end;

function getPengurang2(tp:Integer;amtplus:Double;item,outlet:String):Double;
var str1,str2: String;
    pct: Double;
begin
  //
  str1 := 'select amtrvn2 from psspsitem where itemcd='+QuotedStr(item)+' and pscd='+QuotedStr(outlet);
  str2 := 'select pctrvn2 from psspsitem where itemcd='+QuotedStr(item)+' and pscd='+QuotedStr(outlet);
  case tp of
    0: Result := 0;
    1: Result := GetDataFloat(str1,'amtrvn2');
    2: begin
          pct := GetDataFloat(str2,'pctrvn2');
          Result := amtplus * (pct/100);
       end;
  end;
end;

function TiafjrnDT.getitemseq : Integer;
var maxseq: Integer;
    str: String;
begin
  //
  str := 'select ifnull(max(itemseq),0) as maxseqno from iafjrndt where pscd = ' + QuotedStr(pscd) +' and trno='+QuotedStr(trno) + ' and subtrno='+QuotedStr(subtrno);
  maxseq := GetDataInt(str,'maxseqno');

  Result := maxseq + 1;


end;




end.
