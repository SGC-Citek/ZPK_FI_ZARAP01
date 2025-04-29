@EndUserText.label: 'Báo cáo chi tiết công nợ phải thu phải trả'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_FI_SOCTCN'
//@UI: {
//    headerInfo: {
//        typeName: 'Báo cáo tổng hợp công nợ',
//        typeNamePlural: 'Báo cáo tổng hợp công nợ',
//        title: {
//            type: #STANDARD,
//            label: 'Báo cáo tổng hợp công nợ'
//        }
//    }
//}
//
define root custom entity ZFI_I_SOCHITIETCONGNO_CUS
  with parameters
    @Consumption.valueHelpDefinition: [{ entity: {
    name: 'ZFI_I_DISPLAY',
    element: 'value_low'
    } }]
    @EndUserText.label: 'Hiển thị theo'
    onDisplay               : zde_fi_display,


    @Consumption.valueHelpDefinition: [{ entity: {
    name: 'ZFI_I_BOOLEAN_SVH',
    element: 'value_low'
    } }]
    @EndUserText.label: 'Include Reversed Documents'
    IncludeReversedDocument : zde_yesno,


    @Consumption.valueHelpDefinition: [{ entity: {
    name: 'ZFI_I_BOOLEAN_SVH',
    element: 'value_low'
    } }]
    @EndUserText.label: 'Chứng từ cấn trừ'
    DocTypes                : zde_yesno,


    @EndUserText.label: 'Ngày in'
    @Consumption.valueHelpDefinition: [{ entity: {
    name: 'ZFI_I_PRINT',
    element: 'value_low'
    } }]
    printDate               : zde_fi_show_hide,

    @Environment.systemField:#SYSTEM_DATE
    @EndUserText.label: 'Từ ngày'
    fromDate                : vdm_v_key_date,

    @Environment.systemField:#SYSTEM_DATE
    @EndUserText.label: 'Đến ngày'
    toDate                  : vdm_v_key_date,

    @Consumption.valueHelpDefinition: [{ entity: {
    name: 'ZFI_I_OPTION_IN_SVH',
    element: 'value_low'
    } }]
    @EndUserText.label: 'Loại mẫu báo cáo'
    Opt                     : zde_opt_in_soctcn,

    @Consumption.valueHelpDefinition: [{ entity: {
    name: 'ZFI_I_BOOLEAN_SVH',
    element: 'value_low'
    } }]
    @EndUserText.label: 'Tính tổng theo tài khoản'
    SumTK                   : zde_yesno
{
  key AccountingDocument             : abap.char( 10 ); // Số chứng từ

      @UI                            : {
           selectionField            : [{ position: 10 }]}
      @Consumption.filter            : {selectionType: #SINGLE, mandatory: true}
      @Consumption.valueHelpDefinition:[{ entity: {
          name                       : 'I_CompanyCode',
          element                    : 'CompanyCode'} }]
  key CompanyCode                    : abap.char( 4 );

      @UI                            : {
           selectionField            : [{ position: 20 }]}
      @Consumption.filter            : {selectionType: #SINGLE, mandatory: true }
  key FiscalYear                     : abap.numc( 4 );
  key LedgerGLLineItem               : abap.char( 6 );

      PostingDate                    : abap.dats;       // Ngày ghi sổ
      FiscalPeriod                   : abap.numc( 3 );

      @UI                            : {
           selectionField            : [{ position: 30 }]}
      @Consumption.filter            : {multipleSelections: true,selectionType: #RANGE}
      @Consumption.valueHelpDefinition:[{ entity: {
          name                       : 'I_GLAccount',
          element                    : 'GLAccount'
      } }]
      GLAccount                      : abap.char( 10 ); // Tài khoản

      GLAccountLongName              : abap.char( 50 ); // Name Tài khoản

      //      @UI                            : {
      //           selectionField            : [{ position: 40 }]}
      //      //      @Consumption.filter            : {multipleSelections: true,selectionType: #RANGE}
      //      @Consumption.valueHelpDefinition:[ {
      //      entity                         :{
      //      name                           :'ZI_FI_CUSTOMER_SUPPLIER_VH',
      //      element                        :'BusinessPartner' },
      //      additionalBinding              : [
      //      {element                       : 'BusinessPartnerGrouping', localElement: 'AccountGroup', usage: #FILTER_AND_RESULT}
      //      ]
      //      }]
      @EndUserText.label             : 'Mã khách hàng / Nhà cung cấp'
      cus_sup                        : kunnr; // Khách hàng/ Nhà cung cấp

      //      @UI                            : {
      //           selectionField            : [{ position: 50 }]}
      //      @Consumption.filter            : {multipleSelections: true,selectionType: #RANGE}
      //      @Consumption.valueHelpDefinition:[{ entity: { name : 'ZI_FI_ACCOUNT_GROUP_VH', element : 'AccountGroup'} }]
      //      @EndUserText.label             : 'Account Group'
      AccountGroup                   : ktokd; // Account Group


      FinancialAccountType           : abap.char( 1 );  // D là Customer, K là Supplier
      AccountingDocumentCreationDate : abap.dats;       // Ngày lập
      DocumentReferenceID            : abap.char( 16 ); // Số hoá đơn
      AccountingDocumentType         : abap.char( 2 );  // Loại chứng từ
      dien_giai                      : abap.char( 50 ); // Diễn giải
      tk_doi_ung                     : abap.char( 100 ); // TK đối ứng

      @EndUserText.label             : 'Currency'
      @Consumption.filter            : {selectionType: #RANGE, mandatory: true}
      @Consumption.valueHelpDefinition:[{ entity: {
        name                         : 'ZFI_I_Currency_SVH',
        element                      : 'Currency'
        } }]
      TransactionCurrency            : waers;
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      amount_foreign_no              : abap.curr( 25 , 2 ); //phát sinh nợ ngoại tệ
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      amount_foreign_co              : abap.curr( 25 , 2 ); //phát sinh có ngoại tệ

      CompanyCodeCurrency            : waers;
      @Semantics.amount.currencyCode : 'CompanyCodeCurrency'
      amount_local_no                : abap.curr( 25 , 2 ); //phát sinh nợ VND
      @Semantics.amount.currencyCode : 'CompanyCodeCurrency'
      amount_local_co                : abap.curr( 25 , 2 ); //phát sinh có VND

      //    ti_gia                   : abap.char( 1 );
      ti_gia                         : abap.dec( 9, 5 );
      accounttypename                : abap.char( 100 );
      DebitCreditCode                : abap.char( 1 );

      //VND
      @Semantics.amount.currencyCode : 'CompanyCodeCurrency'
      tondauky_no_vnd                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'CompanyCodeCurrency'
      tondauky_co_vnd                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'CompanyCodeCurrency'
      phatsinh_no_vnd                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'CompanyCodeCurrency'
      phatsinh_co_vnd                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'CompanyCodeCurrency'
      ducuoiky_no_vnd                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'CompanyCodeCurrency'
      ducuoiky_co_vnd                : abap.curr( 25 , 2 );

      //USD
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      tondauky_no_usd                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      tondauky_co_usd                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      phatsinh_no_usd                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      phatsinh_co_usd                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      ducuoiky_no_usd                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      ducuoiky_co_usd                : abap.curr( 25 , 2 );

      @Semantics.amount.currencyCode : 'companyCodeCurrency'
      tondauky_no_usd_companyCode    : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'companyCodeCurrency'
      tondauky_co_usd_companyCode    : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'companyCodeCurrency'
      phatsinh_no_usd_companyCode    : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'companyCodeCurrency'
      phatsinh_co_usd_companyCode    : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'companyCodeCurrency'
      ducuoiky_no_usd_companyCode    : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'companyCodeCurrency'
      ducuoiky_co_usd_companyCode    : abap.curr( 25 , 2 );



      //EUR
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      tondauky_no_eur                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      tondauky_co_eur                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      phatsinh_no_eur                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      phatsinh_co_eur                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      ducuoiky_no_eur                : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      ducuoiky_co_eur                : abap.curr( 25 , 2 );

      @Semantics.amount.currencyCode : 'companyCodeCurrency'
      tondauky_no_eur_companyCode    : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'companyCodeCurrency'
      tondauky_co_eur_companyCode    : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'companyCodeCurrency'
      phatsinh_no_eur_companyCode    : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'companyCodeCurrency'
      phatsinh_co_eur_companyCode    : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'companyCodeCurrency'
      ducuoiky_no_eur_companyCode    : abap.curr( 25 , 2 );
      @Semantics.amount.currencyCode : 'companyCodeCurrency'
      ducuoiky_co_eur_companyCode    : abap.curr( 25 , 2 );

      //    fromdatePrint               : abap.dats;
      //    todatePrint                 : abap.dats;

      isLevel                        : abap.char( 1 ); // is 0: items, 1: subtotal, 2: total

      IsNegativePosting              : abap.char(1);

      isexistinperiod                : abap.char(1);

}
