unit collection;

interface

const Active1 = ' and active=1 ';
      Active0 = ' and active=0 ';
      {
      FOBillx = 'select iafjrngl.trdt,(select coadtdesc from gncoadt where iafjrngl.coa=gncoadt.coadtcd) as coadtdesc ,iafjrngl.trno ,iafjrngl.seq,iafjrngl.trno1' +
               ',iafjrngl.subtrno1,iafjrngl.rsvno,iafjrngl.subrsvno,iafjrngl.coa,iafjrngl.pscd' +
               ',(select psdesc from pssps where iafjrngl.pscd=pssps.PsCd) as psdesc' +
               ',sum(iafjrngl.dbamt) as Debet,sum(iafjrngl.cramt) as Credit,if(sum(iafjrngl.dbamt)>sum(iafjrngl.cramt),sum(iafjrngl.dbamt)-sum(iafjrngl.cramt),0) as sum2_dbamt' +
               ',if(sum(iafjrngl.cramt)>sum(iafjrngl.dbamt),sum(iafjrngl.cramt)-sum(iafjrngl.dbamt),0) as sum2_cramt,iafjrngl.trdesc,iafjrngl.trdesc2,iafjrngl.docdt' +
               ',iafjrngl.id,iafjrngl.usrcrt,iafjrngl.active,fofrsv.RsvNm,fofrsv.RoomNo,fofrsv.RoomTpCd' +
               ',fofrsv.Address,fofrsv.Address,fofrsv.ArrDt,fofrsv.Nights,fofrsv.DepDt,fofrsv.CompDesc' +
               ',fofrsv.RateCd from iafjrngl' +
               ' INNER JOIN iassystem	on (iafjrngl.coa=iassystem.COAGstLed)	LEFT JOIN fofrsv' +
               '	on (iafjrngl.rsvno=fofrsv.RsvNo) where active<>''0'''+
               ' and iafjrngl.pscd @pscd' +
               ' and (iafjrngl.rsvno=:rsvno) @subrsvno ' +
               ' and iafjrngl.coa=iassystem.COAGstLed' +
               //' group by iafjrngl.coa,iafjrngl.trdt,iafjrngl.pscd,iafjrngl.trno' +
               //' order by iafjrngl.coa,iafjrngl.trdt,iafjrngl.pscd,iafjrngl.trno';
               ' group by iafjrngl.trno' +
               ' order by iafjrngl.docdt';
      }

      FOBill = 'select iafjrngl.trdt,(select coadtdesc from gncoadt where iafjrngl.coa=gncoadt.coadtcd) as coadtdesc ,iafjrngl.trno ,iafjrngl.seq,iafjrngl.trno1' +
               ',iafjrngl.subtrno1,iafjrngl.rsvno,iafjrngl.subrsvno,iafjrngl.coa,iafjrngl.pscd' +
               ',(select psdesc from pssps where iafjrngl.pscd=pssps.PsCd) as psdesc' +
               ',sum(iafjrngl.dbamt) as Debet,sum(iafjrngl.cramt) as Credit,if(sum(iafjrngl.dbamt)>sum(iafjrngl.cramt),sum(iafjrngl.dbamt)-sum(iafjrngl.cramt),0) as sum2_dbamt' +
               ',if(sum(iafjrngl.cramt)>sum(iafjrngl.dbamt),sum(iafjrngl.cramt)-sum(iafjrngl.dbamt),0) as sum2_cramt,iafjrngl.trdesc,iafjrngl.trdesc2,iafjrngl.docdt' +
               ',iafjrngl.id,iafjrngl.usrcrt,iafjrngl.active,@tablefo.RsvNm,@tablefo.RoomNo,@tablefo.RoomTpCd' +
               ',@tablefo.Address,@tablefo.Address,@tablefo.ArrDt,@tablefo.Nights,@tablefo.DepDt,@tablefo.CompDesc' +
               ',@tablefo.RateCd,@tablefo.Adult,@tablefo.NatCd,@tablefo.PymtMthd,ifnull((select pydesc from iaspyhd where iaspyhd.PyCd=@tablefo.PymtMthd),'''') as pydesc' +
               ' from iafjrngl' +
               ' INNER JOIN iassystem	on (iafjrngl.coa=iassystem.COAGstLed)' +
               ' LEFT JOIN @tablefo on (iafjrngl.rsvno=@tablefo.RsvNo)' +
               ' where active<>''0'''+
               ' and iafjrngl.pscd @pscd' +
               ' and (iafjrngl.rsvno=:rsvno) @subrsvno ' +
               ' and iafjrngl.coa=iassystem.COAGstLed' +
               //' group by iafjrngl.coa,iafjrngl.trdt,iafjrngl.pscd,iafjrngl.trno' +
               //' order by iafjrngl.coa,iafjrngl.trdt,iafjrngl.pscd,iafjrngl.trno';
               ' group by iafjrngl.trno' +
               ' order by iafjrngl.docdt';

      ARSummaryQuery = 'select COMP.CompCd,COMP.CompDesc,GL.TrDt,' +
                       ' sum(if(GL.TrTpCd=''3010'',GL.FTrAmt,0))+sum(if(GL.TrTpCd=''3040'',GL.FTrAmt,0)) as ARAmt,' +
                       ' sum(if(GL.TrTpCd=''3010'',GL.FTrAmtRmn,0))+sum(if(GL.TrTpCd=''3040'',GL.FTrAmtRmn,0)) as ARAmtRmn,' +
                       ' sum(if(GL.TrTpCd=''4011'',GL.FTrAmt,0)) as CBAmt,' +
                       ' sum(if(GL.TrTpCd=''4011'',GL.FTrAmtRmn,0)) as CBAmtRmn' +
                       ' from arscomp COMP' +
                       ' join glftrhd GL' +
                       ' on COMP.CompCd=GL.CompCd' +
                       ' where COMP.Active=1' +
                       ' and GL.Active=1' +
                       ' #WHERE ' +
                       ' group by COMP.CompCd' +
                       ' having ARAmt<> 0 or ARAmtRmn<> 0 or CBAmt<>0 or CBAmtRmn<>0';


      APSummaryQuery = ' select SUPP.SupCd,SUPP.SupDesc,' +
                       ' sum(if(GL.TrTpCd=''2010'',GL.FTrAmt,0))+sum(if(GL.TrTpCd=''7010'',GL.FTrAmt,0)) as APAmt,' +
                       ' sum(if(GL.TrTpCd=''2010'',GL.FTrAmtRmn,0))+sum(if(GL.TrTpCd=''7010'',GL.FTrAmtRmn,0)) as APAmtRmn,' +
                       ' sum(if(GL.TrTpCd=''4012'',GL.FTrAmt,0)) as CBAmt,' +
                       ' sum(if(GL.TrTpCd=''4012'',GL.FTrAmtRmn,0)) as CBAmtRmn' +
                       ' from apssup SUPP' +
                       ' join glftrhd GL' +
                       ' on SUPP.SupCd =GL.SupCd' +
                       ' where SUPP.Active=1' +
                       ' and GL.Active=1' +
                       ' #WHERE '+
                       ' group by SUPP.SupCd' +
                       ' having APAmt<> 0 or APAmtRmn<> 0 or CBAmt<>0 or CBAmtRmn<>0';



      GuestBillQuery = 'SELECT fofrsv.Rsvno' +
                       ' , sum(iafjrngl.dbamt-iafjrngl.cramt) as Balance' +
                       ' FROM fofrsv' +
                       ' LEFT JOIN iafjrngl' +
                       ' ON (fofrsv.RsvNo = iafjrngl.rsvno)' +
                       ' LEFT  JOIN iassystem' +
                       ' ON (iafjrngl.coa = iassystem.COAGstLed)' +
                       ' WHERE iafjrngl.coa = iassystem.COAGstLed' +
                       ' AND iafjrngl.active = 1'+
                       ' group by fofrsv.RsvNo' +
                       //' group by iafjrngl.trno'+
                       ' Order by fofrsv.RoomNo Asc, fofrsv.RsvSt Desc,  fofrsv.RsvNo Asc';
                       //' order by iafjrngl.docdt';

