CLASS zproforma_without_freight DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS :
      read_posts
        IMPORTING
                  martdoc         TYPE i_deliverydocumentitem-deliverydocument
                  year            TYPE string
        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check .
  PRIVATE SECTION.
    CLASS-DATA:  lv_xml TYPE string.
    CLASS-DATA:  lv_xml2 TYPE string.
ENDCLASS.



CLASS ZPROFORMA_WITHOUT_FREIGHT IMPLEMENTATION.


  METHOD read_posts.

    DATA: lv_xml       TYPE string,
          invdt        TYPE string,
          add1         TYPE string,
          add2         TYPE string,
          add3         TYPE string,
          add4         TYPE string,
          add5         TYPE string,
          add6         TYPE string,
          WESITE       TYPE string,
          cin          TYPE string,
          pan          TYPE string,
          gstin        TYPE string,
          msme         TYPE string,
          lv_address   TYPE string,
          lv_address1  TYPE string,
          lv_quatation TYPE string,
          lv_sono      TYPE string,
          lv_pono      TYPE string,
          lv_date      TYPE char10,
          lv_date1     TYPE char10,
          lv_date2     TYPE char10,
          lvpptterms   TYPE char24,
          lv_dterms    TYPE char24,
          n            TYPE char3,
          lv_tot_qty   TYPE i_salesdocumentitem-orderquantity,
          lv_tot_net   TYPE i_salesdocitempricingelement-conditionratevalue,
          lv_frieght   TYPE i_salesdocitempricingelement-conditionbaseamount,
          lv_tot_amt   TYPE i_salesdocitempricingelement-conditionbasevalue,
          lv_sale_off  TYPE string.

    TYPES: BEGIN OF ty_final,
             sno          TYPE char10,
             materialcode TYPE i_salesdocumentitem-product,
             materialdesc TYPE i_salesdocumentitem-salesdocumentitemtext,
             hsncode      TYPE i_productplantbasic-consumptiontaxctrlcode,
             hsncodetext  TYPE string,
             quantity     TYPE i_salesdocumentitem-orderquantity,
             uom          TYPE i_salesdocumentitem-baseunit,
             netprice     TYPE i_salesdocitempricingelement-conditionratevalue,
             discount     TYPE i_salesdocitempricingelement-conditionratevalue,
             netvalue     TYPE i_salesdocitempricingelement-conditionratevalue,
           END   OF ty_final.
    DATA: it_final TYPE TABLE OF ty_final,
          wa_final TYPE          ty_final.


    SELECT SINGLE plant,DistributionChannel  FROM i_salesquotationitem WHERE salesquotation = @martdoc
          INTO @DATA(lv_plant).

