unit Unit2;

interface

uses
  SysUtils, Classes, DBXpress, WideStrings, DB, SqlExpr, DBClient, SimpleDS,dialogs;

type
  Tdm = class(TDataModule)
    mySQL1: TSQLConnection;
    gnsys: TSimpleDataSet;
    dsgnsys: TDataSource;
    fosroom: TSimpleDataSet;
    TheDatax: TSimpleDataSet;
    TheDataxRsvNo: TStringField;
    TheDataxRsvNm: TStringField;
    TheDataxArrDt: TDateField;
    TheDataxDepDt: TDateField;
    TheDataxRoomNo: TStringField;
    TheDataxRsvSt: TStringField;
    TheDataxBillNo: TStringField;
    TheDataxHistoryNo: TStringField;
    TheDataxRsvTp: TStringField;
    TheDataxComplFl: TStringField;
    TheDataxDeptCd: TStringField;
    TheDataxGrpCd: TStringField;
    TheDataxRsvBy: TStringField;
    TheDataxSexCd: TStringField;
    TheDataxVipCd: TStringField;
    TheDataxNights: TIntegerField;
    TheDataxAdult: TSmallintField;
    TheDataxChild: TSmallintField;
    TheDataxExBedQty: TSmallintField;
    TheDataxRoomTpCd: TStringField;
    TheDataxBedCd: TStringField;
    TheDataxSmkTp: TSmallintField;
    TheDataxRateTp: TSmallintField;
    TheDataxRateCtg: TStringField;
    TheDataxRateCurrCd: TStringField;
    TheDataxRateCd: TStringField;
    TheDataxRateAmt: TBCDField;
    TheDataxRateUpdtFl: TStringField;
    TheDataxExBedAmt: TBCDField;
    TheDataxComission: TBCDField;
    TheDataxPymtMthd: TStringField;
    TheDataxPymtIns: TStringField;
    TheDataxOutletLock: TStringField;
    TheDataxPhoneLock: TStringField;
    TheDataxGrntTp: TStringField;
    TheDataxGrntDt: TDateField;
    TheDataxVchNo: TStringField;
    TheDataxCardCd: TStringField;
    TheDataxCardNo: TStringField;
    TheDataxCardNm: TStringField;
    TheDataxCardExp: TDateField;
    TheDataxDpCurrCd: TStringField;
    TheDataxDpAmt: TBCDField;
    TheDataxDpDt: TDateField;
    TheDataxDpPaid: TBCDField;
    TheDataxCompCd: TStringField;
    TheDataxCompDesc: TStringField;
    TheDataxMktSegCd: TStringField;
    TheDataxSob1Cd: TStringField;
    TheDataxSob2Cd: TStringField;
    TheDataxPovCd: TStringField;
    TheDataxBookerCd: TStringField;
    TheDataxBookerNo: TStringField;
    TheDataxPhone: TStringField;
    TheDataxSlsCd: TStringField;
    TheDataxHistoryTp: TStringField;
    TheDataxEArrDtl: TStringField;
    TheDataxEArrTm: TSQLTimeStampField;
    TheDataxEArrTrans: TSmallintField;
    TheDataxEDeptDtl: TStringField;
    TheDataxEDeptTm: TSQLTimeStampField;
    TheDataxEDeptTrans: TSmallintField;
    TheDataxRemark: TStringField;
    TheDataxCreateDt: TDateField;
    TheDataxCreateTm: TSQLTimeStampField;
    TheDataxCreateUser: TStringField;
    TheDataxCiDt: TDateField;
    TheDataxCiTm: TSQLTimeStampField;
    TheDataxCiUser: TStringField;
    TheDataxUpdateDt: TDateField;
    TheDataxUpdateTm: TSQLTimeStampField;
    TheDataxUpdateUser: TStringField;
    TheDataxCoDt: TDateField;
    TheDataxCoTm: TSQLTimeStampField;
    TheDataxCoUser: TStringField;
    TheDataxCanStDt: TDateField;
    TheDataxCanStTm: TSQLTimeStampField;
    TheDataxCanStUser: TStringField;
    TheDataxCanStRsn: TStringField;
    TheDataxNotes: TStringField;
    TheDataxTimeLimit: TStringField;
    dummytables: TSimpleDataSet;
    dummytablesdummyfield: TStringField;
    dummytablesarrdt: TDateField;
    dummytablesnight: TIntegerField;
    dummytablesdepdt: TDateField;
    dummytablesdummyfield2: TStringField;
    mySQL2: TSQLConnection;
    dummytablesdummyfield3: TStringField;
    dummytablesdummyfield4: TStringField;
    dummytablesdummyfield5: TStringField;
    dummytablesdummyfield6: TStringField;
    dummytablesdummyfield7: TStringField;
    dummytablesdummyfield8: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
    HostName : String;
    UserLevel : Integer;
    UserID    : String;
    UserName  : String;
    DBNm      : String;
    foprd     : TDateTime;
    gCurrCd   : String;
    defWidth  : Integer;
    defHeight : Integer;
    GuestLedgerCOA : String;
    vFoPrd     : TDateTime;
    CashierToken : String;
    CashOut : Boolean;
    prodcoa : String;
    ReportDir : String;
    MICEmode : Boolean;
    serverName : String;
    hkchangest: Boolean;
  end;
               
var
  dm: Tdm;

implementation

uses collection, dbfunc, genfunc;

{$R *.dfm}
end.
