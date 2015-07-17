object dmLib: TdmLib
  OldCreateOrder = False
  Left = 433
  Top = 273
  Height = 220
  Width = 234
  object dsFind: TDataSource
    DataSet = quFind
    Left = 134
    Top = 20
  end
  object quFind: TQuery
    DatabaseName = 'dskExmpl'
    SQL.Strings = (
      
        'SELECT B.Code_B, B.Author, B.Title, B.Avail, L.Repost, L.Stel, L' +
        '.Shelf'
      'FROM "Book.db" B, "Locality.db" L'
      'WHERE (B.Code_B = L.Code_L)'
      'AND (B.Title  = :xTitl)'
      'AND (B.Author = :xAut)')
    Left = 84
    Top = 20
    ParamData = <
      item
        DataType = ftString
        Name = 'xTitl'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'xAut'
        ParamType = ptUnknown
      end>
  end
  object quUpDat: TQuery
    DatabaseName = 'dskExmpl'
    DataSource = dsFind
    SQL.Strings = (
      'UPDATE Book SET Avail = Avail - 1'
      'WHERE Code_B = :Code_B')
    Left = 34
    Top = 20
    ParamData = <
      item
        DataType = ftSmallint
        Name = 'Code_B'
        ParamType = ptUnknown
        Size = 2
      end>
  end
  object taBook: TTable
    Active = True
    BeforeDelete = taBookBeforeDelete
    DatabaseName = 'dskExmpl'
    TableName = 'Book.db'
    Left = 36
    Top = 70
  end
  object taLocality: TTable
    Active = True
    DatabaseName = 'dskExmpl'
    IndexFieldNames = 'Code_L'
    MasterFields = 'Code_B'
    MasterSource = dsBook
    TableName = 'Locality.db'
    Left = 36
    Top = 122
  end
  object dsBook: TDataSource
    DataSet = taBook
    Left = 88
    Top = 72
  end
  object dsLocality: TDataSource
    DataSet = taLocality
    Left = 90
    Top = 122
  end
  object quInputImg: TQuery
    DatabaseName = 'dskExmpl'
    DataSource = dsBook
    Left = 176
    Top = 98
  end
end
