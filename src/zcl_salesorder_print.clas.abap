CLASS ZCL_SALESORDER_PRINT DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.
    INTERFACES if_oo_adt_classrun_out.

ENDCLASS.



CLASS ZCL_SALESORDER_PRINT IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    DATA(req) = request->get_form_fields( ).

    DATA: lv_sales_doc    TYPE i_deliverydocumentitem-deliverydocument,
          lv_quote_doc    TYPE i_deliverydocumentitem-deliverydocument,
          lv_form_type    TYPE string,
          lv_pdf          TYPE string,
          resp            TYPE string.

    lv_sales_doc = VALUE #( req[ name = 'salesorderno' ]-value OPTIONAL ).
    lv_quote_doc = VALUE #( req[ name = 'quotationnumber' ]-value OPTIONAL ).
    lv_form_type = VALUE #( req[ name = 'type' ]-value OPTIONAL ).


    IF lv_sales_doc IS NOT INITIAL.
      lv_sales_doc = |{ lv_sales_doc  ALPHA = IN }|.
    ENDIF.

    IF lv_quote_doc IS NOT INITIAL.
      lv_quote_doc = |{ lv_quote_doc ALPHA = IN }|.
    ENDIF.

    CASE lv_form_type.

      WHEN 'Sales Order'.
        lv_pdf = zsd_salesorder_print=>read_posts( martdoc = lv_sales_doc year = '' ).

      WHEN 'Sales Quotation'.
        lv_pdf = zsd_quotation_print=>read_posts( martdoc = lv_quote_doc year = '' ).

      WHEN 'Proforma invoice print (without freight breakup)'.
        lv_pdf = zproforma_without_freight=>read_posts( martdoc = lv_quote_doc year = '' ).

      WHEN 'Proforma invoice print (with freight breakup)'.
        lv_pdf = zproforma_with_freight=>read_posts(   martdoc = lv_quote_doc  year = '' ).
      WHEN 'Price Approval Print'.
        lv_pdf = zsd_price_approval_print=>read_posts(  martdoc = lv_quote_doc   year    = '' ).
      WHEN OTHERS.
        lv_pdf = 'Invalid form type specified.'.
    ENDCASE.


    response->set_text( lv_pdf ).

  ENDMETHOD.
ENDCLASS.
