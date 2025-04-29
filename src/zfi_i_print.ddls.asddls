@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS lấy domain value print date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZFI_I_PRINT
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDE_FI_SHOW_HIDE' )
{
  key domain_name,
  key value_position,
      @Semantics.language: true
  key language,
      @ObjectModel.text.element:[ 'text' ]
      value_low,
      text
}