{      GuestDPQuery = 'SELECT fofrsv.Rsvno, CONCAT(fosroom.roomsthk1,fosroom.roomsthk2,fosroom.roomsthk3) as rmst, ifnull(sum(iafdpallc.totamt),0) as DpPaid FROM  fofrsv  INNER JOIN fofrate  ON (fofrate.RsvNo = fofrsv.RsvNo)' +
                     ' INNER JOIN fosroom  ON (fofrsv.RoomNo = fosroom.RoomNo) LEFT JOIN iafdpallc' +
                     ' ON (fofrsv.RsvNo = iafdpallc.RsvNo)' +
                     ' group by fofrsv.RsvNo' +
                     ' Order by fofrsv.RoomNo Asc, fofrsv.RsvSt Desc,  fofrsv.RsvNo Asc';}

      GuestDPQuery = 'SELECT fofrsv.Rsvno, ifnull(sum(iafdpallc.totamt),0) as DpPaid' +
                     ' FROM  fofrsv' +
                     ' LEFT JOIN iafdpallc ON (fofrsv.RsvNo = iafdpallc.RsvNo)' +
                     ' WHERE iafdpallc.Active = 1' +
                     ' group by fofrsv.RsvNo' +
                     ' Order by fofrsv.RsvNo Asc';
{
      GuestRateQuery1 = 'SELECT fofrsv.Rsvno ,(sum(fofrate.AmtRvn)+sum(fofrate.AmtSvchg)+sum(fofrate.AmtTax)) as Sales_Nett ' +
                       ' FROM fofrsv' +
                       ' LEFT JOIN fofrate' +
                       ' ON (fofrate.RsvNo = fofrsv.RsvNo)' +
                       ' LEFT JOIN gnsystem' +
                       ' ON (fofrate.TrDt = gnsystem.FOPrd)' +
                      // ' WHERE (fofrate.TrDt = gnsystem.FOPrd) or (fofrate.TrDt = fofrsv.ArrDt)' +
                       ' WHERE fofrate.TrDt = fofrsv.ArrDt' +
                       ' group by fofrsv.RsvNo' +
                       ' Order by fofrsv.RoomNo Asc, fofrsv.RsvSt Desc,  fofrsv.RsvNo Asc';


      GuestRateQuery2 = 'SELECT fofrsv.Rsvno ,(sum(fofrate.AmtRvn)+sum(fofrate.AmtSvchg)+sum(fofrate.AmtTax)) as Sales_Nett ' +
                       ' FROM fofrsv' +
                       ' LEFT JOIN fofrate' +
                       ' ON (fofrate.RsvNo = fofrsv.RsvNo)' +
                       ' LEFT JOIN gnsystem' +
                       ' ON (fofrate.TrDt = gnsystem.FOPrd)' +
                       ' WHERE (fofrate.TrDt = gnsystem.FOPrd)' +
                       //' WHERE fofrate.TrDt = fofrsv.ArrDt' +
                       ' group by fofrsv.RsvNo' +
                       ' Order by fofrsv.RoomNo Asc, fofrsv.RsvSt Desc,  fofrsv.RsvNo Asc';
}


      GuestRateQuery1 = 'SELECT fofrsv.Rsvno ,(sum(fofrate.AmtRvn)+sum(fofrate.AmtSvchg)+sum(fofrate.AmtTax)) as Sales_Nett' +
                        ' FROM fofrsv' +
                        ' LEFT JOIN fofrate ON (fofrate.RsvNo = fofrsv.RsvNo)' +
                        ' LEFT JOIN gnsystem ON (fofrate.TrDt = gnsystem.FOPrd)' +
                        ' WHERE fofrate.TrDt = fofrsv.ArrDt ' +
                        ' group by fofrsv.RsvNo Order by fofrsv.RsvNo Asc, fofrsv.RoomNo Asc, fofrsv.RsvSt Desc';
      
      {
      GuestRateQuery2 = 'SELECT fofrsv.Rsvno ,((fofrate.AmtRvn)+(fofrate.AmtSvchg)+(fofrate.AmtTax)) as Sales_Nett' +
                        ' FROM fofrsv' +
                        ' LEFT JOIN fofrate ON (fofrate.RsvNo = fofrsv.RsvNo)' +
                        ' LEFT JOIN gnsystem ON (fofrate.TrDt = gnsystem.FOPrd)' +
                        ' group by fofrsv.RsvNo Order by fofrsv.RsvNo Asc, fofrsv.RoomNo Asc, fofrsv.RsvSt Desc';

      }
      RoomStQuery =  'select roomno,CONCAT(fosroom.roomsthk1,fosroom.roomsthk2,fosroom.roomsthk3) as rmst from fosroom order by roomno';

      ProductCardQuery = 'select (@x := @x + 1) as rw, (@x-1) as rb,a.trdt, a.prodcd, a.trno,'+
                         ' IF(a.whfr = '''',a.whto,a.whfr) as whcd, a.unit, (a.TotalAftDisc/(a.Qty-a.QtyOut)) as UnitPrice' +
                         ' , a.Unitamt, @beg := case @x-1	when 0 then (select sum(qtybeg) as qtybeg from glfprodbal b where b.prodcd=a.prodcd and b.whcd = whcd and b.prd = extract(year_month from a.trdt))' +
                         '	else @ending' +
                         '  end as beg, a.Qty as QtyIn, a.QtyOut, @ending := @beg + a.Qty - a.QtyOut as ending, (a.Qty-a.QtyOut) as QtyDiff' +
                         ' , @begamt = case@x-1 when 0 then (select sum(amtbeg) as amtbeg from glfprodbal b where b.prodcd=a.prodcd and b.whcd = whcd and b.prd = extract(year_month from a.trdt))' +
                         '  else @endamt end as begamt' +
                         ' , a.LDbAmt, a.LCrAmt, @endamt = (a.LDbAmt-a.LCrAmt) as Amount' +
                         ' , (Case a.trtpcd when ''7010'' then ''Rcv'' when ''7020'' then ''SR'' when ''7030'' then ''TrfWh'' when ''7040'' then ''TrfExp'' when ''7050'' then ''StTake'' when ''7081'' then ''RtnRcv'' when ''7082'' then ''RtnSR'' end) as TrTpDesc1' +
                         ', (Case a.trtpcd when ''7010'' then ''Purch'' when ''7020'' then ''SR'' when ''7030'' then ''TrfWh'' when ''7040'' then ''TrfExp'' when ''7050'' then ''ST'' when ''7081'' then ''Purch'' when ''7082'' then ''SR'' end) as TrTpDesc2' +
                         ', a.ID from glftrdt a,(select @x = 0) r where a.active=1 and (a.whfr <>'''' or a.whto <>'''') and (whto=''@wwhto'' or whfr=''@wwhfr'')'+
                         ' and a.prodcd=''@prodcd'' order by whcd,prodcd,trdt,trno';

      DSNReport  = 'Provider=MSDASQL.1;Password=AlfamartSerayu123;Persist Security Info=True;User ID=apps;Data Source=emerald;Extended Properties="DSN=emerald;UID=apps;PWD=AlfamartSerayu123;"';




var ReportDirGen : String;
    pscdrm : String;
    GLEntryNext : Boolean;
    isCopyRsv : Boolean;
    sHostName : String;
    sSuspendCoa : String;
    ARAPtrtpcd,ARAPcompsupcd : String;
    CBInOuttrtpcd : String;
    sDefaultCurr : String;
    currentWaiterCd : String;
    sPrfCd : String;

implementation

uses dbfunc, fofunc, genfunc, Unit2;

end.
