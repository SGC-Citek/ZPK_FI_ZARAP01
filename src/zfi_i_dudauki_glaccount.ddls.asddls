@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum dư đầu kì theo GLAccount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_DUDAUKI_GLACCOUNT
  with parameters
    onDisplay : zde_fi_display,
    @Environment.systemField:#SYSTEM_DATE
    fromDate  : vdm_v_key_date,
    curr      : waers
  as select from    I_OperationalAcctgDocItem as Item
    left outer join ZCORE_I_PROFILE_FIDOC     as AccountProfile on  AccountProfile.AccountingDocument     = Item.AccountingDocument
                                                                and AccountProfile.AccountingDocumentItem = Item.AccountingDocumentItem
                                                                and AccountProfile.CompanyCode            = Item.CompanyCode
                                                                and AccountProfile.FiscalYear             = Item.FiscalYear
{

  key  Item.CompanyCode,
  key  AccountProfile.Account                           as AcountType,
  key  Item.GLAccount,
       Item.FinancialAccountType,

       Item.TransactionCurrency,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
       case when Item.TransactionCurrency = Item.CompanyCodeCurrency
         then sum(Item.AmountInCompanyCodeCurrency)
            when Item.TransactionCurrency <> Item.CompanyCodeCurrency
         then sum(Item.AmountInTransactionCurrency) end as sumDuDauKiGL
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
  and(
       Item.TransactionCurrency  = $parameters.curr
  )
  and(
       Item.SpecialGLCode        = ''
    or Item.SpecialGLCode        = 'A'
  )
group by
  Item.CompanyCode,
  AccountProfile.Account,
  Item.FinancialAccountType,
  Item.TransactionCurrency,
  Item.GLAccount,
  Item.CompanyCodeCurrency
