  METHOD IF_RAP_QUERY_PROVIDER~SELECT.
    DATA: LV_SORT_STRING TYPE STRING,
          LV_GROUPING    TYPE STRING.
    DATA: SYSTEMSTATUS     TYPE STRING,
          SYSTEMSTATUSOPER TYPE STRING.
    DATA(LT_FIELDS)        = IO_REQUEST->GET_REQUESTED_ELEMENTS( ).
    DATA(LV_TOP)           = IO_REQUEST->GET_PAGING( )->GET_PAGE_SIZE( ).
    DATA(LV_SKIP)          = IO_REQUEST->GET_PAGING( )->GET_OFFSET( ).
    DATA(LV_MAX_ROWS) = COND #( WHEN LV_TOP = IF_RAP_QUERY_PAGING=>PAGE_SIZE_UNLIMITED THEN 0
                                ELSE LV_TOP ).
    IF LV_MAX_ROWS = -1 .
      LV_MAX_ROWS = 1.
    ENDIF.
    DATA(LT_SORT)          = IO_REQUEST->GET_SORT_ELEMENTS( ).
    DATA(LT_SORT_CRITERIA) = VALUE STRING_TABLE( FOR SORT_ELEMENT IN LT_SORT
                                                     ( SORT_ELEMENT-ELEMENT_NAME && COND #( WHEN SORT_ELEMENT-DESCENDING = ABAP_TRUE
                                                                                            THEN ` descending`
                                                                                            ELSE ` ascending` ) ) ).
    DATA(LV_DEFAUTL) = 'AccountingDocument, CompanyCode, FiscalYear, LedgerGLLineItem'.
    LV_SORT_STRING  = COND #( WHEN LT_SORT_CRITERIA IS INITIAL THEN LV_DEFAUTL
                                ELSE CONCAT_LINES_OF( TABLE = LT_SORT_CRITERIA SEP = `, ` ) ).

    " get filter by parameter -----------------------
    DATA(LT_PARAMATER) = IO_REQUEST->GET_PARAMETERS( ).
    IF LT_PARAMATER IS NOT INITIAL.
      LOOP AT LT_PARAMATER REFERENCE INTO DATA(LS_PARAMETER).
        CASE LS_PARAMETER->PARAMETER_NAME.
          WHEN 'ONDISPLAY'. " D or K
            LV_KOART    = LS_PARAMETER->VALUE.
            IF LV_KOART NE 'B'.
              APPEND VALUE #( SIGN = 'I' OPTION = 'EQ' LOW = LV_KOART ) TO GR_KOART.
            ELSE.
              GR_KOART = VALUE #( SIGN = 'I' OPTION = 'EQ' ( LOW = 'K' )
                                                           ( LOW = 'D' )  ).
            ENDIF.
          WHEN 'INCLUDEREVERSEDDOCUMENT'. " YES or NO
            LV_INREV   = LS_PARAMETER->VALUE.
          WHEN 'DOCTYPES'. " YES or NO
            LV_DOCTYPE   = LS_PARAMETER->VALUE.
          WHEN 'SUMTK'. " YES or NO
            LV_SUMTK     = LS_PARAMETER->VALUE.
          WHEN 'FROMDATE'.
            LV_FROMDATE = LS_PARAMETER->VALUE.
          WHEN 'TODATE'.
            LV_TODATE   = LS_PARAMETER->VALUE.
          WHEN 'OPT'.
            LV_OPT       = LS_PARAMETER->VALUE.
        ENDCASE.
      ENDLOOP.
    ENDIF.


*    Get filter
    TRY.
        DATA(LT_FILTER_COND) = IO_REQUEST->GET_FILTER( )->GET_AS_RANGES( ).
      CATCH CX_RAP_QUERY_FILTER_NO_RANGE INTO DATA(LX_NO_SEL_OPTION).
    ENDTRY.
    LOOP AT LT_FILTER_COND REFERENCE INTO DATA(LS_FILTER_COND).
      IF LS_FILTER_COND->NAME = |{ 'CompanyCode' CASE = UPPER }|.
        GR_COMPANYCODE        = CORRESPONDING #( LS_FILTER_COND->RANGE[] ).
      ELSEIF  LS_FILTER_COND->NAME = |{ 'FiscalYear' CASE = UPPER }|.
        GR_FISCALYEAR         = CORRESPONDING #( LS_FILTER_COND->RANGE[] ).
      ELSEIF  LS_FILTER_COND->NAME = |{ 'GLAccount' CASE = UPPER }|.
        GR_GLACCOUNT          = CORRESPONDING #( LS_FILTER_COND->RANGE[] ).
      ELSEIF  LS_FILTER_COND->NAME = |{ 'cus_sup' CASE = UPPER }|.
        GR_CUS_SUP            = CORRESPONDING #( LS_FILTER_COND->RANGE[] ).
      ELSEIF  LS_FILTER_COND->NAME = |{ 'TransactionCurrency' CASE = UPPER }|.
        GR_WAERS              = CORRESPONDING #( LS_FILTER_COND->RANGE[] ).
      ELSEIF  LS_FILTER_COND->NAME = |{ 'accountgroup' CASE = UPPER }|.
        GR_ACCOUNTGROUP       = CORRESPONDING #( LS_FILTER_COND->RANGE[] ).
      ENDIF.
    ENDLOOP.


    DATA(LV_ENTITY) = IO_REQUEST->GET_ENTITY_ID(  ).
    CASE LV_ENTITY.
      WHEN 'ZFI_I_SOCHITIETCONGNO_CUS'.
        DATA: LT_DATA_OUT    TYPE TABLE OF ZFI_I_SOCHITIETCONGNO_CUS.

        IF LV_OPT = 'I' OR LV_OPT = 'T'.
          CLEAR: GR_WAERS.
          GR_WAERS = VALUE #( SIGN = 'I' OPTION = 'EQ' ( LOW = 'VND' ) ).
        ENDIF.

        GET_DATA(  ).

*        SORT gt_data by cus_sup FinancialAccountType ASCENDING isLevel DESCENDING.

        SELECT * FROM @GT_DATA AS DATA
            ORDER BY CUS_SUP, FINANCIALACCOUNTTYPE, POSTINGDATE, ACCOUNTINGDOCUMENT
            INTO TABLE @LT_DATA_OUT
            OFFSET @LV_SKIP UP TO @LV_MAX_ROWS ROWS.

        SORT LT_DATA_OUT BY CUS_SUP FINANCIALACCOUNTTYPE POSTINGDATE ACCOUNTINGDOCUMENT ASCENDING ISLEVEL DESCENDING.


        " total number of record
        IO_RESPONSE->SET_TOTAL_NUMBER_OF_RECORDS( LINES( LT_DATA_OUT ) )."
        " data actual response in screen
        IO_RESPONSE->SET_DATA( LT_DATA_OUT ).

    ENDCASE.

  ENDMETHOD.