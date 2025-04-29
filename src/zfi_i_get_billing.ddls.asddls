@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get billing without item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_GET_BILLING as select distinct from I_BillingDocument as bill
     left outer join I_BillingDocumentItem as item on item.BillingDocument = bill.BillingDocument
{
    key bill.BillingDocument,
    key item.ReferenceSDDocument,
    bill.BillingDocumentIsCancelled
}where bill.BillingDocumentIsCancelled = ' ' and bill.CancelledBillingDocument  = ' '

