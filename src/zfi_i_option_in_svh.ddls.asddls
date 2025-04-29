@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help Option In'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZFI_I_OPTION_IN_SVH 
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDO_OPT_IN_SOCTCN' )
{
  @ObjectModel.text.element:[ 'text' ]
  key    value_low,
         text
}
