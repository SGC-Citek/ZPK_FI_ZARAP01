@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help Customer or Supplier'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_CUS_SUP_SVH 
    as select distinct from ZCORE_I_PROFILE_FIDOC
{   
    @EndUserText.label: 'Customer/Supplier'
    key Account,
    
    @EndUserText.label: 'Customer/Supplier Name'
    AccountnName
}
