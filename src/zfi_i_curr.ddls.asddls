@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Get Currency'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_CURR
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDO_CATEGORY_CURRENCY' )
{
  key domain_name,
  key value_position,
      @Semantics.language: true
  key language,
      @ObjectModel.text.element:[ 'text' ]
      value_low,
      text
}