*    DATA FORM TYPE STRING.
*    IF lv_plant-DistributionChannel = '12'.
*        form = 'PROFORMA_INVOICE'.
*        ELSE .
*        form = 'sale_quotation_print' .
*        ENDIF.

    """"""""""Address
    msme = 'MSME/UDYAM-RJ-17-0509070 (Medium)'.
    add5 = 'Email:- jaipur@poddarpigmentsltd.com'.
    add6 =  'TEL NO: 0911412770202, 2770203, 2770287'.
    WESITE = 'Website – www.poddarpigmentsltd.com'.
    IF     lv_plant-Plant = '1000'.
      add1 = 'PODDAR PIGMENTS LIMITED'.
      add2 = '(REGISTERED WITH ISO 9001:2015-CERTIFICATE NO. FM 53726)'.
      add3 = 'REGD OFFICE & WORKS: PLOT E-10, 11, F-14 to 16, RIICO Industrial Area,Sitapura' .
      add4 = 'PIN CODE - 302022 (RAJASTHAN) INDIA'.
      cin  = 'L24117RJ1991PLC006307'.
      pan =  'AAACP1125E'.
      gstin = '08AAACP1125E2ZY'.

    ELSEIF lv_plant-Plant = '1100'.
      add1 = 'PODDAR PIGMENTS LIMITED'.
      add2 = '(REGISTERED WITH ISO 9001:2015-CERTIFICATE NO. FM 53726)'.
      add3 = 'REGD OFFICE & WORKS: PLOT E-10, 11, F-14 to 16, RIICO Industrial Area,Sitapura' .
      add4 = 'PIN CODE - 302022 (RAJASTHAN) INDIA'.
      cin  = 'L24117RJ1991PLC006307'.
      pan =  'AAACP1125E'.
      gstin = '08AAACP1125E1ZZ'.

    ELSEIF lv_plant-Plant = '1110'.
      add1 = 'PODDAR PIGMENTS LIMITED'.
      add2 = '(REGISTERED WITH ISO 9001:2015-CERTIFICATE NO. FM 53726)'.
      add3 = 'REGD OFFICE & WORKS: Greater Sitapura Industrial Park, National Highway 12' .
      add4 = '(Jaipur-Tonk Road), Brijpura village,Chaksu Jaipur 303901'.
      cin  = 'L24117RJ1991PLC006307'.
      pan =  'AAACP1125E'.
      gstin = '08AAACP1125E1ZZ'.

    ELSEIF lv_plant-Plant = '1200'.
      add1 = 'PODDAR PIGMENTS LIMITED'.
      add2 = '(REGISTERED WITH ISO 9001:2015-CERTIFICATE NO. FM 53726)'.
      add3 = 'REGD OFFICE & WORKS: Rosy Tower, 3rd Floor 8, Mahatma Gandhi Road, Nungambakkam' .
      add4 = ' Chennai 600034'.
      cin  = 'L24117RJ1991PLC006307'.
      pan =  'AAACP1125E'.
      gstin = '33AAACP1125E3Z4'.
    ENDIF.

    """"""""""""""Sold To Party
    SELECT SINGLE customer FROM i_salesquotationpartner WHERE salesquotation = @martdoc AND partnerfunction = 'WE'
           INTO @DATA(lv_customer).

    SELECT SINGLE internationalmobilephonenumber, emailaddress FROM i_salesquotationpartner WHERE salesquotation = @martdoc AND partnerfunction = 'AG'
           INTO @DATA(lv_shipmob).
    IF lv_customer IS NOT INITIAL.
      SELECT SINGLE bpcustomerfullname,
                    taxnumber3,
                    addressid FROM i_customer WHERE customer = @lv_customer
               INTO @DATA(lv_cust_name).
      SELECT SINGLE bpidentificationnumber FROM i_bupaidentification WHERE bpidentificationtype = 'PAN'
                                                                     AND  businesspartner = @lv_customer
               INTO @DATA(lv_pan1).
      SELECT SINGLE streetname,
      streetprefixname1,
      streetprefixname2,
      streetsuffixname1,
      streetsuffixname2,
      cityname,
      postalcode,
      region, country   FROM i_address_2 WITH PRIVILEGED ACCESS WHERE addressid = @lv_cust_name-addressid
          INTO @DATA(lv_add).
      SELECT SINGLE regionname FROM  i_regiontext  WHERE region = @lv_add-region
                                            AND   language = 'E' AND country = @lv_add-country
                                            INTO @DATA(lv_regionname) .
      SELECT SINGLE countryname FROM i_countrytext WHERE country = @lv_add-country AND language = 'E'
                                        INTO @DATA(lv_countryname)  .
      CONCATENATE lv_cust_name-bpcustomerfullname
         lv_add-streetname lv_add-streetprefixname1 lv_add-streetprefixname2 lv_add-streetsuffixname2
       lv_add-cityname "lv_add-postalcode
         lv_regionname lv_countryname INTO lv_address SEPARATED BY space.
    ENDIF.
    """"""""""""'Ship to party
    SELECT SINGLE customer FROM  i_salesquotationpartner WHERE salesquotation = @martdoc AND partnerfunction = 'RE'
               INTO @DATA(lv_customer1).
    SELECT SINGLE internationalmobilephonenumber, emailaddress FROM i_salesquotationpartner WHERE salesquotation = @martdoc AND partnerfunction = 'WE'
           INTO @DATA(lv_soldmob).
    IF lv_customer1 IS NOT INITIAL.
      SELECT SINGLE bpcustomerfullname,
                    taxnumber3,
                    addressid FROM i_customer WHERE customer = @lv_customer1
               INTO @DATA(lv_cust_name1).
      SELECT SINGLE bpidentificationnumber FROM i_bupaidentification WHERE bpidentificationtype = 'PAN'
                                                                     AND  businesspartner = @lv_customer1
               INTO @DATA(lv_pan2).
      SELECT SINGLE streetname,
      streetprefixname1,
      streetprefixname2,
      streetsuffixname1,
      streetsuffixname2,
      cityname,
      postalcode,
      region, country   FROM i_address_2 WITH PRIVILEGED ACCESS WHERE addressid = @lv_cust_name1-addressid
          INTO @DATA(lv_add1).
      SELECT SINGLE regionname FROM  i_regiontext  WHERE region = @lv_add1-region
                                            AND   language = 'E' AND country = @lv_add1-country
                                            INTO @DATA(lv_regionname1) .
      SELECT SINGLE countryname FROM i_countrytext WHERE country = @lv_add1-country AND language = 'E'
                                        INTO @DATA(lv_countryname1)  .
      CONCATENATE lv_cust_name1-bpcustomerfullname
         lv_add1-streetname lv_add1-streetprefixname1 lv_add1-streetprefixname2 lv_add1-streetsuffixname2
       lv_add1-cityname "lv_add1-postalcode
         lv_regionname1 lv_countryname1 INTO lv_address1 SEPARATED BY space.
    ENDIF.

    """"""""""Quotation No. / Date
    SELECT SINGLE salesquotation, creationdate, TransactionCurrency FROM i_salesquotation
         WHERE salesquotation = @martdoc INTO @DATA(lv_prece)  .
    IF lv_prece IS NOT INITIAL.

      CONCATENATE lv_prece-creationdate+6(2) '-' lv_prece-creationdate+4(2) '-' lv_prece-creationdate+0(4)
      INTO lv_date.
      CONCATENATE lv_prece-salesquotation '/' lv_date INTO lv_quatation SEPARATED BY space.

    ENDIF.
    """""""sales order No Date
    SELECT SINGLE salesquotation, creationdate, purchaseorderbycustomer,
                  customerpurchaseorderdate,
                  customerpaymentterms,
                  incotermsclassification,
                  incotermslocation1 FROM i_salesquotation
    WHERE salesquotation = @martdoc INTO @DATA(lv_document).
    IF lv_document IS NOT INITIAL.
      CONCATENATE lv_document-creationdate+6(2) '-' lv_document-creationdate+4(2) '-' lv_document-creationdate+0(4)
               INTO lv_date1.
