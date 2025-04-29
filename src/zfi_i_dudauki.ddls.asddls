@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum dư đầu kì'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_DUDAUKI
  with parameters
    onDisplay : zde_fi_display,
    @Environment.systemField:#SYSTEM_DATE
    fromDate  : vdm_v_key_date
  as select from    I_OperationalAcctgDocItem as Item
    left outer join ZCORE_I_PROFILE_FIDOC     as AccountProfile on  AccountProfile.AccountingDocument     = Item.AccountingDocument
                                                                and AccountProfile.AccountingDocumentItem = Item.AccountingDocumentItem
                                                                and AccountProfile.CompanyCode            = Item.CompanyCode
                                                                and AccountProfile.FiscalYear             = Item.FiscalYear

{

  key  Item.CompanyCode,
  key  AccountProfile.Account                            as AcountType,
       Item.FinancialAccountType,
       Item.TransactionCurrency,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
       case when Item.TransactionCurrency = Item.CompanyCodeCurrency
          then sum(Item.AmountInCompanyCodeCurrency)
             when Item.TransactionCurrency <> Item.CompanyCodeCurrency
          then sum(Item.AmountInTransactionCurrency) end as sumDuDauKi
}
where
  (
       $parameters.onDisplay     = 'B'
    or(
       Item.FinancialAccountType = $parameters.onDisplay
    )
  )
  and(
       $parameters.fromDate      > Item.DocumentDate
  )
  //  and(
  //       Item.TransactionCurrency  = $parameters.curr
  //  )
  and(
       Item.SpecialGLCode        = ''
    or Item.SpecialGLCode        = 'A'
  ) //and (Item.TransactionCurrency = $parameters.curr)
group by
  Item.CompanyCode,
  AccountProfile.Account,
  Item.FinancialAccountType,
  Item.TransactionCurrency,
  Item.CompanyCodeCurrency
