object dm: Tdm
  OldCreateOrder = False
  Height = 396
  Width = 491
  object mySQL1: TSQLConnection
    DriverName = 'dbxmysql'
    GetDriverFunc = 'getSQLDriverMYSQL50'
    LibraryName = 'dbxopenmysql50.dll'
    LoginPrompt = False
    Params.Strings = (
      'Database=emerald'
      'User_Name=apps'
      'Password=AlfamartSerayu123'
      'HostName=192.168.0.68')
    VendorLib = 'libmysql.dll'
    Left = 16
    Top = 80
  end
  object gnsys: TSimpleDataSet
    Aggregates = <>
    Connection = mySQL1
    DataSet.CommandText = 'select * from gnsystem'
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 80
    Top = 184
  end
  object dsgnsys: TDataSource
    DataSet = gnsys
    Left = 160
    Top = 184
  end
  object fosroom: TSimpleDataSet
    Aggregates = <>
    Connection = mySQL1
    DataSet.CommandText = 
      'select roomno,roomtpcd,roomstfo1,roomstfo2,roomstfo3,roomsthk1,r' +
      'oomsthk2,roomsthk3 from fosroom'
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 232
    Top = 184
  end
  object TheDatax: TSimpleDataSet
    Aggregates = <>
    Connection = mySQL1
    DataSet.CommandText = 'SELECT * FROM fofrsv'
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 312
    Top = 200
    object TheDataxRsvNo: TStringField
      FieldName = 'RsvNo'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object TheDataxRsvNm: TStringField
      FieldName = 'RsvNm'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object TheDataxArrDt: TDateField
      FieldName = 'ArrDt'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxDepDt: TDateField
      FieldName = 'DepDt'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxRoomNo: TStringField
      FieldName = 'RoomNo'
      ProviderFlags = [pfInUpdate]
      Size = 6
    end
    object TheDataxRsvSt: TStringField
      FieldName = 'RsvSt'
      ProviderFlags = [pfInUpdate]
      Size = 1
    end
    object TheDataxBillNo: TStringField
      FieldName = 'BillNo'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxHistoryNo: TStringField
      FieldName = 'HistoryNo'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object TheDataxRsvTp: TStringField
      FieldName = 'RsvTp'
      ProviderFlags = [pfInUpdate]
      Size = 1
    end
    object TheDataxComplFl: TStringField
      FieldName = 'ComplFl'
      ProviderFlags = [pfInUpdate]
      Size = 1
    end
    object TheDataxDeptCd: TStringField
      FieldName = 'DeptCd'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
    object TheDataxGrpCd: TStringField
      FieldName = 'GrpCd'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
    object TheDataxRsvBy: TStringField
      FieldName = 'RsvBy'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object TheDataxSexCd: TStringField
      FieldName = 'SexCd'
      ProviderFlags = [pfInUpdate]
      Size = 10
    end
    object TheDataxVipCd: TStringField
      FieldName = 'VipCd'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
    object TheDataxNights: TIntegerField
      FieldName = 'Nights'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxAdult: TSmallintField
      FieldName = 'Adult'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxChild: TSmallintField
      FieldName = 'Child'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxExBedQty: TSmallintField
      FieldName = 'ExBedQty'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxRoomTpCd: TStringField
      FieldName = 'RoomTpCd'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
    object TheDataxBedCd: TStringField
      FieldName = 'BedCd'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
    object TheDataxSmkTp: TSmallintField
      FieldName = 'SmkTp'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxRateTp: TSmallintField
      FieldName = 'RateTp'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxRateCtg: TStringField
      FieldName = 'RateCtg'
      ProviderFlags = [pfInUpdate]
      Size = 1
    end
    object TheDataxRateCurrCd: TStringField
      FieldName = 'RateCurrCd'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
    object TheDataxRateCd: TStringField
      FieldName = 'RateCd'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
    object TheDataxRateAmt: TBCDField
      FieldName = 'RateAmt'
      ProviderFlags = [pfInUpdate]
      Precision = 11
      Size = 0
    end
    object TheDataxRateUpdtFl: TStringField
      FieldName = 'RateUpdtFl'
      ProviderFlags = [pfInUpdate]
      Size = 1
    end
    object TheDataxExBedAmt: TBCDField
      FieldName = 'ExBedAmt'
      ProviderFlags = [pfInUpdate]
      Precision = 11
      Size = 0
    end
    object TheDataxComission: TBCDField
      FieldName = 'Comission'
      ProviderFlags = [pfInUpdate]
      Precision = 11
      Size = 0
    end
    object TheDataxPymtMthd: TStringField
      FieldName = 'PymtMthd'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
    object TheDataxPymtIns: TStringField
      FieldName = 'PymtIns'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
    object TheDataxOutletLock: TStringField
      FieldName = 'OutletLock'
      ProviderFlags = [pfInUpdate]
      Size = 1
    end
    object TheDataxPhoneLock: TStringField
      FieldName = 'PhoneLock'
      ProviderFlags = [pfInUpdate]
      Size = 1
    end
    object TheDataxGrntTp: TStringField
      FieldName = 'GrntTp'
      ProviderFlags = [pfInUpdate]
      Size = 1
    end
    object TheDataxGrntDt: TDateField
      FieldName = 'GrntDt'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxVchNo: TStringField
      FieldName = 'VchNo'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxCardCd: TStringField
      FieldName = 'CardCd'
      ProviderFlags = [pfInUpdate]
      Size = 10
    end
    object TheDataxCardNo: TStringField
      FieldName = 'CardNo'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object TheDataxCardNm: TStringField
      FieldName = 'CardNm'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object TheDataxCardExp: TDateField
      FieldName = 'CardExp'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxDpCurrCd: TStringField
      FieldName = 'DpCurrCd'
      ProviderFlags = [pfInUpdate]
      Size = 10
    end
    object TheDataxDpAmt: TBCDField
      FieldName = 'DpAmt'
      ProviderFlags = [pfInUpdate]
      Precision = 11
      Size = 0
    end
    object TheDataxDpDt: TDateField
      FieldName = 'DpDt'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxDpPaid: TBCDField
      FieldName = 'DpPaid'
      ProviderFlags = [pfInUpdate]
      Precision = 11
      Size = 0
    end
    object TheDataxCompCd: TStringField
      FieldName = 'CompCd'
      ProviderFlags = [pfInUpdate]
      Size = 10
    end
    object TheDataxCompDesc: TStringField
      FieldName = 'CompDesc'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object TheDataxMktSegCd: TStringField
      FieldName = 'MktSegCd'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
    object TheDataxSob1Cd: TStringField
      FieldName = 'Sob1Cd'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
    object TheDataxSob2Cd: TStringField
      FieldName = 'Sob2Cd'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
    object TheDataxPovCd: TStringField
      FieldName = 'PovCd'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
    object TheDataxBookerCd: TStringField
      FieldName = 'BookerCd'
      ProviderFlags = [pfInUpdate]
      Size = 10
    end
    object TheDataxBookerNo: TStringField
      FieldName = 'BookerNo'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxPhone: TStringField
      FieldName = 'Phone'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxSlsCd: TStringField
      FieldName = 'SlsCd'
      ProviderFlags = [pfInUpdate]
      Size = 10
    end
    object TheDataxHistoryTp: TStringField
      FieldName = 'HistoryTp'
      ProviderFlags = [pfInUpdate]
      Size = 1
    end
    object TheDataxEArrDtl: TStringField
      FieldName = 'EArrDtl'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object TheDataxEArrTm: TSQLTimeStampField
      FieldName = 'EArrTm'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxEArrTrans: TSmallintField
      FieldName = 'EArrTrans'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxEDeptDtl: TStringField
      FieldName = 'EDeptDtl'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object TheDataxEDeptTm: TSQLTimeStampField
      FieldName = 'EDeptTm'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxEDeptTrans: TSmallintField
      FieldName = 'EDeptTrans'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxRemark: TStringField
      FieldName = 'Remark'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object TheDataxCreateDt: TDateField
      FieldName = 'CreateDt'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxCreateTm: TSQLTimeStampField
      FieldName = 'CreateTm'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxCreateUser: TStringField
      FieldName = 'CreateUser'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object TheDataxCiDt: TDateField
      FieldName = 'CiDt'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxCiTm: TSQLTimeStampField
      FieldName = 'CiTm'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxCiUser: TStringField
      FieldName = 'CiUser'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object TheDataxUpdateDt: TDateField
      FieldName = 'UpdateDt'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxUpdateTm: TSQLTimeStampField
      FieldName = 'UpdateTm'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxUpdateUser: TStringField
      FieldName = 'UpdateUser'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object TheDataxCoDt: TDateField
      FieldName = 'CoDt'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxCoTm: TSQLTimeStampField
      FieldName = 'CoTm'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxCoUser: TStringField
      FieldName = 'CoUser'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object TheDataxCanStDt: TDateField
      FieldName = 'CanStDt'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxCanStTm: TSQLTimeStampField
      FieldName = 'CanStTm'
      ProviderFlags = [pfInUpdate]
    end
    object TheDataxCanStUser: TStringField
      FieldName = 'CanStUser'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object TheDataxCanStRsn: TStringField
      FieldName = 'CanStRsn'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object TheDataxNotes: TStringField
      FieldName = 'Notes'
      ProviderFlags = [pfInUpdate]
      Size = 200
    end
    object TheDataxTimeLimit: TStringField
      FieldName = 'TimeLimit'
      ProviderFlags = [pfInUpdate]
      Size = 5
    end
  end
  object dummytables: TSimpleDataSet
    Aggregates = <>
    Connection = mySQL1
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 256
    Top = 88
    object dummytablesdummyfield: TStringField
      FieldName = 'dummyfield'
      Size = 10
    end
    object dummytablesarrdt: TDateField
      FieldName = 'arrdt'
    end
    object dummytablesnight: TIntegerField
      FieldName = 'night'
    end
    object dummytablesdepdt: TDateField
      FieldName = 'depdt'
    end
    object dummytablesdummyfield2: TStringField
      FieldName = 'dummyfield2'
      Size = 10
    end
    object dummytablesdummyfield3: TStringField
      FieldName = 'dummyfield3'
    end
    object dummytablesdummyfield4: TStringField
      FieldName = 'dummyfield4'
    end
    object dummytablesdummyfield5: TStringField
      FieldName = 'dummyfield5'
    end
    object dummytablesdummyfield6: TStringField
      FieldName = 'dummyfield6'
    end
    object dummytablesdummyfield7: TStringField
      FieldName = 'dummyfield7'
    end
    object dummytablesdummyfield8: TStringField
      FieldName = 'dummyfield8'
    end
  end
  object mySQL2: TSQLConnection
    DriverName = 'dbxmysql'
    GetDriverFunc = 'getSQLDriverMYSQL50'
    LibraryName = 'dbxopenmysql50.dll'
    LoginPrompt = False
    Params.Strings = (
      'Database=emerald'
      'User_Name=root'
      'Password=toor'
      'HostName=localhost')
    VendorLib = 'libmysql.dll'
    Left = 16
    Top = 168
  end
end