*      CONCATENATE lv_document-salesdocument '/' lv_date1 INTO lv_sono SEPARATED BY space.

      """""""'Po No ANd Date
      CONCATENATE lv_document-customerpurchaseorderdate+6(2) '-' lv_document-customerpurchaseorderdate+4(2) '-' lv_document-customerpurchaseorderdate+0(4)
                 INTO lv_date2.
      CONCATENATE lv_document-purchaseorderbycustomer '/' lv_date2 INTO lv_pono SEPARATED BY space.

      """"""""Payment Terms
      SELECT SINGLE paymenttermsname FROM i_paymenttermstext WHERE paymentterms = @lv_document-customerpaymentterms
                                 INTO @lvpptterms.
      """"""""""Delivery terms
      CONCATENATE lv_document-incotermsclassification '-' lv_document-incotermslocation1 INTO lv_dterms.

      """"""""""""Dealer
      SELECT SINGLE customer FROM i_salesquotationpartner WHERE salesquotation = @martdoc AND partnerfunction = 'ZD'
                                     INTO @DATA(lv_cust) .
      IF lv_cust IS NOT INITIAL.
        SELECT SINGLE bpcustomerfullname   FROM i_customer WHERE customer = @lv_cust
                                       INTO @DATA(lv_bpcusname).
      ENDIF.
    ENDIF.


    """"""""""""""""'For Table Data
    SELECT
          a~product,
          a~salesquotationitemtext,
          a~salesquotationitem,
          a~salesquotation,
          a~orderquantity,
          a~baseunit,
          b~consumptiontaxctrlcode
               FROM i_salesquotationitem AS a
               LEFT OUTER JOIN i_productplantbasic AS b ON ( b~product = a~product AND b~Plant = a~Plant )
                WHERE salesquotation = @martdoc
               INTO TABLE @DATA(it_doc).

