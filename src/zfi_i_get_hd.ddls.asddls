@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'lấy hóa đơn cho ctu xuất kho'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_GET_HD as select distinct from I_JournalEntryItem as item
    inner join ZFI_I_GET_MATERIAL as md on md.MaterialDocument = item.ReferenceDocument

    inner join ZFI_I_GET_BILLING as bi on bi.ReferenceSDDocument = md.DeliveryDocument

    inner join I_JournalEntry as Journal on Journal.OriginalReferenceDocument = bi.BillingDocument
                                         and Journal.DocumentReferenceID <> bi.BillingDocument 
     
{
   key item.AccountingDocument, 
   key item.CompanyCode,
   key item.FiscalYear,
   key item.LedgerGLLineItem,
   bi.BillingDocument,
   Journal.DocumentReferenceID,
   item.ReferenceDocument,
   md.DeliveryDocument,
   bi.BillingDocumentIsCancelled,
   item.AccountingDocumentType
}
