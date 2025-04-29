@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy thông tin cus và vendor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_CUS_VEN as select from I_OperationalAcctgDocItem as Item
            left outer join I_Customer as Cus on Cus.Customer = Item.Customer
            left outer join I_Supplier as Sup on Sup.Supplier = Item.Supplier
{
    key Item.AccountingDocument,
    key Item.CompanyCode,
    key Item.FiscalYear,
    key Item.AccountingDocumentItem,
    Cus.Customer,
    Sup.Supplier,
    Item.FinancialAccountType,
    
    case when (Cus.BusinessPartnerName2 <> '' or Cus.BusinessPartnerName3 <> '' or Cus.BusinessPartnerName4 <> '') and Item.FinancialAccountType = 'D'
        then concat_with_space(concat_with_space(Cus.BusinessPartnerName2, Cus.BusinessPartnerName3, 1), Cus.BusinessPartnerName4, 1)
     else
        Cus.BusinessPartnerName1 end as CustomerName,
    
    case when (Sup.BusinessPartnerName2 <> '' or Sup.BusinessPartnerName2 <> '' or Sup.BusinessPartnerName3 <> '' or Sup.BusinessPartnerName4 <> '') and Item.FinancialAccountType = 'K'
        then concat_with_space(concat_with_space(Sup.BusinessPartnerName2, Sup.BusinessPartnerName3, 1),Sup.BusinessPartnerName4, 1)
      else
      Sup.BusinessPartnerName1 end as SupplierName
}where (Item.FinancialAccountType = 'D' or Item.FinancialAccountType = 'K')