*DELETE ADJACENT DUPLICATES FROM it_doc COMPARING Product.
    IF it_doc IS NOT INITIAL.

      """""""""Net Value
      SELECT

                salesquotationitem,
                salesquotation,
                conditionratevalue
                FROM i_salesquotationitemprcgelmnt
                FOR ALL ENTRIES IN @it_doc WHERE salesquotation = @it_doc-salesquotation
                                           AND   salesquotationitem = @it_doc-salesquotationitem
                                           AND   conditiontype = 'ZPRI'
                 INTO TABLE @DATA(it_netvalue).

      """""""""""Discount
      SELECT

               salesquotationitem,
               salesquotation,
               conditionratevalue
               FROM i_salesquotationitemprcgelmnt
               FOR ALL ENTRIES IN @it_doc WHERE  salesquotation = @it_doc-salesquotation
                                          AND   salesquotationitem  = @it_doc-salesquotationitem
                                          AND   conditiontype IN ( 'ZDPQ', 'ZDCH' )
                INTO TABLE @DATA(it_discount).


      """"""""""""""Freight Charges

      SELECT

             salesquotationitem,
              salesquotation,
              conditionamount
             FROM i_salesquotationitemprcgelmnt
              FOR ALL ENTRIES IN @it_doc WHERE salesquotation = @it_doc-salesquotation
                                         AND   salesquotationitem  = @it_doc-salesquotationitem
                                         AND   conditiontype = 'ZFPW'
               INTO TABLE @DATA(it_frieght).

      SELECT sum( CONDITIONAMOUNT ) FROM I_SalesQuotationItemPrcgElmnt WHERE SalesQuotation = @martdoc
                                                                           AND ConditionType = 'ZFPW' INTO @DATA(frtcharg).

      SELECT sum( CONDITIONAMOUNT ) FROM I_SalesQuotationItemPrcgElmnt WHERE SalesQuotation = @martdoc
                                                                           AND ConditionType = 'ZGIV' INTO @DATA(GT_VALUE).

      """"""""""""TOTAL TAXABLE AMOUNT
      SELECT

             salesquotationitem,
             salesquotation,
             conditionbaseamount
            FROM i_salesquotationitemprcgelmnt
             FOR ALL ENTRIES IN @it_doc WHERE salesquotation = @it_doc-salesquotation
                                         AND   salesquotationitem  = @it_doc-salesquotationitem
                                        AND   conditiontype = 'ZTIV'
              INTO TABLE @DATA(it_tot).

      """""""""""

      SELECT
            SINGLE salesoffice FROM I_SalesQuotation WHERE SalesQuotation = @martdoc
            INTO @DATA(lv_salesoffice).
      IF lv_salesoffice IS NOT INITIAL.
        SELECT SINGLE salesofficename FROM i_salesofficetext WHERE salesoffice = @lv_salesoffice AND language = 'E'
             INTO @DATA(lv_salesofficename).
        CONCATENATE 'Sales Office:'  lv_salesofficename INTO lv_sale_off SEPARATED BY space.
      ENDIF.






      LOOP AT it_doc INTO DATA(wa_doc).
        n = n + 1.
        wa_final-sno = n.
        CONDENSE wa_final-sno.
        wa_final-materialcode = wa_doc-product.
        wa_final-materialdesc = wa_doc-SalesQuotationItemText.
        wa_final-hsncode = wa_doc-consumptiontaxctrlcode.

        if wa_doc-consumptiontaxctrlcode = '32049000' OR wa_doc-consumptiontaxctrlcode = '32061900'.
        wa_final-hsncodetext = 'COLOUR MASTERBATCHES'.
        ELSEIF  wa_doc-consumptiontaxctrlcode = '38122090'.
        wa_final-hsncodetext = 'ADDITIVE MASTERBATCHES'.
        ELSE.
         wa_final-hsncodetext = ''.
        ENDIF.

        wa_final-quantity = wa_doc-orderquantity.
        wa_final-uom     = wa_doc-baseunit.

        READ TABLE it_netvalue INTO DATA(wa_netvalue) WITH KEY SalesQuotation = wa_doc-SalesQuotation
                                                               SalesQuotationItem = wa_doc-SalesQuotationItem.
        IF sy-subrc = 0.
          wa_final-netprice = wa_netvalue-conditionratevalue.
        ENDIF.

        LOOP AT it_discount INTO DATA(wa_discount) WHERE SalesQuotation = wa_doc-SalesQuotation AND SalesQuotationItem = wa_doc-SalesQuotationItem.

          wa_final-discount = wa_final-discount + wa_discount-conditionratevalue.
        ENDLOOP.

        IF wa_final-discount < 0.
          wa_final-discount = wa_final-discount * -1.
        ENDIF.
        wa_final-netvalue = wa_final-netprice - wa_final-discount.

        lv_tot_qty = lv_tot_qty + wa_final-quantity.
        lv_tot_net = lv_tot_net + wa_final-netvalue.

        LOOP AT it_frieght INTO DATA(wa_frieght) WHERE SalesQuotation = wa_doc-SalesQuotation AND SalesQuotationItem = wa_doc-SalesQuotationItem.

          lv_frieght = lv_frieght + wa_frieght-conditionamount.
        ENDLOOP.


        LOOP AT it_tot INTO DATA(wa_tot) WHERE SalesQuotation = wa_doc-SalesQuotation AND SalesQuotationItem = wa_doc-SalesQuotationItem.

          lv_tot_amt = lv_tot_amt + wa_tot-conditionbaseamount.
        ENDLOOP.



        APPEND wa_final TO it_final.

        CLEAR: wa_final.

      ENDLOOP.

    ENDIF.


    DATA type1 TYPE string.

IF lv_plant-DistributionChannel = '12'.

    type1 = 'Export' .
ELSEIF  lv_plant-DistributionChannel = '13'.
 type1 = 'Deemed Export' .
ENDIF.


**********************************************************************

DATA:
ZT01_Delivery_Terms             TYPE string,
ZT02_Shipment_Note              TYPE string,
ZT03_Payment_Terms_Note         TYPE string,
ZT04_Packing_Mode_Instruction   TYPE string,
ZT05_Shipping_Port_Details      TYPE string,
ZT06_Remarks                    TYPE string,
ZT07_CONSIGNEE_BANKERS          TYPE string.
ZT01_Delivery_Terms           =   zcl_sales_quotation_itemtext=>Sales_Quotation_ItemText_DATA(  SalesQuotation =  wa_doc-SalesQuotation LongTextId = 'ZT01' )  .
ZT02_Shipment_Note            =   zcl_sales_quotation_itemtext=>Sales_Quotation_ItemText_DATA(  SalesQuotation =  wa_doc-SalesQuotation LongTextId = 'ZT02' )  .
ZT03_Payment_Terms_Note       =   zcl_sales_quotation_itemtext=>Sales_Quotation_ItemText_DATA(  SalesQuotation =  wa_doc-SalesQuotation LongTextId = 'ZT03' )  .
ZT04_Packing_Mode_Instruction =   zcl_sales_quotation_itemtext=>Sales_Quotation_ItemText_DATA(  SalesQuotation =  wa_doc-SalesQuotation LongTextId = 'ZT04' )  .
ZT05_Shipping_Port_Details    =   zcl_sales_quotation_itemtext=>Sales_Quotation_ItemText_DATA(  SalesQuotation =  wa_doc-SalesQuotation LongTextId = 'ZT05' )  .
ZT06_Remarks                  =   zcl_sales_quotation_itemtext=>Sales_Quotation_ItemText_DATA(  SalesQuotation =  wa_doc-SalesQuotation LongTextId = 'ZT06' )  .
ZT07_CONSIGNEE_BANKERS        =   zcl_sales_quotation_itemtext=>Sales_Quotation_ItemText_DATA(  SalesQuotation =  wa_doc-SalesQuotation LongTextId = 'ZT07' )  .
**********************************************************************

    lv_xml = |<form1>| &&
                  |<soldparty>{ lv_address }</soldparty>| &&
                  |<GST1>{ lv_cust_name-taxnumber3 }</GST1>| &&
                  |<PAN1>{ lv_pan1 }</PAN1>| &&
                  |<EMAIL1>{ lv_shipmob-emailaddress }</EMAIL1>| &&
                  |<MOBNO1>{ lv_shipmob-internationalmobilephonenumber }</MOBNO1>| &&
                  |<shipparty>{ lv_address1 }</shipparty>| &&
                  |<GST2>{ lv_cust_name1-taxnumber3 }</GST2>| &&
                  |<PAN2>{ lv_pan2 }</PAN2>| &&
                  |<EMAIL2>{ lv_soldmob-emailaddress }</EMAIL2>| &&
                  |<MOBNO2>{ lv_soldmob-internationalmobilephonenumber }</MOBNO2>| &&
                  |<QuotationNo>{ lv_quatation }</QuotationNo>| &&
                  |<SONo>{ lv_sono }</SONo>| &&
                  |<PONo>{ lv_pono }</PONo>| &&
                  |<Paymentterms>{ lvpptterms }</Paymentterms>| &&
                  |<Deliveryterms>{ lv_dterms }</Deliveryterms>| &&
                  |<type>{ type1 }</type>| &&
                  |<Dealer>{ lv_bpcusname }</Dealer>| &&
                  |<CONSIGNEEBANKERS>{ ZT07_CONSIGNEE_BANKERS }</CONSIGNEEBANKERS>| &&
                  |<Table1>| &&
                  |<HeaderRow>| &&
                  |<Currency>{ lv_prece-TransactionCurrency }</Currency>| &&
                  |<amountcryy>{ lv_prece-TransactionCurrency }</amountcryy>| &&
                  |</HeaderRow>| .





 DATA(IT1)  = it_final[].
SORT IT1  ASCENDING by hsncodetext.
DELETE ADJACENT DUPLICATES FROM IT1 COMPARING hsncodetext.
SORT IT1  ASCENDING by sno.

LOOP AT IT1 INTO DATA(wa_HSN).


lv_xml = lv_xml &&


 |      <Row1_HSN>| &&
 |        <Cell1>{ wa_HSN-hsncodetext }</Cell1> | .

LOOP AT it_final INTO wa_final WHERE hsncodetext = wa_HSN-hsncodetext.

lv_xml = lv_xml &&

            |<Row1>| &&
            |<SNO>{ wa_final-sno }</SNO>| &&
            |<MATCODE>{ wa_final-materialcode }</MATCODE>| &&
            |<MATDESC>{ wa_final-materialdesc }</MATDESC>| &&
            |<HSNCODE>{ wa_final-hsncode }</HSNCODE>| &&
            |<QTY>{ wa_final-quantity }</QTY>| &&
            |<UOM>{ wa_final-uom }</UOM>| &&
            |<NETPRICE>{ wa_final-netprice - wa_final-discount DECIMALS = 2 }</NETPRICE>| &&
            |<DISCOUNT>{ wa_final-discount DECIMALS = 2 }</DISCOUNT>| &&
            |<NETVALUE>{ wa_final-netvalue DECIMALS = 2 }</NETVALUE>| &&
            |<amount>{ ( wa_final-netprice - wa_final-discount ) * wa_final-quantity DECIMALS = 2 }</amount>|
            && |</Row1>|.
      CLEAR wa_final.
    ENDLOOP.
lv_xml = lv_xml &&
     |</Row1_HSN>| .

     ENDLOOP.


   lv_xml = lv_xml &&

    |<FooterRow>|   &&
              |<TOTQTY>{ lv_tot_qty }</TOTQTY>| &&
*              |<TOTNETVALUE>{ lv_tot_net }</TOTNETVALUE>| &&
              |<totalamount>{ lv_tot_amt }</totalamount>| &&
              |</FooterRow>| &&
              |</Table1>|.

lv_xml = lv_xml &&
   |<COMPBANK></COMPBANK>| &&
   |<ACCHOLD></ACCHOLD>| &&
   |<BANKNAME></BANKNAME>| &&
   |<ACCNO></ACCNO>| &&
   |<BRANCHIFSC></BRANCHIFSC>| &&
   |<FREIGHTCHARGES>{ lv_frieght }</FREIGHTCHARGES>| &&
   |<TAXAMT>{ lv_tot_amt }</TAXAMT>| &&
   |<IGST></IGST>| &&
   |<ROUNDOFF></ROUNDOFF>| &&
   |<GROSSTOTAL></GROSSTOTAL>| &&
   |<TextField1></TextField1>|.
lv_xml = lv_xml &&
 |<AddA1>{ add1 }</AddA1>| &&
 |<ADDA2>{ add2 }</ADDA2>| &&
 |<ADDA3>{ add3 }</ADDA3>| &&
 |<ADDA4>{ add4 }</ADDA4>| &&
 |<ADDA5>{ add5 }</ADDA5>| &&
 |<GSTA1>{ gstin }</GSTA1>| &&
 |<PANA1>{ pan }</PANA1>| &&
 |<CINA1>{ cin }</CINA1>| &&
 |<MSME>{ lv_sale_off }</MSME>| &&
 |<ADDA6>{ add6 }</ADDA6>| &&
 |<WESITEON>{ WESITE }</WESITEON>| &&
 |<Subform3>| &&
 |<Freightcharges2>{ frtcharg }</Freightcharges2>| &&
 |<GrossTotal2>{ gt_value }</GrossTotal2>| &&
 |</Subform3>| &&
 |<Subform2>| &&
 |<DELIVERYTERMS>{ zt01_delivery_terms }</DELIVERYTERMS>| &&
 |<PAYMENTTREMS>{ zt03_payment_terms_note }</PAYMENTTREMS>| &&
 |<SHIPMENT>{ zt02_shipment_note }</SHIPMENT>| &&
 |<PACKINGMODE>{ zt04_packing_mode_instruction }</PACKINGMODE>| &&
 |<COUNTRYOFORIGIN></COUNTRYOFORIGIN>| &&
 |<SHIPPINGPORT>{ zt05_shipping_port_details }</SHIPPINGPORT>| &&
 |<REMARK>{ zt06_remarks }</REMARK>| &&
 |</Subform2> | &&
 |</form1>|.


    CALL METHOD zadobe_print=>adobe
      EXPORTING
        xml       = lv_xml
        form_name = 'PROFORMA_INVOICE'
      RECEIVING
        result    = result12.

  ENDMETHOD.
ENDCLASS.
