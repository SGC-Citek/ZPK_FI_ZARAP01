@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tài khoản đối đứng'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_TKDOIUNG_GLACCOUNT
  as select from    I_GLAccountLineItem as itemGoc
    left outer join I_GLAccountLineItem as itemTKDOIUNG on  itemGoc.SourceLedger       = itemTKDOIUNG.SourceLedger
                                                        and itemGoc.CompanyCode        = itemTKDOIUNG.CompanyCode
                                                        and itemGoc.FiscalYear         = itemTKDOIUNG.FiscalYear
                                                        and itemGoc.AccountingDocument = itemTKDOIUNG.AccountingDocument
                                                        and itemGoc.Ledger             = itemTKDOIUNG.Ledger
                                                        and itemGoc.LedgerGLLineItem   = itemTKDOIUNG.OffsettingLedgerGLLineItem
{
  key itemGoc.AccountingDocument,
  key itemGoc.SourceLedger,
  key itemGoc.CompanyCode,
  key itemGoc.FiscalYear,
  key itemGoc.Ledger,
  key itemGoc.LedgerGLLineItem,

      itemGoc.GLAccount                                  as TKGoc,
      //    itemTKDOIUNG.GLAccount as TKDoiUng,
      cast( itemTKDOIUNG.GLAccount as abap.char( 100 ) ) as TKDoiUng,
      itemTKDOIUNG.LedgerGLLineItem                      as LedgerGLLineItem_TKDoiUng,
      itemTKDOIUNG.FinancialAccountType                  as FinancialAccountType_DoiUng
}
where
  itemGoc.Ledger = '0L'
